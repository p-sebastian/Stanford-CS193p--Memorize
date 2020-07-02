//
//  Cardify.swift
//  Memorize
//
//  Created by Sebastian Penafiel on 6/29/20.
//  Copyright © 2020 Sebastian Penafiel. All rights reserved.
//

import SwiftUI

// Switchting to AnimatableModifier is just ViewModifier with Animatable
// and it is needed for the View to actually Animate
struct Cardify: AnimatableModifier {
  var rotation: Double
  var isFaceUp: Bool {
    rotation < 90
  }
  
  init(isFaceUp: Bool) {
    rotation = isFaceUp ? 0 : 180
  }
  
  // just for readability, we se it to rotation
  // rotation is the value we want to animate, but
  // animatableData is the value that transitions
  var animatableData: Double {
    get { return rotation }
    set { rotation = newValue }
  }
  
  // Content is a Generic created in ViewModifier
  func body(content: Content) -> some View {
    ZStack {
      // removed the if, to make is so that the View does change to `hidden` with opacity
      // this allows the transition animation of rotating to happen, because the View `is` changing
      Group {
        // white background
        // orange border
        RoundedRectangle(cornerRadius: CORNER_RADIUS).fill(Color.white)
        RoundedRectangle(cornerRadius: CORNER_RADIUS).stroke(lineWidth: EDGE_LINE_WIDTH)
        content
      }
      .opacity(isFaceUp ? 1 : 0)
      RoundedRectangle(cornerRadius: CORNER_RADIUS).fill()
        .opacity(isFaceUp ? 0 : 1)
    }
    .rotation3DEffect(Angle.degrees(rotation), axis: (0,1,0))
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
