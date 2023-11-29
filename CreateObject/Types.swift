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

//typealias HashableDictionaryTouple =  (id: [UUID], object: [PositionDictionary])

typealias LeftRightPositionAsIosAxis = (
    left: PositionAsIosAxes, right: PositionAsIosAxes)

// generic touple with left and right and common type
typealias LeftRight<T> = (left: T, right: T)

typealias RearMidFrontPositions =
    (
    rear: PositionAsIosAxes,
    mid: PositionAsIosAxes,
    front: PositionAsIosAxes)





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

typealias Dimension = (width: Double, length: Double)
typealias Dimension3d = (width: Double, length: Double,  height: Double)

//typealias Dimensions3dRearMidFront =
//    (rear: [Dimension3d], mid: [Dimension3d], front: [Dimension3d])

typealias Dimension3dRearMidFront =
    (rear: Dimension3d, mid: Dimension3d, front: Dimension3d)

typealias WheelSize = (radius: Double, width: Double)



//typealias MinMax = (min: Double, max: Double)
typealias AngleDictionary = [String: Measurement<UnitAngle>]
typealias AngleMinMaxDictionary = [String: AngleMinMax]
///input BaseObjectType to get angle
typealias BaseObjectAngleDictionary = [ObjectTypes: Measurement<UnitAngle>]
typealias BaseObjectAngelMinMaxDictionary = [ObjectTypes: AngleMinMax]
typealias BaseObjectWheelSizeDictionary = [ObjectTypes: WheelSize]

typealias TwinSitOnOptionDictionary = [TwinSitOnOption : Bool]



typealias RotationAngles =
    (x: Measurement<UnitAngle>,
     y: Measurement<UnitAngle>,
     z: Measurement<UnitAngle>)


//typealias PartDimensionOriginIds =
//    (
//    part: Part,
//    dimension: Dimension3d,
//    origin: PositionAsIosAxes,
//    ids: [Part],
//    angles: RotationAngles)



typealias PartDataTuple = (part: Part, dimension: (width: Double, length: Double, height: Double), origin: (x: Double, y: Double, z: Double), ids: [Part], angles: (x: Measurement<UnitAngle>, y: Measurement<UnitAngle>, z: Measurement<UnitAngle>))

///OriginIdNodes type is assigned to
///'rear'', 'mid' and 'front'
///for absent values ZeroValue.rearMidOriginIdNodes is used
//typealias RearMidFrontOriginIdNodes =
//    (rear: OriginIdPartChain, mid: OriginIdPartChain, front: OriginIdPartChain)


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


///an array of one or more part that form
///a ccnnection chain from the object origin
///where the object origin is assumed and not included
typealias PartChain = [Part]

typealias PartChainDictionary = [String: [String]]

///Key is a PartChain, value is a OneOrTwo<Part>
///Each part in a partChain shares the same id
///The UI can never leave a subsequent part without a prior part
///since removal of an id removes id for all part in chain
typealias PartChainIdDictionary = [PartChain: OneOrTwo<Part> ]

/// Input an object type and get the chain labels associaed with that object type
/// as defined in ObjectsAndTheirChainLabels
typealias ObjectPartChainLabelsDictionary = [ObjectTypes: [Part]]

///(onlyOne: [PositionAsIosAxes],
///frontAndRear: [PositionAsIosAxes]
///sideBySide: [PositionAsIosAxes])
typealias TwinSitOnOrigins =
    (onlyOne: [PositionAsIosAxes],
     rearAndFront: [PositionAsIosAxes],
     leftAndRight: [PositionAsIosAxes])

typealias TwinSitOn =
    (onlyOne: [GenericPartValue],
     rearAndFront: [GenericPartValue],
     leftAndRight: [GenericPartValue])

