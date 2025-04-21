//
// AttributedText.swift
//

import RegexBuilder
import SwiftUI

public struct AttributedText: View {
  static let attributedURL = URL(string: "urlForAttributedText://")!

  let prefixes: [String]

  let prefixAction: (String, String) -> Void
  let urlAction: ((URL) -> Void)?
  
  public init(
    text: String,
    prefixes: [AttributedPrefix],
    urlContainer: AttributeContainer,
    prefixAction: @escaping (String, String) -> Void,
    urlAction: ((URL) -> Void)? = nil
  ) {
    self.prefixes = prefixes.map(\.prefix)
    self.prefixAction = prefixAction
    self.attributedText = AttributedString(text)
      .addingURL(container: urlContainer)
      .addingPrefixLink(prefixes: prefixes)
    self.urlAction = urlAction
  }

  let attributedText: AttributedString

  public var body: some View {
    Text(attributedText)
      .environment(
        \.openURL,
        OpenURLAction { url in
          guard url.scheme == AttributedText.attributedURL.scheme else {
            if let urlAction {
              urlAction(url)
              return .handled
            } else {
              return .systemAction(url)
            }
          }

          let query = url.queryItems.first { $0.name == "query" }!.value!

          let prefix = prefixes.first {
            let prefix = $0

            guard prefix.startIndex <= query.endIndex && prefix.endIndex <= query.endIndex else {
              return false
            }
            return prefix == query[prefix.startIndex..<prefix.endIndex]
          }!

          prefixAction(prefix, query)

          return .handled
        })
  }
}

#Preview {
  Preview(text: """
url https://swift.org/
hashtag #Swift
mention @Swift
and &swift
""")
  .frame(maxWidth: 500, maxHeight: 500)
}

public struct Preview: View {
  @State var path = NavigationPath()

  let text: String

  public init(text: String) {
    self.text = text
  }

  public var body: some View {
    NavigationStack(path: $path) {
      AttributedText(
        text: text,
        prefixes: [
          .init(prefix: "@", container: .mentionContainer),
          .init(prefix: "#", container: .hashtagContainer),
          .init(prefix: "&", container: .andContainer),
        ],
        urlContainer: AttributeContainer.foregroundColor(.blue)
      ) { (prefixString, query) in
        let viewItem = ViewData(
          text: query,
          type: .init(rawValue: prefixString)!
        )
        path.append(viewItem)
      } urlAction: { url in
        self.path.append(url)
      }
      .navigationTitle("Home")
      .navigationDestination(for: ViewData.self) { viewData in
        switch viewData.type {
        case .hashtag: HashtagView(hashtag: viewData.text).navigationTitle("Hashtag")
        case .mention: MentionView(mention: viewData.text).navigationTitle("Mention")
        case .and: AndView(and: viewData.text).navigationTitle("And")
        }
      }
      .navigationDestination(for: URL.self) { url in
        WebView(url: url)
          .navigationTitle(url.host() ?? url.absoluteString)
      }
    }
  }
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

extension AttributeContainer {
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
    container.font = .title.bold()
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

struct WebView: View {
  let url: URL
  
  var body: some View {
    Text(url.absoluteString)
  }
}
