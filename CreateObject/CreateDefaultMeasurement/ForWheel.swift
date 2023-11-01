//
//  ForWheel.swift
//  CreateObject
//
//  Created by Brian Abraham on 05/06/2023.
//

import Foundation


struct ObjectBaseConnectionDefaultDimension: PartDimension {
    mutating func reinitialise(_ part: Part?) {
        self.part = part
        switch part {
            
            
        case .fixedWheelHorizontalJointAtRear, .fixedWheelHorizontalJointAtMid:
            dimension =
                getHorizontalJoint()
        case .fixedWheelAtRear:
            dimension =
            getFixedWheelRearDrive()
            
        case .fixedWheelAtMid:
            dimension =
                getFixedWheelMidDrive()
//            print("DETECTION")
//            print(dimension)
        case .fixedWheelAtFront:
            dimension =
                geFixedWheelFrontDrive()

        case .casterVerticalJointAtRear:
            dimension =
                getVerticalJoint()
        case .casterForkAtRear:
            dimension =
                getCasterForkAtRear()
        case .casterWheelAtRear:
            dimension = getCasterWheelAtRear()
            
        case .casterVerticalJointAtFront:
            dimension =
                getVerticalJoint()
        case .casterForkAtFront:
            dimension =
                getCasterForkAtFront()
        case .casterWheelAtFront:
            dimension = getCasterWheelAtFront()
        case .sitOnTiltJoint:
            dimension = Joint.dimension3d
        default:
            break
        }
    }
    
    let objectType: ObjectTypes
    var dimension: Dimension3d = ZeroValue.dimension3d
    var part: Part?

    init ( _ objectType: ObjectTypes) {
        self.objectType = objectType
    }
    func geFixedWheelFrontDrive ()
    -> Dimension3d {
        getFixedWheel()
    }

    func getFixedWheelMidDrive ()
    -> Dimension3d {
        getFixedWheel()
    }

    func getFixedWheelRearDrive ()
    -> Dimension3d {
        getFixedWheel()
    }
    
    func getHorizontalJoint ()
    -> Dimension3d {
        Joint.dimension3d
    }
    
    func getFixedWheel()
        -> Dimension3d {
        let dictionary: BaseObject3DimensionDictionary =
            [.fixedWheelManualRearDrive:
                (width: 20.0,
                 length: 600.0,
                 height: 600.0),
             
                ]
        let general =
            (width: 50.0,
              length: 200.0,
              height: 200.0)
        return
            dictionary[objectType] ??
            general
    }
    
    func getVerticalJoint ()
        -> Dimension3d {
            Joint.dimension3d
    }
    
    
    func getCasterForkAtRear()
        -> Dimension3d {
        let dictionary: BaseObject3DimensionDictionary =
            [.fixedWheelMidDrive:
                (width: 40.0,
                 length: 75.0,
                 height: 40.0),
             
                ]
        let general =
            (width: 50.0,
              length: 100.0,
              height: 50.0)
        return
            dictionary[objectType] ??
            general
        
    }
    
    func getCasterWheelAtRear()
        -> Dimension3d {
        let dictionary: BaseObject3DimensionDictionary =
            [.fixedWheelMidDrive:
                (width: 20.0,
                 length: 75.0,
                 height: 50.0),
             
                ]
        let general =
            (width: 50.0,
              length: 150.0,
              height: 100.0)
        return
            dictionary[objectType] ??
            general
        
    }
    
    
    func getCasterForkAtFront()
        -> Dimension3d {
        let dictionary: BaseObject3DimensionDictionary =
            [.fixedWheelMidDrive:
                (width: 40.0,
                 length: 75.0,
                 height: 40.0),
             
                ]
        let general =
            (width: 50.0,
              length: 100.0,
              height: 50.0)
        return
            dictionary[objectType] ??
            general
        
    }
    
    func getCasterWheelAtFront()
        -> Dimension3d {
        let dictionary: BaseObject3DimensionDictionary =
            [.fixedWheelMidDrive:
                (width: 20.0,
                 length: 75.0,
                 height: 50.0),
             
                ]
        let general =
            (width: 50.0,
              length: 150.0,
              height: 100.0)
        return
            dictionary[objectType] ??
            general
        
    }

}
    



    struct Stability {
        let dictionary: BaseObjectDoubleDictionary = [:]
        
        let atRear = 0.0
        let atFront = 0.0
        let atLeft = 0.0
        let atLeftRear = 0.0
        let atRightRear = 0.0
        let atRightMid = 0.0
        let atRightFront = 0.0
        let atRight = 0.0
        let baseType: ObjectTypes
        
        init(_ objectType: ObjectTypes) {
            self.baseType = objectType
        }
    }



