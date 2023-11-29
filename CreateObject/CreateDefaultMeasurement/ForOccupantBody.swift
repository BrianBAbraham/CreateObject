//
//  ForrOccupantBody.swift
//  CreateObject
//
//  Created by Brian Abraham on 02/06/2023.
//

import Foundation





struct OccupantBodySupportDefaultDimension: PartDimension {
    var dimension: Dimension3d = ZeroValue.dimension3d
    
    mutating func reinitialise(_ part: Part?) {
        dimension = value
    }
    
    let dictionary: BaseObject3DimensionDictionary =
    [.allCasterStretcher: (width: 600.0, length: 1200.0, height: 10.0),
     .allCasterBed: (width: 900.0, length: 2000.0, height: 150.0),
     .allCasterHoist: (width: 0.0, length: 0.0, height: 0.0)
        ]
    static let general = (width: 400.0, length: 400.0, height: 10.0)
    let value: Dimension3d
    
    init(
        _ baseType: ObjectTypes) {
            value =
                dictionary[baseType] ??
                Self.general
    }
}



//struct PreTiltBodySupportDefaultOriginHeight {
//    let objectType: ObjectTypes
//    let dictionary: [ObjectTypes: Double] =
//    [
//        .allCasterStretcher: 900.0,
//        .allCasterBed: 800.0]
//    let general = 500.0
//    let height: Double
//
//    init (
//        _ objectType: ObjectTypes//,
//
//    ) {
//        self.objectType = objectType
//
//        height = dictionary[objectType] ?? general
//    }
//}






//only angle measurement is returned
struct OccupantBodySupportDefaultAngleChange {
    let dictionary: BaseObjectAngleDictionary =
    [.allCasterTiltInSpaceShowerChair: OccupantBodySupportDefaultAngleMinMax(.allCasterTiltInSpaceShowerChair).value.max]//Measurement(value: 90.0, unit: UnitAngle.degrees)]
    
    static let general = Measurement(value: 0.0, unit: UnitAngle.degrees)
    
    let value: Measurement<UnitAngle>
    
    init(
        _ baseType: ObjectTypes) {
            value =
                dictionary[baseType] ??
                Self.general
    }
}


struct OccupantBodySupportDefaultAngleMinMax {
    let dictionary: BaseObjectAngelMinMaxDictionary =
    [.allCasterTiltInSpaceShowerChair: (min: Measurement(value: 0.0, unit: UnitAngle.degrees), max: Measurement(value: 45.0, unit: UnitAngle.degrees) ) ]
    
    static let general = (min: Measurement(value: 0.0, unit: UnitAngle.degrees), max: Measurement(value: 30.0, unit: UnitAngle.degrees) )
    
    let value: AngleMinMax
    
    init(
        _ baseType: ObjectTypes) {
            value =
                dictionary[baseType] ??
                Self.general
    }
}



    



///origin for one sitOn, and frontAndRear and sideBySide
///are provided by sitOnOrigins
///dicttionary dimension and origin are psssed to make use
///of edited values if extant
struct PreTiltSitOnAndWheelBaseJointOrigin {
    var originForOnlyOneSitOn = [ZeroValue.iosLocation]
    let objectType: ObjectTypes
    let stability: Stability
    var origins: [PositionAsIosAxes] = []

    let bilateralIds: [Part] = [.id0, .id1]
    let bothSitOnId: [Part] = [.id0, .id1]

    var sitOnOriginsIn: TwinSitOnOrigins =  ZeroValue.sitOnOrigins
    var sitOnDimensions: [Dimension3d] = []
    var occupantSideSupportsDimensions: [[Dimension3d]] = []
    var occupantFootSupportHangerLinksMaxLengths: [Double] = []
    var sitOnOrigins: TwinSitOnOrigins = ZeroValue.sitOnOrigins

    let wheelDefaultDimensionForRearMidFront: Dimension3dRearMidFront
    var wheelBaseJointOriginForOnlyOneSitOn: RearMidFrontPositions = ZeroValue.rearMidFrontPositions
    
    var wheelBaseJointOrigins: TwinSitOnOrigins = ZeroValue.sitOnOrigins
    let onlyOne = 0
    let rear = 0
    let front = 1
    let left = 0
    let right = 1
    let bodySupportHeight: Double

  
    /// 1) rearAndFront && sleftAndRight == false: one origin .id0
    /// 2) rearAndFront == true && sideBySide == false: two origin .id0 (rear), .id1 (front)
    /// 3) rearAndFront == false && leftAndRight == true: two origin .id0 (left), .id1 (right)
    /// locations as per viewing screen
    /// [[PositionAsIos]]
    
