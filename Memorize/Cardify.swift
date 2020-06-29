//
//  Cardify.swift
//  Memorize
//
//  Created by Sebastian Penafiel on 6/29/20.
//  Copyright © 2020 Sebastian Penafiel. All rights reserved.
//

import SwiftUI

struct Cardify: ViewModifier {
  var isFaceUp: Bool
  
  // Content is a Generic created in ViewModifier
  func body(content: Content) -> some View {
    ZStack {
      if isFaceUp {
        // white background
        // orange border
        RoundedRectangle(cornerRadius: CORNER_RADIUS).fill(Color.white)
        RoundedRectangle(cornerRadius: CORNER_RADIUS).stroke(lineWidth: EDGE_LINE_WIDTH)
        content
      } else {
        RoundedRectangle(cornerRadius: CORNER_RADIUS).fill()
      }
    }
  }
  
  // MARK: - Drawing Constants
  
  private let CORNER_RADIUS: CGFloat = 10
  private let EDGE_LINE_WIDTH: CGFloat = 3.0
}

extension View {
  
  func cardify(isFaceUp: Bool) -> some View {
    self.modifier(Cardify(isFaceUp: isFaceUp))
  }
}
