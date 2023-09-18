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
///the positions for the four corners are as Corners type
typealias PositionCornerDictionary = [String: Corners]
typealias MeasurementDictionary = [String: Double]
typealias BaseObjectDoubleDictionary = [BaseObjectTypes: Double]
typealias BaseObjectDimensionDictionary = [BaseObjectTypes: Dimension]
//. Input BaseObjectType to get Dimension3d
typealias BaseObject3DimensionDictionary = [BaseObjectTypes: Dimension3d]
typealias PartDimensionDictionary = [String: Dimension]
typealias Part3DimensionDictionary = [String: Dimension3d]
typealias BaseObjectOriginDictionary = [BaseObjectTypes: PositionAsIosAxes]
/// Input BaseObjectTypes to get default value for that object
typealias OriginDictionary = [ BaseObjectTypes : PositionAsIosAxes ]

typealias Dimension = (length: Double, width: Double)
typealias Dimension3d = (width: Double, length: Double,  height: Double)
typealias Dimension3dRearMidFront =
    (rear: [Dimension3d], mid: [Dimension3d], front: [Dimension3d])
typealias WheelSize = (radius: Double, width: Double)

//typealias Edit = (corner: Bool, origin: Bool, side: Bool, lengthOnly: Bool, widthOnly: Bool, widthSymmetry: Bool)

//typealias MinMax = (min: Double, max: Double)
typealias AngleDictionary = [String: Measurement<UnitAngle>]
typealias AngleMinMaxDictionary = [String: MinMaxAngle]
///input BaseObjectType to get angle
typealias BaseObjectAngleDictionary = [BaseObjectTypes: Measurement<UnitAngle>]

typealias BaseObjectWheelSizeDictionary = [BaseObjectTypes: WheelSize]

typealias TwinSitOnOptionDictionary = [TwinSitOnOption : Bool]

/// encapsulates all three data used to create a dictionary
/// crash if elements number for each lable not equal
/// id indicates unilateral part by one id and bilateral part with two
/// nodes are the parts in the part collection being considered
/// origin: [PositionAsIosAxes]
/// ids: [[Part]] : [.ida, .idb] where a,b is 0,1 or 2,3 or 4,5
/// or [.id0] for a unilateral or centre part
/// nodes: [part] where part is the part of the object
/// nodes are ordered from .object to most distant node eg
/// .sitOn,
/// .backSupport.backSupporRotationJoint,
/// .backSupport,
/// .backSupportHeadSupportJoint
/// an origin is the relative origin from part to next part
/// nodes excludes first node .object
/// each of the three data elements contains n members
typealias OriginIdNodes =
    (origin: [PositionAsIosAxes],
     ids: [[Part]],
     nodes: [Part])

///OriginIdNodes type is assigned to
///'rear'', 'mid' and 'front'
///for absent values ZeroValue.rearMidOriginIdNodes is used
typealias RearMidFrontOriginIdNodes =
    (rear: OriginIdNodes, mid: OriginIdNodes, front: OriginIdNodes)


///While OriginIdNodes (s at end)
///has collections for each label
///only a single value is present
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

/// each key has eight corners as per Corners
typealias CornerDictionary = [String: Corners]