    init(
        _ object: ObjectTypes) {

        self.objectType = object

        stability = Stability(objectType)

            bodySupportHeight = MiscObjectParameters(objectType).getMainBodySupportAboveFloor()
            
        wheelDefaultDimensionForRearMidFront =
            WheelDefaultDimensionForRearMidFront(object).dimensions

        for id in bothSitOnId {
            sitOnDimensions.append(
                getEditedOrDefaultSitOnDimension(id))
            
            occupantFootSupportHangerLinksMaxLengths.append(
                getEditedOrDefaultMaximumHangerLinkLength(id))
            
            occupantSideSupportsDimensions.append(
                getEditedOrDefaultSideSupportDimensions(id))
        }

        sitOnOriginsIn = getEditedSitOnOrigins()

        let wheelBaseJointOrigin = getWheelBaseJointOriginForOneSitOn()
        
        setOriginsWithDriveAtDifferentLocations()
        
        func setOriginsWithDriveAtDifferentLocations() {
            let withThisLocation: Drive = MiscObjectParameters(objectType).getDriveLocation()
            
            let leftAndRight = getOriginForLeftAndRightSitOn()
            let rearAndFront = getOriginForRearAndFrontSitOn()
            
            sitOnOrigins = (
                onlyOne: [getDataForDrive(withThisLocation,getOriginForOneSitOn() )],
                rearAndFront: [
                    getDataForDrive(withThisLocation,rearAndFront.rear ),
                    getDataForDrive(withThisLocation,rearAndFront.front )],
                leftAndRight: [
                    getDataForDrive(withThisLocation,leftAndRight.left),
                    getDataForDrive(withThisLocation,leftAndRight.right)] )
            
            wheelBaseJointOriginForOnlyOneSitOn =
                getDataForDrive( withThisLocation, wheelBaseJointOrigin )
        }
       
    }
    
