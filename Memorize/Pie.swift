//
//  Pie.swift
//  Memorize
//
//  Created by Sebastian Penafiel on 6/29/20.
//  Copyright © 2020 Sebastian Penafiel. All rights reserved.
//

import SwiftUI

struct Pie: Shape {
  var startAngle: Angle
  var endAngle: Angle
  var clockwise: Bool = false
  
  // AnimatablePair is for animating multiple things
  // with the same var
  var animatableData: AnimatablePair<Double, Double> {
    get {
      // (first, second)
      AnimatablePair(startAngle.radians, endAngle.radians)
    }
    set {
      // shown above
      startAngle = Angle.radians(newValue.first)
      endAngle = Angle.radians(newValue.second)
    }
  }
  
  // func to conform to Shape
  func path(in rect: CGRect) -> Path {
    let center = CGPoint(x: rect.midX, y: rect.midY)
    let radius = min(rect.width, rect.height) / 2
    let start = CGPoint(
      x: center.x + radius * cos(CGFloat(startAngle.radians)),
      y: center.y + radius * sin(CGFloat(startAngle.radians))
    )
    var p = Path()
    // start from center
    p.move(to: center)
    p.addLine(to: start)
    p.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
    p.addLine(to: center)
    return p
  }
}
