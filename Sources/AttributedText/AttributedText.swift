//
// AttributedText.swift
//

import RegexBuilder
import SwiftUI

public struct AttributedText: View {
  static let attributedURL = URL(string: "urlForAttributedText://")!

  let prefixes: [String]

  let action: (String, String) -> Void

  public init(
    text: String, prefixes: [AttributedPrefix], urlContainer: AttributeContainer,
    action: @escaping (String, String) -> Void
  ) {
    self.prefixes = prefixes.map(\.prefix)

    self.attributedText = AttributedString(text)
      .addingURL(container: urlContainer)
      .addingPrefixLink(prefixes: prefixes)

    self.action = action
  }

  let attributedText: AttributedString

  public var body: some View {
    Text(attributedText)
      .environment(
        \.openURL,
        OpenURLAction { url in
          guard url.scheme == AttributedText.attributedURL.scheme else {
            return .systemAction(url)
          }

          let query = url.queryItems.first { $0.name == "query" }!.value!

          let prefix = prefixes.first {
            let prefix = $0

            guard prefix.startIndex <= query.endIndex && prefix.endIndex <= query.endIndex else {
              return false
            }
            return prefix == query[prefix.startIndex..<prefix.endIndex]
          }!

          action(prefix, query)

          return .handled
        })
  }
}