    //there may be none, or one or two edited sitOn origins
    //if two these may be frontAndRear or sideBySide
    func getEditedSitOnOrigins()
        -> TwinSitOnOrigins {
        var sitOnOrigins: [PositionAsIosAxes?] = []
        var sitOnOriginsIn = ZeroValue.sitOnOrigins
            for _ in bothSitOnId {
            sitOnOrigins.append(nil
            )
        }
        // one or more nill
        if sitOnOrigins.contains(where: { $0 == nil }) {
            ///two nil
            if sitOnOrigins.allSatisfy({ $0 == nil }) {
            // do nothing
            } else { //one nil
                if let nonNilElement = sitOnOrigins.first(where: { $0 != nil } ) {
                    sitOnOriginsIn =
                        (onlyOne: [nonNilElement!],
                         rearAndFront: [],
                         leftAndRight: [])
                }
            }
        } else {
            // No elements are nil so check for frontAndRear and sideBySide
            let first = sitOnOrigins[0]!
            let second = sitOnOrigins[1]!
            
            // if x origins difference is greatest must be side by side
            if abs(first.x - second.x) > abs(first.y - second.y) {
                sitOnOriginsIn =
                    (onlyOne: [],
                     rearAndFront: [],
                     leftAndRight: [first, second])
            } else {
                sitOnOriginsIn =
                    (onlyOne: [],
                     rearAndFront: [first, second],
                     leftAndRight: [])
            }
        }
            return sitOnOriginsIn
    }
    
    
    func getEditedOrDefaultSitOnDimension(_ sitOnId: Part)
        -> Dimension3d {
            OccupantBodySupportDefaultDimension(objectType).value
    }
    
    
    func getEditedOrDefaultSideSupportDimensions(_ sitOnId: Part)
        -> [Dimension3d] {
            var sideSupportDimension: [Dimension3d] = []
            for _ in bilateralIds {
                let dimension =
                    OccupantSideSupportDefaultDimension(objectType).dimension
                sideSupportDimension.append(dimension)
            }
        return
            sideSupportDimension
    }
    
    
    func getEditedOrDefaultMaximumHangerLinkLength(
            _ sitOnId: Part)
    -> Double{
        var lengths:[Double] = []
        let hangerLinkLength = OccupantFootSupportDefaultDimension(objectType).getHangerLink().length
        for _ in bilateralIds {
            lengths.append(
                hangerLinkLength)
        }
        return
            lengths.max() ?? hangerLinkLength
    }
          
    
    func getOriginForOneSitOn()
     -> [PositionAsIosAxes] {
         [ (
            x: 0.0,
            y: sitOnDimensions[onlyOne].length/2,
            z: bodySupportHeight ),
          (
            x: 0.0,
            y: 0.0,
            z: bodySupportHeight ),
         (
            x: 0.0,
            y: -sitOnDimensions[onlyOne].length/2,
            z: bodySupportHeight ) ]
     }
    
    
    func getOriginForRearAndFrontSitOn()
    -> (rear: [PositionAsIosAxes], front: [PositionAsIosAxes]) {
        let lengthBetweenRearAndFrontSitOn  =
            sitOnDimensions[rear].length +
            occupantFootSupportHangerLinksMaxLengths[rear] +
            sitOnDimensions[front].length/2
        let rear =
            [ (
                x: 0.0,
                y: sitOnDimensions[rear].length/2,
                z: bodySupportHeight),
                (
                x: 0.0,
                y: -lengthBetweenRearAndFrontSitOn/2,
                z: bodySupportHeight),
                (
                x: 0.0,
                y: -lengthBetweenRearAndFrontSitOn,
                z: bodySupportHeight) ]
            
        let front =
            [ (
                x:0.0,
                 y: lengthBetweenRearAndFrontSitOn,
                 z: bodySupportHeight),
                (
                x:0.0,
                 y: lengthBetweenRearAndFrontSitOn/2,
                 z: bodySupportHeight),
                (
                x:0.0,
                y: -sitOnDimensions[front].length/2,
                z: bodySupportHeight) ]
        return (rear: rear, front: front)
    }
    
    
    func getOriginForLeftAndRightSitOn()
    -> (left: [PositionAsIosAxes], right: [PositionAsIosAxes]){
        let totalExternalWidthBetweenLeftandRightSideSupport =
            occupantSideSupportsDimensions[left][left].width +
            sitOnDimensions[left].width +
            occupantSideSupportsDimensions[right][right].width +
            sitOnDimensions[right].width
        let xLeftOriginForLeftAndRightSitOn =
            -totalExternalWidthBetweenLeftandRightSideSupport/2 +
            occupantSideSupportsDimensions[left][left].width +
                sitOnDimensions[left].width/2
        let xRightOriginForLeftAndRightSitOn =
            totalExternalWidthBetweenLeftandRightSideSupport/2 -
            occupantSideSupportsDimensions[right][right].width -
                sitOnDimensions[right].width/2
        let left =
            [ (
                x: xLeftOriginForLeftAndRightSitOn,
                y: sitOnDimensions[left].length/2,
                z: bodySupportHeight),
              (
                x: xLeftOriginForLeftAndRightSitOn,
                y: 0.0,
                z:bodySupportHeight),
             (
                x: xLeftOriginForLeftAndRightSitOn,
                y: -sitOnDimensions[left].length/2,
                z: bodySupportHeight) ]
        let right =
            [ (
                x: xRightOriginForLeftAndRightSitOn,
                y: sitOnDimensions[right].length/2,
                z: bodySupportHeight),
              (
                x: xRightOriginForLeftAndRightSitOn,
                y: 0.0,
                z:bodySupportHeight),
              (
                x: xRightOriginForLeftAndRightSitOn,
                y: -sitOnDimensions[right].length/2,
                z: bodySupportHeight) ]
        return ( left: left, right: right)
      
    }
    
    
        
    func getWheelBaseJointOriginForOneSitOn() -> [RearMidFrontPositions]{
        let rear =
            (rear: (
                 x: sitOnDimensions[onlyOne].width/2 +
                    occupantSideSupportsDimensions[left][right].width +
                    stability.atRightRear,
                 y: stability.atRear,
                 z: wheelDefaultDimensionForRearMidFront.rear.height/2 ),
             mid: (
                 x: sitOnDimensions[onlyOne].width/2 +
                   occupantSideSupportsDimensions[left][right].width +
                   stability.atRightMid,
                y:  sitOnDimensions[onlyOne].length/2 +
                    stability.atRear ,
                z: wheelDefaultDimensionForRearMidFront.mid.height/2 ),
             front: (
                x: sitOnDimensions[onlyOne].width/2 +
                   occupantSideSupportsDimensions[left][right].width +
                   stability.atRightFront,
                y: stability.atRear +
                    sitOnDimensions[onlyOne].length +
                    stability.atFront,
                z: wheelDefaultDimensionForRearMidFront.front.height/2 )
            )
        
        let mid =
            (rear: (
                x: sitOnDimensions[onlyOne].width/2 +
                   occupantSideSupportsDimensions[left][right].width +
                   stability.atRightRear,
                y: -sitOnDimensions[onlyOne].length/2 -
                   stability.atRear,
                z: wheelDefaultDimensionForRearMidFront.rear.height ),
            mid: (
                x: sitOnDimensions[onlyOne].width/2 +
                  occupantSideSupportsDimensions[left][right].width +
                  stability.atRightMid,
                y:  0.0,
               z: wheelDefaultDimensionForRearMidFront.mid.height ),
            front: (
               x: sitOnDimensions[onlyOne].width/2 +
                  occupantSideSupportsDimensions[left][right].width +
                  stability.atRightFront,
               y: sitOnDimensions[onlyOne].length/2 +
                   stability.atFront,
               z: wheelDefaultDimensionForRearMidFront.rear.height )
           )
        
        let front =
            (rear: (
                 x: sitOnDimensions[onlyOne].width/2 +
                    occupantSideSupportsDimensions[left][right].width +
                    stability.atRightRear,
                 y: stability.atRear -
                    sitOnDimensions[onlyOne].length -
                    stability.atFront,
                 z: wheelDefaultDimensionForRearMidFront.rear.height ),
             mid: (
                 x: sitOnDimensions[onlyOne].width/2 +
                   occupantSideSupportsDimensions[left][right].width +
                   stability.atRightMid,
                 y:  -sitOnDimensions[onlyOne].length/2 -
                 stability.atFront,
                z: wheelDefaultDimensionForRearMidFront.mid.height ),
             front: (
                x: sitOnDimensions[onlyOne].width/2 +
                   occupantSideSupportsDimensions[left][right].width +
                   stability.atRightFront,
                y: 0.0,
                z: wheelDefaultDimensionForRearMidFront.rear.height )
            )
        return [rear, mid, front]
    }
    
    
    func getDataForDrive<T> (_ at: Drive, _ originsForThisCall: [T])
    -> T {
        
        switch at {
        case .rear:
            return originsForThisCall[0]
        case .mid:
            return originsForThisCall[1]
        case .front:
            return originsForThisCall[2]
            
        }
    }

    
}


