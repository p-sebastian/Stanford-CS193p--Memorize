//
//  Array+Only.swift
//  Memorize
//
//  Created by Sebastian Penafiel on 6/28/20.
//  Copyright © 2020 Sebastian Penafiel. All rights reserved.
//

import Foundation

extension Array {
  var only: Element? {
    count == 1 ? first : nil
  }
}
