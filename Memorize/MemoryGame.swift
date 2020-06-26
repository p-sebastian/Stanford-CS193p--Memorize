//
//  MemoryGame.swift
//  Memorize
//
//  Created by Sebastian Penafiel on 5/30/20.
//  Copyright © 2020 Sebastian Penafiel. All rights reserved.
//

import Foundation

struct MemoryGame<CardContent> {
    var cards: [Card]
    
    mutating func choose(card: Card) {
        print("card chose\(card)")
        let chosenIndex: Int = index(of: card)!
        // replacing inside the array because its an struct
        // this creates a new array with the changes
        // and mutating notes it
        cards[chosenIndex].isFaceUp = !cards[chosenIndex].isFaceUp
    }
    
    func index(of findMe: Card) -> Int? {
        cards.firstIndex() { card in card.id == findMe.id }
    }
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent ) {
        cards = [Card]()
        func makeCard(with id: Int, pair: Int) -> Card {
            Card(content: cardContentFactory(pair), id: id)
        }
        for pair in 0..<numberOfPairsOfCards {
            cards.append(makeCard(with: pair * 2, pair: pair))
            cards.append(makeCard(with: pair * 2 + 1, pair: pair))
        }
        cards.shuffle()
    }
    
    // Identifiable allows iteration in ForEach
    struct Card: Identifiable {
        var isFaceUp: Bool = true
        var isMatched: Bool = false
        var content: CardContent
        var id: Int
    }
}