struct UserEditedValue {
    let dimensionDic: Part3DimensionDictionary
    let parentToPartOriginDic: PositionDictionary
    let objectToPartOriginDic: PositionDictionary
    let angleDic: AngleDictionary
    let partChainsIdDic: [PartChain: [[Part]]]
    //let partIdsDic: [Part: [Part]]
    let part: Part
    let sitOnId: Part
    let partId: Part
    var name: String {
        CreateNameFromParts ( [
            .sitOn,
            sitOnId,
            part,
            partId]
        ).name}
    var dimension: Dimension3d?
    var origin: PositionAsIosAxes?
    
    init(
        _ userEditedDictionary: UserEditedDictionary,
        _ sitOnId: Part,
        _ part: Part,
        _ partId: Part) {
            dimensionDic = userEditedDictionary.dimension
            parentToPartOriginDic = userEditedDictionary.parentToPartOrigin
            objectToPartOriginDic = userEditedDictionary.objectToPartOrigin
            angleDic = userEditedDictionary.angle
            partChainsIdDic = userEditedDictionary.partChainsId
            //partIdsDic = userEditedDictionary.partIds
           
            self.sitOnId = sitOnId
            self.part = part
            self.partId = partId
            
            dimension = dimensionDic[name]
            origin = parentToPartOriginDic[name]
    }
}



///parts edited by the UI are stored in dictionary
///these dictiionaries are used for parts,
///where extant, instead of default values
///during intitialisation
struct OneOrTwoUserEditedDictionary {
    let dimension: Part3DimensionDictionary
    let parentToPartOrigin: PositionDictionary
    let objectToPartOrigin: PositionDictionary
    let angle: AngleDictionary
    let partChainId: [PartChain: OneOrTwo<Part> ]
    //let partIds: [Part: OneOrTwo<Part>]
}


enum OneOrTwo <T> {
    case two (left: T, right: T)
    case one (one: T)
}

//struct OneOrTwoExtraction<T> {
//    var values: [T]
//
//    init (_ oneOrTwo: OneOrTwo<T>) {
//        values = extractValues(oneOrTwo)
//
//        func extractValues(_ value: OneOrTwo<T>) -> [T] {
//            switch value {
//            case .two(let left, let right):
//                return [left, right]
//            case .one(let one):
//                return [one]
//            }
//        }
//    }
//}

///All dictionary are input in userEditedDictionary
///The optional  values associated with a part are available
///dimension
///origin
///The non-optional id are available
///All values are wrapped in OneOrTwoValues
struct OneOrTwoUserEditedValue {
    let dimensionDic: Part3DimensionDictionary
    let parentToPartOriginDic: PositionDictionary
    let objectToPartOriginDic: PositionDictionary
    let angleDic: AngleDictionary
    let partChainIdDic: [PartChain: OneOrTwo<Part>]
    let part: Part
    let sitOnId: Part
    var name: String {
        CreateNameFromParts ( [
            .sitOn,
            sitOnId,
            part]
        ).name}
    var dimension: OneOrTwo <Dimension3d?> = .one(one: nil)
    var origin: OneOrTwo <PositionAsIosAxes?> = .one(one: nil)
    var partId: OneOrTwo <Part>
    