struct WheelDefaultDimensionForRearMidFront {
    var dimensions: Dimension3dRearMidFront = ZeroValue.dimension3dRearMidFront
    var baseObjectGroups: BaseObjectGroups {
        BaseObjectGroups()
    }
   var wheelDefaultDimension: ObjectBaseConnectionDefaultDimension
   
    
    init(_ object: ObjectTypes) {
        wheelDefaultDimension = ObjectBaseConnectionDefaultDimension(object)
        dimensions = getDimensions(object)
        
    }
    
  mutating  func getDimensions(_ object: ObjectTypes)
        -> Dimension3dRearMidFront {
            var wheelDimensions =
                (
                rear: ZeroValue.dimension3d,
                mid: ZeroValue.dimension3d,
                front: ZeroValue.dimension3d )
            wheelDefaultDimension.reinitialise(.casterWheelAtRear)
            let casterWheelAtRear = wheelDefaultDimension.dimension
            wheelDefaultDimension.reinitialise(.casterWheelAtMid)
            let casterWheelAtMid = wheelDefaultDimension.dimension
            wheelDefaultDimension.reinitialise(.casterWheelAtFront)
            let casterWheelAtFront = wheelDefaultDimension.dimension
            wheelDefaultDimension.reinitialise(.fixedWheel)
            let fixedWheel = wheelDefaultDimension.dimension
            
            
            if baseObjectGroups.allCaster.contains(object) {
                wheelDimensions =
                    (
                    rear: casterWheelAtRear,
                    mid: casterWheelAtMid,
                    front: casterWheelAtFront )
            }
            
            if baseObjectGroups.rearFixedWheel.contains(object) {
                wheelDimensions =
                    (
                    rear: fixedWheel,
                    mid: casterWheelAtMid,
                    front: casterWheelAtFront )
            }
            
            if baseObjectGroups.midFixedWheel.contains(object) {
                wheelDimensions =
                    (
                    rear: casterWheelAtRear,
                    mid: fixedWheel,
                    front: casterWheelAtFront)
               // print(wheelDimensions)
            }
            
            if baseObjectGroups.frontFixedWheel.contains(object) {
                wheelDimensions =
                    (
                    rear: casterWheelAtRear ,
                    mid: casterWheelAtMid ,
                    front:  fixedWheel)
                
            }
            return wheelDimensions
    }
    
}





struct WheelId {
    let atMid: [Part] = [.id2, .id3]
    let atRear: [Part]
    let atFront: [Part]
    var allIds: [[Part]] = []
    let baseType: ObjectTypes
    
    init( _ baseType: ObjectTypes) {
        
        self.baseType = baseType
        
        atRear = getAtRear()
        atFront = getAtFront()
        
        // id locations are assigned as follows
        // as visually layed out
        //
        // id0...id1 for two
        //
        // id0...id1 for three front
        //    id2
        //
        //    id0    for three rear
        // id1...id2
        //
        // id0...id1 for four
        // id2...id3
        //
        // id0...id1 for six
        // id2...id3
        // id4...id5
        //
        func getAllIds() {
           allIds = [getAtRear()]
            if BaseObjectGroups().sixWheels.contains(baseType) {
                allIds.append(atMid)
            }
            allIds.append(getAtFront())
        }
        
        func getAtRear() -> [Part] {
            BaseObjectGroups().singleWheelAtRear
                    .contains(baseType) ?
                        [.id0]: [.id0, .id1]
        }
        
       
        func getAtFront ()
            -> [Part] {
                var ids: [Part] = [.id2, .id3]
                
            if BaseObjectGroups().singleWheelAtRear
                .contains(baseType) {
               ids = [.id1, .id2]
            }
            if BaseObjectGroups().singleWheelAtFront
                .contains(baseType) {
               ids = [.id2]
            }
            if BaseObjectGroups().sixWheels
                .contains(baseType) {
             ids =  [.id4, .id5]
            }
                
            if BaseObjectGroups().singleWheelAtFront
                .contains(baseType) {
              ids =  [ .id2]
            }
            return ids
        }
    }
}



