//
// SampleContentView.swift
//


import SwiftUI

public struct SampleContentView: View {
  @State var path = NavigationPath()

  @Environment(\.openURL) var openURL

  @State var viewItem: ViewData?

  let text: String

  public init(text: String = "url https://www.swift.org/getting-started/ hashtag #Swift mention @Swift &swift") {
    self.text = text
  }

  public var body: some View {
    NavigationStack(path: $path) {
      AttributedText(text: text)
        .navigationDestination(for: ViewData.self) { viewData in
          switch viewData.type {
            case .hashtag: HashtagView(hashtag: viewData.text).navigationTitle("Hashtag")
            case .mention: MentionView(mention: viewData.text).navigationTitle("Mention")
            case .and: AndView(and: viewData.text).navigationTitle("And")
          }
        }
    }
    .onOpenURL { url in
      let query = url.queryItems.first { $0.name == "query" }?.value

      guard let query else { return }

      switch url.scheme {
        case (URLSchemeAction.hashtagAction.link! as URL).scheme: path.append(ViewData(text: query, type: .hashtag))
        case (URLSchemeAction.mentionAction.link! as URL).scheme: path.append(ViewData(text: query, type: .mention))
        case (URLSchemeAction.andAction.link! as URL).scheme:
          path.append(ViewData(text: query, type: .and))
        default: fatalError()
      }
    }
  }
}

extension AttributedText {
  init(text: String) {
    self.init(
      text: text,
      prefixes: [
        "&": URLSchemeAction.andAction,
        "@": URLSchemeAction.mentionAction,
        "#": URLSchemeAction.hashtagAction,
      ],
      urlContainer: AttributeContainer.foregroundColor(.blue)
    )
  }
}

struct URLSchemeAction {
  static var andAction: AttributeContainer {
    var container = AttributeContainer()
    container.link = URL(string: "testApp-and://")
    container.foregroundColor = .yellow
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
    case and
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
    SampleContentView()
  }
}