    init(
    _ userEditedDictionary: OneOrTwoUserEditedDictionary,
    _ sitOnId: Part,
    _ childPart: Part) {
        self.sitOnId = sitOnId
        self.part = childPart
        dimensionDic = userEditedDictionary.dimension
        parentToPartOriginDic = userEditedDictionary.parentToPartOrigin
        objectToPartOriginDic = userEditedDictionary.objectToPartOrigin
        angleDic = userEditedDictionary.angle
        partChainIdDic = userEditedDictionary.partChainId
        let onlyOne = 0
        let partChain = LabelInPartChainOut([childPart]).partChains[onlyOne]
        partId = //non-optional as must iterate through id
           partChainIdDic[partChain] ?? //UI may edit
           OneOrTWoId(childPart).forPart // default
    
        dimension =
            getValue(partId, from: dimensionDic) { part in
                return CreateNameFromParts([.sitOn, sitOnId, part]).name }
        
        origin =
            getValue(partId, from: parentToPartOriginDic) { part in
                return CreateNameFromParts([.sitOn, sitOnId, part]).name }
    }

    func getValue<T>(
    _ partIds: OneOrTwo<Part>,
    from dictionary: [String: T?],
    using closure: @escaping (Part) -> String)
        -> OneOrTwo<T?> {
        let commonPart = { (id: Part) -> T? in
            dictionary[closure(id)] ?? nil
        }

        switch partIds {
            case .one(let oneId):
                return .one(one: commonPart(oneId))
            case .two(let left, let right):
                return .two(left: commonPart(left), right: commonPart(right))
        }
    }

    func getDimension(_ partIds: OneOrTwo<Part>)
    -> OneOrTwo<Dimension3d?> {
        return getValue(partIds, from: dimensionDic) { id in
            CreateNameFromParts([.sitOn, sitOnId, part, id]).name
        }
    }

    func getOrigin(_ partIds: OneOrTwo<Part>)
    -> OneOrTwo<PositionAsIosAxes?> {
        return getValue(partIds, from: parentToPartOriginDic) { id in
            CreateNameFromParts([.sitOn, sitOnId, part, id]).name
        }
    }
}


///parts edited by the UI are stored in dictionary
///these dictiionaries are used for parts,
///where extant, instead of default values
///during intitialisation
struct UserEditedDictionary {
    let dimension: Part3DimensionDictionary
    let parentToPartOrigin: PositionDictionary
    let objectToPartOrigin: PositionDictionary
    let angle: AngleDictionary
    let partChainsId: [PartChain: [[Part]]]
    
}





///origin for one sitOn, and frontAndRear and sideBySide
///are provided by sitOnOrigins
///dicttionary dimension and origin are psssed to make use
///of edited values if extant
struct PreTiltSitOnOrigin {
    var originForOnlyOneSitOn = [ZeroValue.iosLocation]
    let objectType: ObjectTypes
    let stability: Stability
    var origins: [PositionAsIosAxes] = []

    let bilateralIds: [Part] = [.id0, .id1]
    //let bothSitOnId: [Part] = [.id0, .id1]
    let sitOnId: Part = .id0
    var sitOnOriginsIn: TwinSitOnOrigins =  ZeroValue.sitOnOrigins
    var sitOnDimensions: [Dimension3d] = []
    var occupantSideSupportsDimensions: [[Dimension3d]] = []
    var occupantFootSupportHangerLinksMaxLengths: [Double] = []
    var sitOnOrigins: TwinSitOnOrigins = ZeroValue.sitOnOrigins
    
    var footSuportMaxLength = 0.0
    
    let onlyOne = 0
    let rear = 0
    let front = 1
    let left = 0
    let right = 1
    let bodySupportHeight: Double

  
    /// 1) rearAndFront && sleftAndRight == false: one origin .id0
    /// 2) rearAndFront == true && sideBySide == false: two origin .id0 (rear), .id1 (front)
    /// 3) rearAndFront == false && leftAndRight == true: two origin .id0 (left), .id1 (right)
    /// locations as per viewing screen
    /// [[PositionAsIos]]
    
