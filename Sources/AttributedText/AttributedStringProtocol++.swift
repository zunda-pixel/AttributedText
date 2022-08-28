//
// AttributedStringProtocol++.swift
//


import Foundation

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
