//
//  MemoryGame.swift
//  Memorize
//
//  Created by Sebastian Penafiel on 5/30/20.
//  Copyright © 2020 Sebastian Penafiel. All rights reserved.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
  private(set) var cards: [Card]
  
  private var indexOfTheOneAndOnlyFaceUpCard: Int? {
    get { cards.indices.filter { cards[$0].isFaceUp}.only }
    set {
      for index in cards.indices {
        // newValue exists in set, means the value thats being assigned
        // turn cards face up/down
        cards[index].isFaceUp = index == newValue
      }
    }
  }
  
  mutating func choose(card: Card) {
    if let chosenIndex: Int = cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
      if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
        if cards[chosenIndex].content == cards[potentialMatchIndex].content {
          // have a match
          cards[chosenIndex].isMatched = true
          cards[potentialMatchIndex].isMatched = true
        }
        // replacing inside the array because its an struct
        // this creates a new array with the changes
        // and mutating notes it
        cards[chosenIndex].isFaceUp = true
      } else {
        indexOfTheOneAndOnlyFaceUpCard = chosenIndex
      }
    }
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
    var isFaceUp: Bool = false {
      didSet {
        if isFaceUp {
          startUsingBonusTime()
        } else {
          stopUsingBonusTime()
        }
      }
    }
    var isMatched: Bool = false {
      didSet {
        stopUsingBonusTime()
      }
    }
    var content: CardContent
    var id: Int
    
    
    // MARK: - Bonus Time
    var bonusTimeLimit: TimeInterval = 6
    
    private var faceUpTime: TimeInterval {
      if let lastFaceUpDate = self.lastFaceUpDate {
        return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
      } else {
        return pastFaceUpTime
      }
    }
    
    var lastFaceUpDate: Date?
    
    var pastFaceUpTime: TimeInterval = 0
    
    var bonusTimeRemaining: TimeInterval {
      max(0, bonusTimeLimit - faceUpTime)
    }
    
    var bonusRemaining: Double {
      (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining / bonusTimeLimit : 0
    }
    
    var hasEarnedBonus: Bool {
      isMatched && bonusTimeRemaining > 0
    }
    
    var isConsumingBonusTime: Bool {
      isFaceUp && !isMatched && bonusTimeRemaining > 0
    }
    
    private mutating func startUsingBonusTime() {
      if isConsumingBonusTime, lastFaceUpDate == nil {
        lastFaceUpDate = Date()
      }
    }
    
    private mutating func stopUsingBonusTime() {
      pastFaceUpTime = faceUpTime
      self.lastFaceUpDate = nil
    }
  }
}
