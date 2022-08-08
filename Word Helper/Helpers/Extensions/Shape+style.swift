//
//  Shape.swift
//  WordleHelper
//
//  Created by Ryan Trent on 7/20/22.
//

import SwiftUI

extension Shape {
    func style<StrokeStyle: ShapeStyle, FillStyle: ShapeStyle>(
        withStroke strokeContent: StrokeStyle,
        lineWidth: CGFloat = 1,
        fill fillContent: FillStyle
    ) -> some View {
        stroke(strokeContent, lineWidth: lineWidth)
            .background(fill(fillContent))
    }
}
