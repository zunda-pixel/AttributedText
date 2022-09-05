//
// URL++.swift
//

import Foundation

extension URL {
  var queryItems: [URLQueryItem] {
    guard let urlComponents: URLComponents = .init(url: self, resolvingAgainstBaseURL: true) else {
      return []
    }

    return urlComponents.queryItems ?? []
  }
}
