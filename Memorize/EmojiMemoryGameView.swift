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
    VStack {
      Grid(viewModel.cards){ card in
        CardView(card: card).onTapGesture {
          withAnimation(.linear) {
            self.viewModel.choose(card: card)
          }
        }
        .padding(5)
      }
        // applies it to all subviews
        .foregroundColor(Color.orange)
        .padding()
      Button(action: {
        withAnimation(.easeInOut) { self.viewModel.resetGame() }
      }) { Text("New Game") }
    }
  }
}

struct CardView: View {
  var card: MemoryGame<String>.Card
  
  var body: some View {
    GeometryReader { geometry in self.body(for: geometry.size)}
  }
  
  // this local State, syncs with the changes of the model to continuosly
  // update the View with the animation
  @State private var animatedBonusRemaining: Double = 0
  
  private func startBonusTimeAnimation() {
    // force sync
    animatedBonusRemaining = card.bonusRemaining
    withAnimation(.linear(duration: card.bonusTimeRemaining)) {
      animatedBonusRemaining = 0
    }
  }
  
  // this is simply to avoid the need for adding
  // .self to all external references when using
  // GeometryReader closure
  // @ViewBuilder, iterpretes everything inside as a List of Views,
  // so it takes care of not returning anything, which on ViewBuilder
  // means an empty View
  @ViewBuilder
  private func body(for size: CGSize) -> some View {
    if card.isFaceUp || !card.isMatched {
      // one line will auto return
      // so return keyword is not necessary
      ZStack {
        Group {
          if card.isConsumingBonusTime {
            // coordinates start from the top left as 0,0
            Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-animatedBonusRemaining * 360 - 90), clockwise: true)
              .onAppear {
                self.startBonusTimeAnimation()
            }
          } else {
            Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-card.bonusRemaining * 360 - 90), clockwise: true)
          }
        }
        .padding(5).opacity(0.4)
        Text(card.content)
          .font(Font.system(size: fontSize(for: size)))
          .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
          .animation(card.isMatched ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default)
        // cardify is an extension of View
      }
      .cardify(isFaceUp: card.isFaceUp)
      .transition(AnyTransition.scale)
    }
  }
  
  // MARK: - Drawing Constants
  
  private let FONT_SCALE_FACTOR: CGFloat = 0.7
  
  private func fontSize(for size: CGSize) -> CGFloat {
    min(size.width, size.height) * FONT_SCALE_FACTOR
  }
}

// just for the preview
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    let game = EmojiMemoryGame()
    game.choose(card: game.cards[0])
    return EmojiMemoryGameView(viewModel: game)
  }
}
