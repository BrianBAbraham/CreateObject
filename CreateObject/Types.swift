//
//  Types.swift
//  CreateObject
//
//  Created by Brian Abraham on 17/03/2023.
//

import Foundation

typealias AngleMinMax = (min: Measurement<UnitAngle>, max: Measurement<UnitAngle>)
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


///an array of one or more part that form
///a ccnnection chain from the object origin
///where the object origin is assumed and not included
typealias PartChain = [Part]

///The dictionary provider uses the values to create the part
///The UI  uses the values to remove the part from display
typealias BaseOptionDictionary = [Part: Bool]


typealias PositionDictionary = [String: PositionAsIosAxes]
///the positions for the four corners are as Corners type
//typealias PositionCornerDictionary = [String: Corners]
typealias MeasurementDictionary = [String: Double]
typealias BaseObjectDoubleDictionary = [ObjectTypes: Double]
typealias BaseObjectDimensionDictionary = [ObjectTypes: Dimension]

//. Input BaseObjectType to get Dimension3d
typealias BaseObject3DimensionDictionary = [ObjectTypes: Dimension3d]
typealias PartDimensionDictionary = [String: Dimension]
///[String: Dimension3d aka (width: Double, length: Double,  height: Double)]
typealias Part3DimensionDictionary = [String: Dimension3d]
typealias BaseObjectOriginDictionary = [ObjectTypes: PositionAsIosAxes]
/// Input BaseObjectTypes to get default value for that object
typealias OriginDictionary = [ ObjectTypes : PositionAsIosAxes ]

typealias Dimension = (length: Double, width: Double)
typealias Dimension3d = (width: Double, length: Double,  height: Double)
typealias Dimension3dRearMidFront =
    (rear: [Dimension3d], mid: [Dimension3d], front: [Dimension3d])
typealias WheelSize = (radius: Double, width: Double)

//typealias Edit = (corner: Bool, origin: Bool, side: Bool, lengthOnly: Bool, widthOnly: Bool, widthSymmetry: Bool)

//typealias MinMax = (min: Double, max: Double)
typealias AngleDictionary = [String: Measurement<UnitAngle>]
typealias AngleMinMaxDictionary = [String: AngleMinMax]
///input BaseObjectType to get angle
typealias BaseObjectAngleDictionary = [ObjectTypes: Measurement<UnitAngle>]
typealias BaseObjectAngelMinMaxDictionary = [ObjectTypes: AngleMinMax]
typealias BaseObjectWheelSizeDictionary = [ObjectTypes: WheelSize]

typealias TwinSitOnOptionDictionary = [TwinSitOnOption : Bool]

/// encapsulates all three data used to create a dictionary
/// crash if elements number for each lable not equal
/// id indicates unilateral part by one id and bilateral part with two
/// nodes are the parts in the part collection being considered
/// origin: [PositionAsIosAxes]
/// ids: [[Part]] : [.ida, .idb] where a,b is 0,1 or 2,3 or 4,5
/// or [.id0] for a unilateral or centre part
/// chain: [part] where part is the part of the object
/// nodes are ordered from .object to most distant node eg
/// .sitOn,
/// .backSupport.backSupporRotationJoint,
/// .backSupport,
/// .backSupportHeadSupportJoint
/// an origin is the relative origin from part to next part
/// nodes excludes first node .object
/// each of the three data elements contains n members
typealias OriginIdPartChain =
    (origin: [PositionAsIosAxes],
     ids: [[Part]],
     chain: [Part])

///OriginIdNodes type is assigned to
///'rear'', 'mid' and 'front'
///for absent values ZeroValue.rearMidOriginIdNodes is used
typealias RearMidFrontOriginIdNodes =
    (rear: OriginIdPartChain, mid: OriginIdPartChain, front: OriginIdPartChain)


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

/// each key has eight corners as per Corners [PositionAsIosAxes]
typealias CornerDictionary = [String: Corners]

typealias PartChainDictionary = [String: [String]]

/// key is a PartChain and value is an array of id array
///  where id array are either unilateral  or bilateral
/// for sitOn id are unilateral id0 or id1 but for all other unilateral part id0
typealias PartChainIdDictionary = [PartChain: [[Part]] ]
