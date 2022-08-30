//
// AttributedText.swift
//


import SwiftUI
import RegexBuilder

public struct AttributedText: View {
  public init(text: String, prefixes: [String : AttributeContainer], urlContainer: AttributeContainer) {
    self.attributedText = AttributedString(text).addingURL(container: urlContainer).addingPrefixLink(prefixes: prefixes)
  }

  let attributedText: AttributedString

  public var body: some View {
    Text(attributedText)
  }
}
