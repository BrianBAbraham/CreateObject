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
typealias BaseObjectDimensionDictionary = [BaseObjectTypes: Dimension]
typealias BaseObject3DimensionDictionary = [BaseObjectTypes: Dimension3d]
typealias PartDimensionDictionary = [String: Dimension]
typealias Part3DimensionDictionary = [String: Dimension3d]
typealias BaseObjectPositionDictionary = [BaseObjectTypes: PositionAsIosAxes]
typealias PartToPartDictionary = [ BaseObjectTypes : PositionAsIosAxes ]

typealias Dimension = (length: Double, width: Double)
typealias Dimension3d = (length: Double, width: Double, height: Double)

typealias Edit = (corner: Bool, origin: Bool, side: Bool, lengthOnly: Bool, widthOnly: Bool, widthSymmetry: Bool)

//typealias MinMax = (min: Double, max: Double)
