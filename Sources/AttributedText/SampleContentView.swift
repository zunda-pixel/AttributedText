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
          case (URLSchemeAction.urlAction.link! as URL).scheme: openURL(URL(string: query)!)
          case (URLSchemeAction.hashtagAction.link! as URL).scheme: path.append(ViewData(text: query, type: .hashtag))
          case (URLSchemeAction.mentionAction.link! as URL).scheme: path.append(ViewData(text: query, type: .mention))

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
      urlAction: URLSchemeAction.urlAction,
      hashtagAction: URLSchemeAction.hashtagAction,
      mentionAction: URLSchemeAction.mentionAction,
      action: action
    )
  }
}

struct URLSchemeAction {
  static var urlAction: AttributeContainer {
    var container = AttributeContainer()
    container.link = URL(string: "testApp-url://")
    container.foregroundColor = .blue
    return container
  }

  static var hashtagAction: AttributeContainer {
    var container = AttributeContainer()
    container.link = URL(string: "testApp-hashtag://")
    container.foregroundColor = .red
    return container
  }

  static var mentionAction: AttributeContainer {
    var container = AttributeContainer()
    container.link = URL(string: "testApp-mention://")
    container.foregroundColor = .green
    return container
  }
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
