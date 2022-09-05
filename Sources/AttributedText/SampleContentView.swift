//
// SampleContentView.swift
//

import SwiftUI

public struct SampleContentView: View {
  @State var path = NavigationPath()

  let text: String

  public init(text: String) {
    self.text = text
  }

  public var body: some View {
    NavigationStack(path: $path) {
      AttributedText(text: text) { (prefixString, query) in
        let viewItem = ViewData(text: query, type: .init(rawValue: prefixString)!)
        path.append(viewItem)
      }
      .navigationDestination(for: ViewData.self) { viewData in
        switch viewData.type {
        case .hashtag: HashtagView(hashtag: viewData.text).navigationTitle("Hashtag")
        case .mention: MentionView(mention: viewData.text).navigationTitle("Mention")
        case .and: AndView(and: viewData.text).navigationTitle("And")
        }
      }
    }
  }
}

extension AttributedText {
  init(text: String, action: @escaping (String, String) -> Void) {
    self.init(
      text: text,
      prefixes: [
        .init(prefix: "@", container: PrefixContainer.mentionContainer),
        .init(prefix: "#", container: PrefixContainer.hashtagContainer),
        .init(prefix: "&", container: PrefixContainer.andContainer),
      ],
      urlContainer: AttributeContainer.foregroundColor(.blue),
      action: action
    )
  }
}

struct PrefixContainer {
  static var andContainer: AttributeContainer {
    var container = AttributeContainer()
    container.foregroundColor = .orange
    return container
  }

  static var hashtagContainer: AttributeContainer {
    var container = AttributeContainer()
    container.foregroundColor = .red
    container.underlineStyle = .single
    return container
  }

  static var mentionContainer: AttributeContainer {
    var container = AttributeContainer()
    container.foregroundColor = .green
    container.font = .largeTitle
    return container
  }
}

struct ViewData: Codable, Hashable {
  enum ViewType: String, Codable {
    case hashtag = "#"
    case mention = "@"
    case and = "&"
  }

  let text: String
  let type: ViewType
}

struct HashtagView: View {
  let hashtag: String

  var body: some View {
    Text(hashtag)
  }
}

struct MentionView: View {
  let mention: String

  var body: some View {
    Text(mention)
  }
}

struct AndView: View {
  let and: String

  var body: some View {
    Text(and)
  }
}

struct SampleContentView_Previews: PreviewProvider {
  static var previews: some View {
    SampleContentView(text: "url https://www.swift.org/ hashtag #Swift mention @Swift &swift")
  }
}