    init(
        _ object: ObjectTypes,
        _ sitOnDimension: Dimension3d,
        _ sideSupport: Symmetry<GenericPartValue>?,//sitOn dependent
        _ footSupportHangerLink: Symmetry<GenericPartValue>?, //ditto
        _ userEditedDictionary: UserEditedDictionary
//        _ dimensionDicIn: Part3DimensionDictionary = [:],
//        _ maxDimensionDicIn: Part3DimensionDictionary = [:]
    ) {
        //sitOnDimension = sitOnDimensions[onlyOne]
        self.objectType = object

        stability = Stability(objectType)
        var sideSupportDimensionsForOneSitOn: [Dimension3d] = []
        
        switch sideSupport {
            case .one (let oneSideSupport):
                createSideSupportForOneSitOn(oneSideSupport)
            case .leftRight(let leftSideSupport, let rightSideSupport):
                for sideSupport in [leftSideSupport, rightSideSupport] {
                    createSideSupportForOneSitOn(sideSupport)
                }
            case .none:
                break
            }
        
            func createSideSupportForOneSitOn(_ sideSupport: GenericPartValue) {
                sideSupportDimensionsForOneSitOn.append(
                    UserEditedValue(
                        userEditedDictionary,
                        .id0,
                        .sideSupport,
                        sideSupport.id).dimension ??
                    sideSupport.dimension )
        }
        
        
        switch footSupportHangerLink {
            case .one (let one):
                footSuportMaxLength = one.maxDimension.length
            case .leftRight(let left, let right):
                footSuportMaxLength =
                    [left.maxDimension.length , right.maxDimension.length ].max() ?? 0.0
            case .none:
                break
        }
        
        
        bodySupportHeight = MiscObjectParameters(objectType).getMainBodySupportAboveFloor()

        //for sitOnId in bothSitOnId {
           
            sitOnDimensions.append(
                UserEditedValue(
                    userEditedDictionary,
                    sitOnId,
                    .sitOn,
                    sitOnId).dimension ?? sitOnDimension)
            
            
            
            
            for partId in bilateralIds {
                occupantFootSupportHangerLinksMaxLengths.append(
                    UserEditedValue(
                        userEditedDictionary,
                        sitOnId,
                        .sitOn,
                        partId).dimension?.length ?? footSuportMaxLength)
                
//                sideSupportDimensionsForOneSitOn.append(
//                    UserEditedValue(
//                        userEditedDictionary,
//                        sitOnId,
//                        .sideSupport,
//                        partId).dimension ??
//                        sideSupport?.dimension ??
//                        ZeroValue.dimension3d )
            }
            
            occupantSideSupportsDimensions.append(sideSupportDimensionsForOneSitOn)
        //}

       // sitOnOriginsIn = getEditedSitOnOrigins()

        setOriginsWithDriveAtDifferentLocations()
        
        func setOriginsWithDriveAtDifferentLocations() {
            let withThisLocation: Drive = MiscObjectParameters(objectType).getDriveLocation()
            
//            let leftAndRight = getOriginForLeftAndRightSitOn()
//            let rearAndFront = getOriginForRearAndFrontSitOn()
            
            sitOnOrigins = (
                onlyOne: [getDataForDrive(withThisLocation,getOriginForOneSitOn() )],
                rearAndFront: [
//                    getDataForDrive(withThisLocation,rearAndFront.rear ),
//                    getDataForDrive(withThisLocation,rearAndFront.front )
                ],
                leftAndRight: [
//                    getDataForDrive(withThisLocation,leftAndRight.left),
//                    getDataForDrive(withThisLocation,leftAndRight.right)
                ] )
            
        }
       
    }
    
    //there may be none, or one or two edited sitOn origins
    //if two these may be frontAndRear or sideBySide
//    func getEditedSitOnOrigins()
//        -> TwinSitOnOrigins {
//        var sitOnOrigins: [PositionAsIosAxes?] = []
//        var sitOnOriginsIn = ZeroValue.sitOnOrigins
//            for _ in [sitOnId] {
//            sitOnOrigins.append(nil
//            )
//        }
        // one or more nill
//        if sitOnOrigins.contains(where: { $0 == nil }) {
            ///two nil
//            if sitOnOrigins.allSatisfy({ $0 == nil }) {
            // do nothing
//            } else { //one nil
//                if let nonNilElement = sitOnOrigins.first(where: { $0 != nil } ) {
//                    sitOnOriginsIn =
//                        (onlyOne: [nonNilElement!],
//                         rearAndFront: [],
//                         leftAndRight: [])
//                }
//            }
//        } else {
            // No elements are nil so check for frontAndRear and sideBySide
//            let first = sitOnOrigins[0]!
//            let second = sitOnOrigins[1]!
            
