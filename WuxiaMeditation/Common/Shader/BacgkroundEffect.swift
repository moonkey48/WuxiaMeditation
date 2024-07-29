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
    static func grainGradient(time: TimeInterval, gridSize: Int = 3) -> Self {
        return AnyShapeStyle(ShaderLibrary.default.grainGradient(
            .boundingRect,
            .float(3),
            .float(time),
            .colorArray([tl, tc, tr,
                         ml, mc, mr,
                         bl, bc, br])
        ))
    }
    static func grainGradient2(time: TimeInterval, gridSize: Int = 3) -> Self {
        return AnyShapeStyle(ShaderLibrary.default.grainGradient2(
            .boundingRect,
            .float(3),
            .float(time),
            .colorArray([tl, tc, tr,
                         ml, mc, mr,
                         bl, bc, br])
        ))
    }
    static func grainGradient3(time: Float, gridSize: Int = 3) -> Self {
        return AnyShapeStyle(ShaderLibrary.default.grainGradient3(
            .boundingRect,
            .float(3),
            .float(time)
        ))
    }
    static func grainGradient4(time: Float, gridSize: Int = 3) -> Self {
        return AnyShapeStyle(ShaderLibrary.default.grainGradient3(
            .boundingRect,
            .float(30),
            .float(time)
        ))
    }
}
