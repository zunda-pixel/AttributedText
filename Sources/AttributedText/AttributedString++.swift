//
// AttributedStringProtocol++.swift
//


import Foundation
import RegexBuilder

extension AttributedStringProtocol {
  func match(_ pattern: String, options: String.CompareOptions? = nil) -> Range<AttributedString.Index>? {
    let options = options?.union(.regularExpression) ?? .regularExpression
    return self.range(of: pattern, options: options)
  }

  func matchAll(_ pattern: String, options: String.CompareOptions? = nil) -> [Range<AttributedString.Index>] {
    guard let range = match(pattern, options: options) else {
      return []
    }

    let remaining = self[range.upperBound...]
    return [range] + remaining.matchAll(pattern, options: options)
  }
}

extension AttributedString {
  func addingURL(container: AttributeContainer) -> AttributedString {
    var attributedString = self

    let regex = Regex {
      OneOrMore(.url())
    }

    let text = String(attributedString.characters)

    for match in text.matches(of: regex) {
      let stringValue = String(match.0)

      let ranges = attributedString.matchAll(stringValue)

      for range in ranges {
        var con = container
        con.link = URL(string: stringValue)!
        attributedString[range].setAttributes(con)
      }
    }

    return attributedString
  }

  func addingPrefixLink(prefixes: [String: AttributeContainer]) -> AttributedString {
    var attributedString = self

    for (prefix, container) in prefixes {
      let regex = Regex {
        prefix
        OneOrMore(.word)
      }

      let text = String(attributedString.characters)

      for match in text.matches(of: regex) {
        let stringValue = String(match.0)
        guard prefix.startIndex <= stringValue.endIndex && prefix.endIndex <= stringValue.endIndex  else { continue }

        let ranges = attributedString.matchAll(stringValue)

        for range in ranges {
          var con = container
          var url = container.link as URL?
          url?.append(queryItems: [.init(name: "query", value: stringValue)])
          con.link = url
          attributedString[range].setAttributes(con)
        }
      }
    }

    return attributedString
  }
}


