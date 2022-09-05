//
// AttributedPrefix.swift
//

import Foundation

public struct AttributedPrefix {
  let prefix: String
  let container: AttributeContainer

  public init(prefix: String, container: AttributeContainer) {
    self.prefix = prefix
    self.container = container
  }
}