struct BaseConnectionId {
    mutating func reinialise (_ part: Part?) {
        self.part = part
        switch part {
            case
                .fixedWheelHorizontalJointAtRear,
                .fixedWheelAtRear:
                    ids = fixedWheelAtRear()
            case
                .fixedWheelHorizontalJointAtMid,
                .fixedWheelAtMid:
                    ids = fixedWheelAtMid()
            case
                .fixedWheelHorizontalJointAtFront,
                .fixedWheelAtFront:
                    ids = fixedWheelAtFront()
            case
                .casterVerticalJointAtRear,
                .casterForkAtRear,
                .casterWheelAtRear:
                    ids = casterAtRear()
            case
                .casterVerticalJointAtMid,
                .casterForkAtMid,
                .casterWheelAtMid:
                    ids = casterAtMid()
            case
                .casterVerticalJointAtFront,
                .casterForkAtFront,
                .casterWheelAtFront:
                    ids = casterAtFront()
        default:
            break
        }
    }
    let objectType: ObjectTypes
    var part: Part?
    var ids: [Part] = [.id0]
    
    init ( _ objectType: ObjectTypes) {
        self.objectType = objectType
    }
    
    
    func fixedWheelAtRear()
    -> [Part]{
        [.id0, .id1]
    }
    
    
    func fixedWheelAtMid()
    -> [Part]{
        [.id0, .id1]
    }
    
    
    func fixedWheelAtFront()
    -> [Part]{
        [.id0, .id1]
    }
    
    
    func  casterAtRear ()
    -> [Part] {
        [.id0, .id1]
    }
    
    
    func  casterAtMid ()
    -> [Part] {
        switch objectType {
        case .allCasterSixHoist:
            return [.id2, .id3]
        default:
            return []
        }
    }
    
    
    func  casterAtFront ()
    -> [Part] {
        switch objectType {
            case
                .allCasterBed,
                .allCasterChair,
                .allCasterHoist,
                .allCasterTiltInSpaceShowerChair,
                .allCasterStretcher,
                .allCasterStandAid,
                .fixedWheelMidDrive:
                    return [.id2, .id3]
            case
                .fixedWheelRearDrive,
                .fixedWheelManualRearDrive:
                    return [.id0,.id1]
            case .allCasterSixHoist:
                return [.id4, .id5]
            default:
            print ("\(#function) \(objectType) not found")
                return []
        }
    }
}




struct PreTiltBaseJointDefaultOrigin: PartOrigin {
    var origin: PositionAsIosAxes = ZeroValue.iosLocation
    var part: Part?
    var preTiltSitOnAndWheelBaseJointOrigin: PreTiltSitOnAndWheelBaseJointOrigin
    var wheelDefaultDimension: ObjectBaseConnectionDefaultDimension
    
    mutating func reinitialise(_ part: Part?) {
        self.part = part
        //print (part)
        switch part {
            case .fixedWheelHorizontalJointAtRear:
                origin = getObjectToWheelHorizontalJointAtRear()
            case .fixedWheelHorizontalJointAtMid:
                origin = getObjectToWheelHorizontalJointAtMid()
            case .fixedWheelHorizontalJointAtFront:
                origin = getObjectToWheelHorizontalJointAtFront()
            case .fixedWheelAtRear:
                origin = getWheelHorizontalJointToFixedWheelAtRear()
            case .fixedWheelAtMid:
                origin = getWheelHorizontalJointToFixedWheelAtMid()
            case .casterVerticalJointAtRear:
                origin = getCasterWheelVerticalAxisAtRear()
            case .casterForkAtRear:
                origin = getCasterForkAtRear()
            case .casterWheelAtRear:
            origin = getCasterWheelAtRear()
            case .casterVerticalJointAtFront:
                origin = getCasterWheelVerticalAxisAtFront()
            case .casterForkAtFront:
                origin = getCasterForkAtFront()
            case .casterWheelAtFront:
                origin = getCasterWheelAtFront()
            case .sitOnTiltJoint:
                origin = getSitOnTiltJoint()
        default:
            print("\(#function) \(part?.rawValue ?? "noPartName") not found")
           break
        }
    }
    
