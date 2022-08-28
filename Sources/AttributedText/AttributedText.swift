//
// AttributedText.swift
//


import SwiftUI
import RegexBuilder

public struct AttributedText: View {
  let text: String

  let urlAction: AttributeContainer
  let hashtagAction: AttributeContainer
  let mentionAction: AttributeContainer

  let action: OpenURLAction

  public typealias OpenURLAction = (_ url: URL, _ query: String) -> Void

  public init(text: String, urlAction: AttributeContainer, hashtagAction: AttributeContainer, mentionAction: AttributeContainer, action: @escaping OpenURLAction) {
    self.text = text
    self.urlAction = urlAction
    self.hashtagAction = hashtagAction
    self.mentionAction = mentionAction
    self.action = action
  }

  let urlRegex: some RegexComponent = Regex {
    OneOrMore(.url())
  }

  let mentionRegex: some RegexComponent = Regex {
    "@"
    OneOrMore(.whitespace.inverted)
  }

  let hashtagRegex: some RegexComponent = Regex {
    "#"
    OneOrMore(.whitespace.inverted)
  }

  var attributedText: AttributedString {
    var attributedText = AttributedString(text)

    let regex = Regex {
      ChoiceOf {
        urlRegex
        mentionRegex
        hashtagRegex
      }
    }

    for match in text.matches(of: regex) {
      let stringValue = String(match.0)

      let ranges = attributedText.matchAll(stringValue)

      for range in ranges {
        var action: AttributeContainer

        if stringValue.wholeMatch(of: urlRegex) != nil {
          action = urlAction
        }
        else if stringValue.wholeMatch(of: mentionRegex) != nil {
          action = mentionAction
        }
        else if stringValue.wholeMatch(of: hashtagRegex) != nil {
          action = hashtagAction
        }
        else {
          fatalError()
        }

        let value = String(attributedText.characters[range])

        var url = action.link as URL?
        url?.append(queryItems: [.init(name: "query", value: value)])
        action.link = url

        attributedText[range].setAttributes(action)
      }
    }

    return attributedText
  }

  public var body: some View {
    Text(attributedText)
      .onOpenURL { url in
        let query = url.queryItems.first { $0.name == "query" }!.value!

        action(url, query)
      }
  }
}
