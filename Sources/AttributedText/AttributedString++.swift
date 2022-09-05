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
  func addingURL(container: AttributeContainer) -> Self {
    var attributedString = self

    let regex = Regex {
      OneOrMore(.url())
    }

    let text = String(attributedString.characters)

    for match in text.matches(of: regex) {
      let stringValue = String(match.0)

      let ranges = attributedString.matchAll(stringValue)

      for range in ranges {
        var container = container
        container.link = URL(string: stringValue)!

        attributedString[range].setAttributes(container)
      }
    }

    return attributedString
  }

  func addingPrefixLink(prefixes: [AttributedPrefix]) -> Self {
    var attributedString = self

    for item in prefixes {
      let regex = Regex {
        item.prefix
        OneOrMore(.word)
      }

      let text = String(attributedString.characters)

      for match in text.matches(of: regex) {
        let stringValue = String(match.0)
        guard item.prefix.startIndex <= stringValue.endIndex && item.prefix.endIndex <= stringValue.endIndex  else { continue }

        let ranges = attributedString.matchAll(stringValue)

        for range in ranges {
          var container = container
          var url = container.link as URL?
          url?.append(queryItems: [.init(name: "query", value: stringValue)])
          container.link = url
          attributedString[range].setAttributes(container)
        }
      }
    }

    return attributedString
  }
}