    let objectType: ObjectTypes
   
    
    init ( _ objectType: ObjectTypes) {
        self.objectType = objectType
        
        preTiltSitOnAndWheelBaseJointOrigin = PreTiltSitOnAndWheelBaseJointOrigin(objectType)
        wheelDefaultDimension = ObjectBaseConnectionDefaultDimension(objectType)
    }

    
    func getOrigin() -> PositionAsIosAxes {
        origin
    }
    

    func getObjectToWheelHorizontalJointAtRear()
        -> PositionAsIosAxes {
        let dictionary: OriginDictionary = [:]
        let general = preTiltSitOnAndWheelBaseJointOrigin.wheelBaseJointOriginForOnlyOneSitOn.rear
        return
            dictionary[objectType] ?? general
    }
    
    func getObjectToWheelHorizontalJointAtMid()
        -> PositionAsIosAxes {
        let dictionary: OriginDictionary = [:]
        let general = preTiltSitOnAndWheelBaseJointOrigin.wheelBaseJointOriginForOnlyOneSitOn.mid
        return
            dictionary[objectType] ?? general
    }
    
    func getObjectToWheelHorizontalJointAtFront()
        -> PositionAsIosAxes {
        let dictionary: OriginDictionary = [:]
        let general = preTiltSitOnAndWheelBaseJointOrigin.wheelBaseJointOriginForOnlyOneSitOn.front
        return
            dictionary[objectType] ?? general
    }
    
    func getWheelHorizontalJointToFixedWheelAtRear()
        -> PositionAsIosAxes {
        let dictionary: OriginDictionary = [:]
        let general =
            (x: 0.0,
             y: 0.0,
             z: 0.0)
        return
            dictionary[objectType] ?? general
    }
    
    func getWheelHorizontalJointToFixedWheelAtMid()
        -> PositionAsIosAxes {
        let dictionary: OriginDictionary = [:]
        let general =
            (x: 0.0,
             y: 0.0,
             z: 0.0)
        return
            dictionary[objectType] ?? general
    }
    
    func getCasterWheelVerticalAxisAtRear()
        -> PositionAsIosAxes {
        let dictionary: OriginDictionary = [:]
        let general = preTiltSitOnAndWheelBaseJointOrigin.wheelBaseJointOriginForOnlyOneSitOn.rear
            
        return
            dictionary[objectType] ?? general
    }
    
    
    mutating func getCasterForkAtRear()
    -> PositionAsIosAxes {
        wheelDefaultDimension.reinitialise(.casterForkAtRear)
        let dictionary: OriginDictionary = [:]
        let general =
        (x: 0.0,
         y: -wheelDefaultDimension.dimension.length/2,
         z: 0.0)
        return
            dictionary[objectType] ?? general
    }
    
    
   mutating func getCasterWheelAtRear()
    -> PositionAsIosAxes {
        wheelDefaultDimension.reinitialise(.casterWheelAtRear)
        let dictionary: OriginDictionary = [:]
        let general =
        (x: 0.0,
         y: 0.0,
         z: -wheelDefaultDimension.dimension.height/2)
        return
            dictionary[objectType] ?? general
    }
    
    
    func getCasterWheelVerticalAxisAtFront()
        -> PositionAsIosAxes {
        let dictionary: OriginDictionary = [:]
        let general = preTiltSitOnAndWheelBaseJointOrigin.wheelBaseJointOriginForOnlyOneSitOn.front
            
        return
            dictionary[objectType] ?? general
    }
    
    
    mutating func getCasterForkAtFront()
    -> PositionAsIosAxes {
        wheelDefaultDimension.reinitialise(.casterForkAtFront)
        let dictionary: OriginDictionary = [:]
        let general =
        (x: 0.0,
         y: -wheelDefaultDimension.dimension.length/2,
         z: 0.0)
        return
            dictionary[objectType] ?? general
    }
    
    
   mutating func getCasterWheelAtFront()
    -> PositionAsIosAxes {
        wheelDefaultDimension.reinitialise(.casterWheelAtFront)
        let dictionary: OriginDictionary = [:]
        let general =
        (x: 0.0,
         y: 0.0,
         z: -wheelDefaultDimension.dimension.height/2)
        return
            dictionary[objectType] ?? general
    }
    
    func getSitOnTiltJoint()
    -> PositionAsIosAxes {
        return
            (x: 0.0,
             y: -100.0,
             z: 0.0)
        }
    
}




