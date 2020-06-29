//
//  Grid.swift
//  Memorize
//
//  Created by Sebastian Penafiel on 6/26/20.
//  Copyright © 2020 Sebastian Penafiel. All rights reserved.
//

import SwiftUI

// we are constraining Item to be a generic of Identifiable
struct Grid<Item, ItemView>: View where Item: Identifiable, ItemView: View {
  private var items: [Item]
  private var viewForItem: (Item) -> ItemView
  
  // @escaping means that the var which is a function, will be called outside of
  // where it is defined, in this case on the init, its only being assigned
  // to another var, thats why it needs @escaping
  init(_ items: [Item], viewForItem: @escaping (Item) -> ItemView) {
    self.items = items
    self.viewForItem = viewForItem
  }
  
  var body: some View {
    GeometryReader { geometry in
      self.body(for: GridLayout(itemCount: self.items.count, in: geometry.size))
    }
  }
  
  private func body(for layout: GridLayout) -> some View {
    ForEach(items) { item in
      self.body(for: item, in: layout)
    }
  }
  
  private func body(for item: Item, in layout: GridLayout) -> some View {
    viewForItem(item)
      .frame(width: layout.itemSize.width, height: layout.itemSize.height)
      .position(layout.location(ofItemAt: items.firstIndex(matching: item)!))
  }
  
}
