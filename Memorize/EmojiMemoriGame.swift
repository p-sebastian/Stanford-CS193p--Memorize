//
//  EmojiMemoriGame.swift
//  Memorize
//
//  Created by Sebastian Penafiel on 5/30/20.
//  Copyright © 2020 Sebastian Penafiel. All rights reserved.
//

import SwiftUI

// ObservableObject only works on clases
class EmojiMemoryGame: ObservableObject {
  // @Published will call objectWillChange.send, any time the var changes
  @Published private var model: MemoryGame<String> = createMemoryGame()
  
  private static func createMemoryGame() -> MemoryGame<String> {
    let emojis: [String] = ["👻", "🎃", "🕸"]
    return MemoryGame<String>(numberOfPairsOfCards: emojis.count) { pair in emojis[pair] }
  }
  
  // MARK: - Access to the model
  var cards: [MemoryGame<String>.Card] {
    model.cards
  }
  
  // MARK: - Intent(s)
  func choose(card: MemoryGame<String>.Card) {
    model.choose(card: card)
  }
}
