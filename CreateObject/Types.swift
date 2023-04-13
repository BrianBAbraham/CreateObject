//
//  Types.swift
//  CreateObject
//
//  Created by Brian Abraham on 17/03/2023.
//

import Foundation

typealias PositionAsIosAxes = (x: Double, y: Double, z: Double)
typealias PositionArrayAsIosAxes = (x:[Double], y: [Double], z: [Double])

typealias LeftRightPositionAsIosAxis = (
    left: PositionAsIosAxes, right: PositionAsIosAxes)

typealias BasePositionAsIosAxes =
(centre: PositionAsIosAxes,
front: PositionAsIosAxes,
rear: PositionAsIosAxes)

typealias PositionDictionary = [String: PositionAsIosAxes]

typealias Dimension = (length: Double, width: Double)

typealias Edit = (corner: Bool, origin: Bool, side: Bool, lengthOnly: Bool, widthOnly: Bool, widthSymmetry: Bool)