            // if x origins difference is greatest must be side by side
//            if abs(first.x - second.x) > abs(first.y - second.y) {
//                sitOnOriginsIn =
//                    (onlyOne: [],
//                     rearAndFront: [],
//                     leftAndRight: [first, second])
//            } else {
//                sitOnOriginsIn =
//                    (onlyOne: [],
//                     rearAndFront: [first, second],
//                     leftAndRight: [])
//            }
//        }
//            return sitOnOriginsIn
//    }
//
    
//    func getEditedOrDefaultSideSupportDimensions(_ sitOnId: Part)
//        -> [Dimension3d] {
//            var sideSupportDimension: [Dimension3d] = []
//            for _ in bilateralIds {
//                let dimension =
//                    OccupantSideSupportDefaultDimension(objectType).dimension
//                sideSupportDimension.append(dimension)
//            }
//        return
//            sideSupportDimension
//    }
    
    
    func getOriginForOneSitOn()
     -> [PositionAsIosAxes] {
         [ (
            x: 0.0,
            y: sitOnDimensions[onlyOne].length/2,
            z: bodySupportHeight ),
          (
            x: 0.0,
            y: 0.0,
            z: bodySupportHeight ),
         (
            x: 0.0,
            y: -sitOnDimensions[onlyOne].length/2,
            z: bodySupportHeight ) ]
     }
    
    
//    func getOriginForRearAndFrontSitOn()
//    -> (rear: [PositionAsIosAxes], front: [PositionAsIosAxes]) {
//        let lengthBetweenRearAndFrontSitOn  =
//            sitOnDimensions[rear].length +
//            occupantFootSupportHangerLinksMaxLengths[rear] +
//            sitOnDimensions[front].length/2
//        let rear =
//            [ (
//                x: 0.0,
//                y: sitOnDimensions[rear].length/2,
//                z: bodySupportHeight),
//                (
//                x: 0.0,
//                y: -lengthBetweenRearAndFrontSitOn/2,
//                z: bodySupportHeight),
//                (
//                x: 0.0,
//                y: -lengthBetweenRearAndFrontSitOn,
//                z: bodySupportHeight) ]
//
//        let front =
//            [ (
//                x:0.0,
//                 y: lengthBetweenRearAndFrontSitOn,
//                 z: bodySupportHeight),
//                (
//                x:0.0,
//                 y: lengthBetweenRearAndFrontSitOn/2,
//                 z: bodySupportHeight),
//                (
//                x:0.0,
//                y: -sitOnDimensions[front].length/2,
//                z: bodySupportHeight) ]
//        return (rear: rear, front: front)
//    }
    
    
//    func getOriginForLeftAndRightSitOn()
//    -> (left: [PositionAsIosAxes], right: [PositionAsIosAxes]){
//        let totalExternalWidthBetweenLeftandRightSideSupport =
//            occupantSideSupportsDimensions[left][left].width +
//            sitOnDimensions[left].width +
//            occupantSideSupportsDimensions[right][right].width +
//            sitOnDimensions[right].width
//        let xLeftOriginForLeftAndRightSitOn =
//            -totalExternalWidthBetweenLeftandRightSideSupport/2 +
//            occupantSideSupportsDimensions[left][left].width +
//                sitOnDimensions[left].width/2
//        let xRightOriginForLeftAndRightSitOn =
//            totalExternalWidthBetweenLeftandRightSideSupport/2 -
//            occupantSideSupportsDimensions[right][right].width -
//                sitOnDimensions[right].width/2
//        let left =
//            [ (
//                x: xLeftOriginForLeftAndRightSitOn,
//                y: sitOnDimensions[left].length/2,
//                z: bodySupportHeight),
//              (
//                x: xLeftOriginForLeftAndRightSitOn,
//                y: 0.0,
//                z:bodySupportHeight),
//             (
//                x: xLeftOriginForLeftAndRightSitOn,
//                y: -sitOnDimensions[left].length/2,
//                z: bodySupportHeight) ]
//        let right =
//            [ (
//                x: xRightOriginForLeftAndRightSitOn,
//                y: sitOnDimensions[right].length/2,
//                z: bodySupportHeight),
//              (
//                x: xRightOriginForLeftAndRightSitOn,
//                y: 0.0,
//                z:bodySupportHeight),
//              (
//                x: xRightOriginForLeftAndRightSitOn,
//                y: -sitOnDimensions[right].length/2,
//                z: bodySupportHeight) ]
//        return ( left: left, right: right)
//
//    }
    
    
    func getDataForDrive<T> (_ at: Drive, _ originsForThisCall: [T])
    -> T {
        
        switch at {
        case .rear:
            return originsForThisCall[0]
        case .mid:
            return originsForThisCall[1]
        case .front:
            return originsForThisCall[2]
            
        }
    }

    
}


struct PreTiltWheelBaseJointOriginForOneSitOn {
  
    let objectType: ObjectTypes
    let stability: Stability
    
    var sitOnDimensions: [Dimension3d] = []
    var sitOnOrigins: [PositionAsIosAxes]
    var occupantSideSupportsDimensions: [[Dimension3d]] = []
    
    
    let wheelDefaultDimensionForRearMidFront: Dimension3dRearMidFront
    var wheelBaseJointOriginForOnlyOneSitOn: RearMidFrontPositions = ZeroValue.rearMidFrontPositions
    
