//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Sebastian Penafiel on 5/29/20.
//  Copyright © 2020 Sebastian Penafiel. All rights reserved.
//

import SwiftUI

/*
 ** HOW H/V/Z Stacks layout themselves **
 the stacks first take the available size provided by their container
 then begin to assign a size to each of their subviews, starting with
 the LEAST flexible view, such as Image which requires a fixed size,
 after that it goes to the next least flexible until it finishes all the views,
 after all their views have their size allocated, the stack then resizes itself
 to fit it
 (this priority can be modified with `.layoutPriority()`
 */

struct EmojiMemoryGameView: View {
  // this var has an ObservableObject, and anytime
  // that var calls objectWillChange.send(), it will re-draw the card
  @ObservedObject var viewModel: EmojiMemoryGame
  // must exist
  // `some` means its any type that has the following type,
  // in this case View
  // this is a computed var
  var body: some View {
    // `HStack(content: { ... })` is the same as
    // `HStack() { ... }` as well as
    // `HStack {}` when no arguments are passed
    Grid(viewModel.cards){ card in
      CardView(card: card).onTapGesture {
        self.viewModel.choose(card: card)
      }
      .padding(5)
    }
      // applies it to all subviews
      .foregroundColor(Color.orange)
      .padding()
  }
}

struct CardView: View {
  var card: MemoryGame<String>.Card
  
  var body: some View {
    GeometryReader { geometry in self.body(for: geometry.size)}
  }
  
  // this is simply to avoid the need for adding
  // .self to all external references when using
  // GeometryReader closure
  func body(for size: CGSize) -> some View {
    // one line will auto return
    // so return keyword is not necessary
    ZStack {
      if card.isFaceUp {
        // white background
        // orange border
        RoundedRectangle(cornerRadius: CORNER_RADIUS).fill(Color.white)
        RoundedRectangle(cornerRadius: CORNER_RADIUS).stroke(lineWidth: EDGE_LINE_WIDTH)
        Text(card.content)
      } else {
        // only draw if card isnt matched
        if !card.isMatched {
          RoundedRectangle(cornerRadius: CORNER_RADIUS).fill()
        }
      }
    }
    .font(Font.system(size: fontSize(for: size)))
  }
  
  // MARK: - Drawing Constants
  
  let CORNER_RADIUS: CGFloat = 10
  let EDGE_LINE_WIDTH: CGFloat = 3.0
  let FONT_SCALE_FACTOR: CGFloat = 0.75
  
  private func fontSize(for size: CGSize) -> CGFloat {
    min(size.width, size.height) * FONT_SCALE_FACTOR
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
  }
}
