//
//  Types.swift
//  CreateObject
//
//  Created by Brian Abraham on 17/03/2023.
//

import Foundation

typealias PositionAsIosAxes = (x: Double, y: Double, z: Double)
typealias PositionArrayAsIosAxes = (x:[Double], y: [Double], z: [Double])

typealias HashableDictionaryTouple =  (id: [UUID], object: [PositionDictionary])

typealias LeftRightPositionAsIosAxis = (
    left: PositionAsIosAxes, right: PositionAsIosAxes)

typealias BasePositionAsIosAxes =
(centre: PositionAsIosAxes,
front: PositionAsIosAxes,
rear: PositionAsIosAxes)

typealias OptionDictionary = [ObjectOptions: Bool]
typealias PositionDictionary = [String: PositionAsIosAxes]
typealias MeasurementDictionary = [String: Double]

typealias Dimension = (length: Double, width: Double)

typealias Edit = (corner: Bool, origin: Bool, side: Bool, lengthOnly: Bool, widthOnly: Bool, widthSymmetry: Bool)

//typealias MinMax = (min: Double, max: Double)
