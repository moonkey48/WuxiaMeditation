//
//  BacgkroundEffect.swift
//  운기조식
//
//  Created by Austin's Macbook Pro M3 on 7/13/24.
//

import SwiftUI

// MARK: - Gradient colors

private let tl = Color("top_left")
private let tc = Color("top_center")
private let tr = Color("top_right")

private let ml = Color("middle_left")
private let mc = Color("middle_center")
private let mr = Color("middle_right")

private let bl = Color("bottom_left")
private let bc = Color("bottom_center")
private let br = Color("bottom_right")

// MARK: - Grainy gradient

extension ShapeStyle where Self == AnyShapeStyle {
    static func circleMotionWithBackground(time: Float, secondTime: Float, gridSize: Int = 3) -> Self {
        return AnyShapeStyle(ShaderLibrary.default.circleMotionWithBackground(
            .boundingRect,
            .float(3),
            .float(time),
            .float(secondTime)
        ))
    }
    
}