    var wheelBaseJointOrigins: TwinSitOnOrigins = ZeroValue.sitOnOrigins
    let onlyOne = 0
    let rear = 0
    let front = 1
    let left = 0
    let right = 1
  
    /// 1) rearAndFront && sleftAndRight == false: one origin .id0
    /// 2) rearAndFront == true && sideBySide == false: two origin .id0 (rear), .id1 (front)
    /// 3) rearAndFront == false && leftAndRight == true: two origin .id0 (left), .id1 (right)
    /// locations as per viewing screen
    /// [[PositionAsIos]]
    
    init(
        _ object: ObjectTypes,
        _ twinSitOn: TwinSitOn,
        _ occupantSideSupportsDimensions: [[Dimension3d]] ) {

        self.objectType = object
        self.sitOnDimensions = [twinSitOn.onlyOne[0].dimension]
        self.sitOnOrigins = [twinSitOn.onlyOne[0].origin]
        self.occupantSideSupportsDimensions = occupantSideSupportsDimensions
                  
        stability = Stability(objectType)

        wheelDefaultDimensionForRearMidFront =
            WheelDefaultDimensionForRearMidFront(object).dimensions

        let wheelBaseJointOrigin = getWheelBaseJointOrigin()
    }
    
    func getWheelBaseJointOrigin() -> [RearMidFrontPositions]{
        let rear =
            (rear: (
                 x: sitOnDimensions[onlyOne].width/2 +
                    occupantSideSupportsDimensions[left][right].width +
                    stability.atRightRear,
                 y: stability.atRear,
                 z: wheelDefaultDimensionForRearMidFront.rear.height/2 ),
             mid: (
                 x: sitOnDimensions[onlyOne].width/2 +
                   occupantSideSupportsDimensions[left][right].width +
                   stability.atRightMid,
                y:  sitOnDimensions[onlyOne].length/2 +
                    stability.atRear ,
                z: wheelDefaultDimensionForRearMidFront.mid.height/2 ),
             front: (
                x: sitOnDimensions[onlyOne].width/2 +
                   occupantSideSupportsDimensions[left][right].width +
                   stability.atRightFront,
                y: stability.atRear +
                    sitOnDimensions[onlyOne].length +
                    stability.atFront,
                z: wheelDefaultDimensionForRearMidFront.front.height/2 )
            )
        
        let mid =
            (rear: (
                x: sitOnDimensions[onlyOne].width/2 +
                   occupantSideSupportsDimensions[left][right].width +
                   stability.atRightRear,
                y: -sitOnDimensions[onlyOne].length/2 -
                   stability.atRear,
                z: wheelDefaultDimensionForRearMidFront.rear.height ),
            mid: (
                x: sitOnDimensions[onlyOne].width/2 +
                  occupantSideSupportsDimensions[left][right].width +
                  stability.atRightMid,
                y:  0.0,
               z: wheelDefaultDimensionForRearMidFront.mid.height ),
            front: (
               x: sitOnDimensions[onlyOne].width/2 +
                  occupantSideSupportsDimensions[left][right].width +
                  stability.atRightFront,
               y: sitOnDimensions[onlyOne].length/2 +
                   stability.atFront,
               z: wheelDefaultDimensionForRearMidFront.rear.height )
           )
        
        let front =
            (rear: (
                 x: sitOnDimensions[onlyOne].width/2 +
                    occupantSideSupportsDimensions[left][right].width +
                    stability.atRightRear,
                 y: stability.atRear -
                    sitOnDimensions[onlyOne].length -
                    stability.atFront,
                 z: wheelDefaultDimensionForRearMidFront.rear.height ),
             mid: (
                 x: sitOnDimensions[onlyOne].width/2 +
                   occupantSideSupportsDimensions[left][right].width +
                   stability.atRightMid,
                 y:  -sitOnDimensions[onlyOne].length/2 -
                 stability.atFront,
                z: wheelDefaultDimensionForRearMidFront.mid.height ),
             front: (
                x: sitOnDimensions[onlyOne].width/2 +
                   occupantSideSupportsDimensions[left][right].width +
                   stability.atRightFront,
                y: 0.0,
                z: wheelDefaultDimensionForRearMidFront.rear.height )
            )
        return [rear, mid, front]
    }
    
    
    func getDataForDrive<T> (_ at: Drive, _ originsForThisCall: [T])
    -> T {
        
        switch at {
        case .rear:
            return originsForThisCall[0]
        case .mid:
            return originsForThisCall[1]
        case .front:
            return originsForThisCall[2]
            
        }
    }

    
}
