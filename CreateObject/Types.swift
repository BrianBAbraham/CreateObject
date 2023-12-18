//
//  Types.swift
//  CreateObject
//
//  Created by Brian Abraham on 17/03/2023.
//

import Foundation
typealias RotationAngles =
(x: Measurement<UnitAngle>,
 y: Measurement<UnitAngle>,
 z: Measurement<UnitAngle>)
typealias AngleMinMax = (min: Measurement<UnitAngle>, max: Measurement<UnitAngle>)
typealias AnglesMinMax = (min: RotationAngles, max: RotationAngles)

//typealias MinMax = (min: Double, max: Double)
typealias AnglesDictionary = [String: RotationAngles]// Measurement<UnitAngle>]
typealias AngleMinMaxDictionary = [String: AngleMinMax]
typealias AnglesMinMaxDictionary = [String: AnglesMinMax]

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

typealias PositionAsIosAxes = (x: Double, y: Double, z: Double)
func + (lhs: PositionAsIosAxes, rhs: PositionAsIosAxes) -> PositionAsIosAxes {
    let sumX = lhs.x + rhs.x
    let sumY = lhs.y + rhs.y
    let sumZ = lhs.z + rhs.z
    return (sumX, sumY, sumZ)
}

func += (lhs: inout PositionAsIosAxes, rhs: PositionAsIosAxes) {
    lhs.x += rhs.x
    lhs.y += rhs.y
    lhs.z += rhs.z
}


typealias Dimension3d = (width: Double, length: Double,  height: Double)
func + (lhs: Dimension3d, rhs: Dimension3d) -> Dimension3d {
    let sumWidth = lhs.width + rhs.width
    let sumLength = lhs.length + rhs.length
    let sumHeight = lhs.height + rhs.height
    return (sumWidth, sumLength, sumHeight)
}

func / (lhs: Dimension3d, rhs: Double) -> Dimension3d {
    let divWidth = lhs.width / rhs
    let divLength = lhs.length / rhs
    let divHeight = lhs.height / rhs
    return (divWidth, divLength, divHeight)
}


//typealias Dimensions3dRearMidFront =
//    (rear: [Dimension3d], mid: [Dimension3d], front: [Dimension3d])

typealias Dimension3dRearMidFront =
    (rear: Dimension3d, mid: Dimension3d, front: Dimension3d)

//typealias WheelSize = (radius: Double, width: Double)




///input BaseObjectType to get angle
typealias BaseObjectAngleDictionary = [ObjectTypes: Measurement<UnitAngle>]
typealias BaseObjectAngelMinMaxDictionary = [ObjectTypes: AngleMinMax]
//typealias BaseObjectWheelSizeDictionary = [ObjectTypes: WheelSize]

typealias TwinSitOnOptionDictionary = [TwinSitOnOption : Bool]






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
//typealias OriginIdNode =
//    (origin: PositionAsIosAxes, id: [Part] ,node: Part)

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
//typealias TwinSitOnOrigins =
//    (onlyOne: [PositionAsIosAxes],
//     rearAndFront: [PositionAsIosAxes],
//     leftAndRight: [PositionAsIosAxes])

typealias KeyPathForDimension = KeyPath<(left: Dimension3d?, right: Dimension3d?, one: Dimension3d?), Dimension3d?>
typealias KeyPathForIosPosition = KeyPath<(left: PositionAsIosAxes?, right: PositionAsIosAxes?, one: PositionAsIosAxes?), PositionAsIosAxes?>
typealias KeyPathForSide = KeyPath<(left: Part?, right: Part?, one: Part?), Part?>
typealias KeyPathForName = KeyPath<(left: String?, right: String?, one: String?), String?>

//typealias s = KeyPath<(left: Dimension3d?, right: Dimension3d?, one: Dimension3d?), Dimension3d?>
