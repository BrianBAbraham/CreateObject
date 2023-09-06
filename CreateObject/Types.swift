//
//  Types.swift
//  CreateObject
//
//  Created by Brian Abraham on 17/03/2023.
//

import Foundation

typealias MinMaxAngle = (min: Measurement<UnitAngle>, max: Measurement<UnitAngle>)
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
typealias BaseObjectDoubleDictionary = [BaseObjectTypes: Double]
typealias BaseObjectDimensionDictionary = [BaseObjectTypes: Dimension]
typealias BaseObject3DimensionDictionary = [BaseObjectTypes: Dimension3d]
typealias PartDimensionDictionary = [String: Dimension]
typealias Part3DimensionDictionary = [String: Dimension3d]
typealias BaseObjectOriginDictionary = [BaseObjectTypes: PositionAsIosAxes]
///
typealias OriginDictionary = [ BaseObjectTypes : PositionAsIosAxes ]

typealias Dimension = (length: Double, width: Double)
typealias Dimension3d = (width: Double, length: Double,  height: Double)
typealias WheelSize = (radius: Double, width: Double)

//typealias Edit = (corner: Bool, origin: Bool, side: Bool, lengthOnly: Bool, widthOnly: Bool, widthSymmetry: Bool)

//typealias MinMax = (min: Double, max: Double)
typealias AngleDictionary = [String: Measurement<UnitAngle>]
typealias AngleMinMaxDictionary = [String: MinMaxAngle]
typealias BaseObjectAngleDictionary = [BaseObjectTypes: Measurement<UnitAngle>]

typealias BaseObjectWheelSizeDictionary = [BaseObjectTypes: WheelSize]

typealias TwinSitOnOptionDictionary = [TwinSitOnOption : Bool]


typealias OriginIdNodes =
    (origin: [PositionAsIosAxes],
     ids: [[Part]],
     nodes: [Part])

typealias RearMidFrontOriginIdNodes =
    (rear: OriginIdNodes, mid: OriginIdNodes, front: OriginIdNodes)

typealias OriginIdNode =
    (origin: PositionAsIosAxes, id: [Part] ,node: Part)

///corners of a cuboid ordered as follows
///IOS screen view
///bottom surface)is:
///c0 top left,
///c1 top right,
///c2 bottom righ,t
///c3 bottom left,
///top surface is:
///c4 top left,
///c5 top left,
///c6 top right,
///c7 top left,
typealias Corners = [PositionAsIosAxes]


/// given a rotation about -x -- x  of a cubiod
/// dimension y is altered 
/// so if width and length are displayed
/// part appears correctly
typealias RotatedDimensions = [Dimension3d]
