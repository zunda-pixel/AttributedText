//
// SampleContentView.swift
//


import SwiftUI

public struct SampleContentView: View {
  @State var path = NavigationPath()

  @Environment(\.openURL) var openURL

  @State var viewItem: ViewData?

  let text: String

  public init(text: String = "url https://www.swift.org/getting-started/ hashtag #Swift mention @Swift") {
    self.text = text
  }

  public var body: some View {
    NavigationStack(path: $path) {
      AttributedText(text: text ) { (url, query) in
        switch url.scheme {
          case URLScheme.urlAction.url.scheme: openURL(URL(string: query)!)
          case URLScheme.hashtagAction.url.scheme: path.append(ViewData(text: query, type: .hashtag))
          case URLScheme.mentionAction.url.scheme: path.append(ViewData(text: query, type: .mention))

          default: fatalError()
        }
      }
      .navigationDestination(for: ViewData.self) { viewData in
        switch viewData.type {
          case .hashtag: HashtagView(hashtag: viewData.text).navigationTitle("Hashtag")
          case .mention: MentionView(mention: viewData.text).navigationTitle("Mention")
        }
      }
    }
  }
}

extension AttributedText {
  init(text: String, action: @escaping OpenURLAction) {
    self.init(
      text: text,
      urlAction: URLScheme.urlAction,
      hashtagAction: URLScheme.hashtagAction,
      mentionAction: URLScheme.mentionAction,
      action: action
    )
  }
}

struct URLScheme {
  static let urlAction: AttributedAction = .init(url: .init(string: "testApp-url://")!, color: .blue)
  static let hashtagAction: AttributedAction = .init(url: .init(string: "testApp-hashtag://")!, color: .red)
  static let mentionAction: AttributedAction = .init(url: .init(string: "testApp-mention://")!, color: .green)
}

struct ViewData: Codable, Hashable {
  enum ViewType: Codable {
    case hashtag
    case mention
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

struct SampleContentView_Previews: PreviewProvider {
  static var previews: some View {
    SampleContentView()
  }
}
