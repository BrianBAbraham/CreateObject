//
//  CreateDefaultDimensionDictionary.swift
//  CreateObject
//
//  Created by Brian Abraham on 02/06/2023.
//

import Foundation

struct CreateDefaultDimensionDictionary {
    var dictionary: Part3DimensionDictionary = [:]

    init(
        _ parts: [Part],
        _ dimensions: [Dimension3d],
        _ twinSitOnOptions: TwinSitOnOptions) {
            
        var idsForPart: [Part] = [.id0, .id1]
        let idsForSitOn: [Part] =  TwinSitOn(twinSitOnOptions).state ? [.id0, .id1]: [.id0]
        
        // any part with backSupport in the name will only have one item per sitOn
        let onlyOneExists = [Part.backSupport.rawValue]
        let enumCodedSoAnyMemberCanBeUsed = 0
        idsForPart =
            onlyOneExists.contains(where: parts[enumCodedSoAnyMemberCanBeUsed].rawValue.contains) ? [.id0]: idsForPart

        for index in 0..<parts.count{
            for partId in  idsForPart {
                for sitOnId in idsForSitOn {
                    let nameEnd: [Part] = parts[index] == .sitOn ?
                    [sitOnId, .stringLink, .object, .id0] : [partId, .stringLink, .sitOn, sitOnId]
                    let x = [parts[index]] + nameEnd
                    self.dictionary +=
                    [CreateNameFromParts(x).name: dimensions[index] ]
                }
            }
        }
    }
}


struct ObjectDefaultDimension {
    let dictionary: Part3DimensionDictionary
    let modifiedPartDictionary: Part3DimensionDictionary
    let modifiedOriginDictionary: PositionDictionary
    let modifiedAngleDictionary: AngleDictionary
    
    init(
        _ baseType: BaseObjectTypes,
        _ twinSitOnOptions: TwinSitOnOptions,
        _ modifiedPartDictionary: Part3DimensionDictionary = [:],
        _ modifiedOriginDictinary: PositionDictionary = [:],
        _ modifiedAngleDictionary: AngleDictionary = [:]) {
            
            self.modifiedPartDictionary = modifiedPartDictionary
            self.modifiedOriginDictionary = modifiedOriginDictinary
            self.modifiedAngleDictionary = modifiedAngleDictionary
            
            dictionary =
            createDefaultObjectDictionary(
                baseType,
                twinSitOnOptions)
        
            func createDefaultObjectDictionary(
                _ baseType: BaseObjectTypes,
                _ twinSitOnOptions: TwinSitOnOptions)
                -> Part3DimensionDictionary {
                    var defaultDimensionDictionary =
                            RequestOccupantBodySupportDefaultDimensionDictionary(
                                baseType,
                                twinSitOnOptions,
                                modifiedPartDictionary).dictionary
                            
                        defaultDimensionDictionary +=
                                RequestOccupantFootSupportDefaultDimensionDictionary(
                                    baseType,
                                    twinSitOnOptions,
                                    modifiedPartDictionary).dictionary

                         defaultDimensionDictionary +=
                            RequestOccupantBackSupportDefaultDimensionDictionary(
                                baseType, twinSitOnOptions).dictionary

                        defaultDimensionDictionary +=
                            RequestOccupantSideSupportDefaultDimensionDictionary(
                                baseType,
                                twinSitOnOptions,
                                modifiedPartDictionary).dictionary
                    
                    return defaultDimensionDictionary
            }
    }
}




struct ObjectDefaultOrigin {
    let dictionary: PositionDictionary
    
    init(
        _ baseType: BaseObjectTypes,
        _ twinSitOnOptions: TwinSitOnOptions) {
            
            dictionary =
                createDefaultOriginDictionary(
                baseType,
                twinSitOnOptions)
            
            func createDefaultOriginDictionary(
                _ baseType: BaseObjectTypes,
                _ twinSitOnOptions: TwinSitOnOptions)
            -> PositionDictionary{
                
                return [:]
            }
        }
}


//
//struct Chair {
//    let sizeDictionaryOut: Part3DimensionDictionary = [:]
//    let originDictionaryOut: PositionDictionary = [:]
//    let options: ObjectOptions
//    let baseType: BaseObjectTypes
//
//
//    struct DistanceBetween {
//        let frontToRearWheels: BaseSizeDictionary =
//            [.fixedWheelRearDrive: 400.0, .fixedWheelFrontDrive: 400.0, .fixedWheelMidDrive: 400.0]
//        let frontToMidWheels: BaseSizeDictionary
//        let midToFrontWheels: BaseSizeDictionary
//        let rearWheels: BaseSizeDictionary
//        let midWheels: BaseSizeDictionary
//        let frontWheels: BaseSizeDictionary
//    }
//
//    struct SizeOf {
//        let parts: Part3DimensionDictionary =
//        [Part.armSupport.rawValue: ZeroTouple.dimension3D]
//
//    }
//
//    struct OriginFrom {
//
//    }
//
//}


/// part + origin + angle dictionary -> corner dictionary
/// tiltangle(sitOn, back, side, foot,
/// reclineAngle(back)
///

struct ObjectDefaultOrModifiedCornerDictionary {
    var orignDictionaryPostAngleOut: PositionDictionary = [:]
    var dimensionDictionaryPostAngleOut: Part3DimensionDictionary = [:]
    var cornerDictionaryOut: PositionDictionary = [:]
    let modifiedPartDictionary: Part3DimensionDictionary
    let modifiedOriginDictionary: PositionDictionary
    let modifiedAngleDictionary: AngleDictionary
    let baseType: BaseObjectTypes
    let twinSitOnOptions: TwinSitOnOptions
    let objectOptionDictionaries: OptionDictionary
    //var twinSitOnState: Bool //= false
    
    init(
        _ baseType: BaseObjectTypes,
        _ twinSitOnOptions: TwinSitOnOptions,
        _ objectOptionDictionaries: OptionDictionary,
        _ modifiedPartDictionary: Part3DimensionDictionary = [:],
        _ modifiedOriginDictionary: PositionDictionary = [:],
        _ modifiedAngleDictionary: AngleDictionary = [:] ) {
            
            self.baseType = baseType
            self.twinSitOnOptions = twinSitOnOptions
            self.objectOptionDictionaries = objectOptionDictionaries
            self.modifiedPartDictionary = modifiedPartDictionary
            self.modifiedOriginDictionary = modifiedOriginDictionary
            self.modifiedAngleDictionary = modifiedAngleDictionary
            
            
            for key in modifiedOriginDictionary.keys {
                if key.contains(Part.object.rawValue) {
                    
                }
                if key.contains(CreateNameFromParts([.sitOn,.id0,.stringLink]).name) {
                    
                }
            }
        }
    
    /// rules if parent is object if contains
    /// rules if parent is sitOn if contains  sitOn_id0_n
    /// rules if parent is backSupport
    /// tilt: get  part centre from rotation centtre and transfrom origin and transform part  dimension then sum transformed origin and transformed dimension for viewed size in plane
    ///  get % + child from parent and transform
    ///  repeat for each child
    ///  recline:  repeat above using new rotation centre and new angle but acting on tillted origin and tilted dimension
}


struct ObjectDefaultOrModifiedSpecification {
    
    static let sitOnHeight = 500.0
    var partDictionaryOut: Part3DimensionDictionary = [:]
    var originDictionaryOut: PositionDictionary = [:]
    var angleDictionaryOut: AngleDictionary = [:]
    let modifiedPartDictionary: Part3DimensionDictionary
    let modifiedOriginDictionary: PositionDictionary
    let modifiedAngleDictionary: AngleDictionary
    let baseType: BaseObjectTypes
    let twinSitOnOptions: TwinSitOnOptions
    let objectOptionDictionary: [OptionDictionary]
    var twinSitOnState: Bool //= false
    let oneOrTwoIds: [Part]
    
    init(
        _ baseType: BaseObjectTypes,
        _ twinSitOnOptions: TwinSitOnOptions,
        _ objectOptionDictionary: [OptionDictionary],
        _ modifiedPartDictionary: Part3DimensionDictionary = [:],
        _ modifiedOriginDictinary: PositionDictionary = [:],
        _ modifiedAngleDictionary: AngleDictionary = [:] ) {
            
        self.baseType = baseType
        self.twinSitOnOptions = twinSitOnOptions
        self.objectOptionDictionary = objectOptionDictionary
        self.modifiedPartDictionary = modifiedPartDictionary
        self.modifiedOriginDictionary = modifiedOriginDictinary
        self.modifiedAngleDictionary = modifiedAngleDictionary
            
        twinSitOnState = TwinSitOn(twinSitOnOptions).state
        
        oneOrTwoIds = twinSitOnState ? [.id0, .id1]: [.id0]
            
        partDictionaryOut +=
        RequestOccupantBodySupportDimensionDictionary(parent: self).dictionaryOut
        
        partDictionaryOut +=
        RequestOccupantBackSupportDimensionDictionary(parent: self).dictionaryOut
        
        partDictionaryOut +=
        RequestOccupantFootSupportDimensionDictionary(parent: self).dictionaryOut
        
        partDictionaryOut +=
        RequestOccupantSideSupportDimensionDictionary(parent: self).dictionaryOut
        
        originDictionaryOut +=
        RequestOccupantBodySupportOriginDictionary(parent: self).dictionaryOut

        originDictionaryOut +=
        RequestOccupantFootSupportOriginDictionary(parent: self).dictionaryOut
        
        angleDictionaryOut =
            RequestOccupantAngleDictionary(parent: self).dictionaryOut
        
    }
    
    //MARK: ANGLES
    
    struct RequestOccupantAngleDictionary {
        var dictionaryOut: AngleDictionary = [:]
        
        init(
            parent: ObjectDefaultOrModifiedSpecification) {
            
                let ids = parent.oneOrTwoIds
            
            setTiltDictionary(ids)
        
            func setTiltDictionary(_ ids: [Part]) {
                var name: String
                let defaultAngle =
                    OccupantBodySupportDefaultTiltAngle(parent.baseType).value
                
                var angle: Measurement<UnitAngle>
                var tiltState: Bool
                for index in 0..<ids.count {
                    tiltState =
                        (parent.objectOptionDictionary[index][.tiltInSpace] ?? false || parent.objectOptionDictionary[index][.tiltAndRecline] ?? false)
                    
                    name =
                    CreateNameFromParts([.tiltAngle, .stringLink, .sitOn, ids[index]]).name
                    
                    angle =
                        tiltState ?
                        parent.modifiedAngleDictionary[name] ?? defaultAngle:
                        defaultAngle
                    
                    dictionaryOut += [name: angle]
                }
            }
                
            func setBackReclineDictionary(_ ids: [Part]) {
                var name: String
                let defaultAngle =
                    OccupantBackSupportDefaultAngle(parent.baseType).value
               
                var angle: Measurement<UnitAngle>
                var tiltState: Bool
                
                for index in 0..<ids.count {
                    tiltState =
                        (parent.objectOptionDictionary[index][.reclinedBackSupport] ?? false || parent.objectOptionDictionary[index][.tiltAndRecline] ?? false)
                    
                    
                    name =
                    CreateNameFromParts([.backSupportReclineAngle, .stringLink, .sitOn, ids[index]]).name
                    
                    angle =
                        tiltState ?
                        parent.modifiedAngleDictionary[name] ?? defaultAngle:
                        defaultAngle
                    
                    dictionaryOut += [name: angle]
                }
            }
        }
    }
    
    //MARK: DIMENSION FOR BACK
    struct RequestOccupantBackSupportDimensionDictionary {
        var dictionaryOut: Part3DimensionDictionary = [:]
       
        init(
            parent: ObjectDefaultOrModifiedSpecification) {
            
            getDictionary()
            
            func getDictionary() {
                    
                let allOccupantRelated =
                    AllOccupantBackRelated(
                        parent.baseType)
                dictionaryOut =
                    CreateDefaultDimensionDictionary(
                        allOccupantRelated.parts,
                        allOccupantRelated.dimensions,
                        parent.twinSitOnOptions
                    ).dictionary
            }
        }
    }
    
    
    //MARK: DIMENSION FOR BODY
    struct RequestOccupantBodySupportDimensionDictionary {
        var dictionaryOut: Part3DimensionDictionary = [:]
        
        init(
            parent: ObjectDefaultOrModifiedSpecification) {
                
            getDictionary()
                
                
            func getDictionary() {
                let dimension =
                    OccupantBodySupportDefaultDimension(
                        parent.baseType).value
                
                let dimensions =
                parent.twinSitOnState ? [dimension, dimension]: [dimension]
                let parts: [Part] =
                parent.twinSitOnState ? [.sitOn, .sitOn]: [.sitOn]
                
                dictionaryOut =
                    CreateDefaultDimensionDictionary(
                        parts,
                        dimensions,
                        parent.twinSitOnOptions
                    ).dictionary
            }
        }
    }
    
    
    //MARK: DIMENSION FOR FOOT
    struct RequestOccupantFootSupportDimensionDictionary {
        var dictionaryOut: Part3DimensionDictionary = [:]
       
        init(
            parent: ObjectDefaultOrModifiedSpecification) {
            
            getDictionary()
            
            func getDictionary() {
                    
                let allOccupantRelated =
                    AllOccupantFootRelated(
                        parent.baseType,
                        parent.modifiedPartDictionary)
                dictionaryOut =
                    CreateDefaultDimensionDictionary(
                        allOccupantRelated.parts,
                        allOccupantRelated.dimensions,
                        parent.twinSitOnOptions
                    ).dictionary
            }
        }
    }
    
    
    //MARK: DIMENSION FOR SIDE
    struct RequestOccupantSideSupportDimensionDictionary {
        var dictionaryOut: Part3DimensionDictionary = [:]
       
        init(
            parent: ObjectDefaultOrModifiedSpecification) {
            
            getDictionary()
            
            func getDictionary() {
                    
                let allOccupantRelated =
                OccupantSideSupportDefaultDimension(
                    parent.baseType
                )
                
                dictionaryOut =
                    CreateDefaultDimensionDictionary(
                        [.armSupport],
                        [allOccupantRelated.value],
                        parent.twinSitOnOptions
                    ).dictionary
            }
        }
    }

    
    //MARK: ORIGIN FOR BODY
    struct RequestOccupantBodySupportOriginDictionary {
        var dictionaryOut: PositionDictionary = [:]
        
        let stability: Stability
        var origin: [PositionAsIosAxes] = []
        let frontAndRearState: Bool
        let leftandRightState: Bool

        var occupantBodySupportsDimension: [Dimension3d] = []
        var occupantFootSupportHangerLinksDimension: [Dimension3d] = []
        let distanceBetweenFrontAndRearWheels: DistanceBetweenFrontAndRearWheels2
        
        init(
            parent: ObjectDefaultOrModifiedSpecification) {
        
            stability = Stability(parent.baseType)
            
            frontAndRearState = parent.twinSitOnOptions[.frontAndRear] ?? false
            leftandRightState = parent.twinSitOnOptions[.leftAndRight] ?? false
  
            let bodySupportDefaultDimension = OccupantBodySupportDefaultDimension(parent.baseType).value
                
            occupantBodySupportsDimension =
                [getModifiedSitOnDimension(.id0)] +
                (parent.twinSitOnState ? [getModifiedSitOnDimension(.id1)] : [])
                         
            let occupantFootSupportHangerLinkDefaultDimension = OccupantFootSupportHangerLinkDefaultDimension(parent.baseType).value
                
            occupantFootSupportHangerLinksDimension =
                [getModifiedMaximumHangerLinkDimension(.id0)] +
                (parent.twinSitOnState ? [getModifiedMaximumHangerLinkDimension(.id1)]: [])
             
//print (parent.twinSitOnState)
            distanceBetweenFrontAndRearWheels =
                DistanceBetweenFrontAndRearWheels2(
                    parent.baseType,
                    occupantBodySupportsDimension,
                    occupantFootSupportHangerLinksDimension)
                
            if BaseObjectGroups().rearPrimaryOrigin.contains(parent.baseType) {
            forRearPrimaryOrigin()
            }
                
            if BaseObjectGroups().frontPrimaryOrigin.contains(parent.baseType) {
            forFrontPrimaryOrgin()
            }
                
            if BaseObjectGroups().midPrimaryOrigin.contains(parent.baseType) {
            forMidPrimaryOrigin()
            }
                
            getDictionary()
        
                
            func getModifiedSitOnDimension(_ id: Part)
                -> Dimension3d {
                let name =
                    CreateNameFromParts([.object, .id0, .stringLink, .sitOn, id]).name
                let modifiedDimension: Dimension3d? = parent.modifiedPartDictionary[name]
                return
                   modifiedDimension ?? bodySupportDefaultDimension
            }
              
                
            func getModifiedMaximumHangerLinkDimension(_ id: Part)
                -> Dimension3d {
                    let index = id == .id0 ? 0: 1
                    let footSupportInOnePieceState = parent.objectOptionDictionary[index][.footSupportInOnePiece] ?? false
                    let names: [String] =
                    [CreateNameFromParts([.footSupportHangerLink, .id0, .stringLink, .sitOn, id]).name]
                    var modifiedDimensions: [Dimension3d?] = [parent.modifiedPartDictionary[names[0]]]
                    
                    if footSupportInOnePieceState {
                        
                    } else {
                        let name =
                        CreateNameFromParts([.footSupportHangerLink, .id1, .stringLink, .sitOn, id]).name
                        modifiedDimensions += [parent.modifiedPartDictionary[name]]
                        
                    }
                
                    let unwrapped = modifiedDimensions.compactMap{ $0 }
                    
                    var modifiedDimension: Dimension3d?
                    
                    if unwrapped.count == 0 {
                        modifiedDimension = nil
                    } else {
                        let twoDoubles = [modifiedDimensions[0]!.length, modifiedDimensions[1]!.length]
                        let maximumDouble = twoDoubles.max()!
                        let index = twoDoubles.firstIndex(of: maximumDouble)!
                        modifiedDimension = modifiedDimensions[index]
                    }

                return
                   modifiedDimension ?? occupantFootSupportHangerLinkDefaultDimension
            }
                
                
            func getDictionary() {
                let ids =
                    parent.oneOrTwoIds
                
                    for index in 0..<ids.count {
                        self.dictionaryOut[
                            CreateNameFromParts([
                                .object,
                                .id0,
                                .stringLink,
                                .sitOn,
                                ids[index]
                                ]).name] = origin[index]
                    }
            }
            
            func forRearPrimaryOrigin() {
                origin.append(
                    (x: 0.0,
                    y:
                    stability.atRear +
                     occupantBodySupportsDimension[0].length/2,
                     z: ObjectDefaultOrModifiedSpecification.sitOnHeight)
                )
                
                if frontAndRearState {
                    origin.append(
                            (x: 0.0,
                            y:
                                
                            stability.atRear +
                            occupantBodySupportsDimension[0].length +
                            occupantFootSupportHangerLinksDimension[0].length +
                            occupantBodySupportsDimension[1].length/2,
                             z: ObjectDefaultOrModifiedSpecification.sitOnHeight)
                    )
                }
                
                if leftandRightState {
                    let xOrigin1 =
                        leftAndRightX()
                    let xOrigin0 =
                        -leftAndRightX()
                    
                origin =
                    [(x: xOrigin0,
                      y: origin[0].y,
                      z: 0.0),
                    (x: xOrigin1,
                     y: origin[0].y,
                     z: ObjectDefaultOrModifiedSpecification.sitOnHeight)
                    ]
                }
            }
                
            func forMidPrimaryOrigin(){
                let baseLength = frontAndRearState ?
                    distanceBetweenFrontAndRearWheels.ifFrontAndRearSitOn: distanceBetweenFrontAndRearWheels.ifNoFrontAndRearSitOn
                
                origin.append(
                (x: 0.0,
                 y: 0.5 * (baseLength - occupantBodySupportsDimension[0].length),
                 z: ObjectDefaultOrModifiedSpecification.sitOnHeight)
                )
                
                if frontAndRearState {
                    origin =
                    [
                    (x: 0.0,
                     y: -origin[0].y,
                     z: ObjectDefaultOrModifiedSpecification.sitOnHeight)
                     ,
                    (x: 0.0,
                     y: origin[0].y,
                    z: ObjectDefaultOrModifiedSpecification.sitOnHeight)
                    ]
                }
                
                if leftandRightState {
                    origin =
                    [
                    (x: 0.0,
                     y: -origin[0].y,
                     z: ObjectDefaultOrModifiedSpecification.sitOnHeight)
                     ,
                    (x: 0.0,
                     y: origin[0].y,
                    z: ObjectDefaultOrModifiedSpecification.sitOnHeight)
                    ]
                }
            }
                
            func forFrontPrimaryOrgin() {
                origin.append(
                    (x: 0.0,
                     y:
                    -(stability.atFront +
                        occupantBodySupportsDimension[0].length/2),
                     z: ObjectDefaultOrModifiedSpecification.sitOnHeight )
                     )
                
                if frontAndRearState {
                    origin = [
                        (x: 0.0,
                         y:
                            -stability.atFront -
                            occupantBodySupportsDimension[0].length -
                            occupantFootSupportHangerLinksDimension[1].length -
                            occupantBodySupportsDimension[1].length/2,
                         z: ObjectDefaultOrModifiedSpecification.sitOnHeight
                         ),
                        origin[0]
                    ]
                }
                
                if leftandRightState {
                    origin = [
                        (x: -leftAndRightX(),
                         y: origin[0].y,
                         z: ObjectDefaultOrModifiedSpecification.sitOnHeight),
                        (x: leftAndRightX(),
                         y: origin[0].y,
                         z: ObjectDefaultOrModifiedSpecification.sitOnHeight)
                    ]
                }
            }
                
                func leftAndRightX ()
                    -> Double {
                        (occupantBodySupportsDimension[0].width + occupantBodySupportsDimension[1].width)/2 +
                        OccupantSideSupportDefaultDimension(parent.baseType//, parent.modifiedPartDictionary
                        ).value.width
                }
        }
    }
    
    //MARK: ORIGIN FOR FOOT
    struct RequestOccupantFootSupportOriginDictionary {
        var dictionaryOut: PositionDictionary = [:]
       
        init(
            parent: ObjectDefaultOrModifiedSpecification) {
            
            getDictionary()
            
            func getDictionary() {
                let twoIds: [Part] = [.id0, .id1]
                let sitOnIds = parent.oneOrTwoIds
               

                
                
                    
                for sitOnIndex in 0..<sitOnIds.count {
                    var name: String
                    var position: PositionAsIosAxes
                    var positions: [PositionAsIosAxes]
                    
                    let footPlateInOnePieceState =
                    parent.objectOptionDictionary[sitOnIndex][.footSupportInOnePiece] ?? false
                    
                    for footSupportIndex in 0..<2 {
                        name =
                        CreateNameFromParts([
                            .sitOn,
                            sitOnIds[sitOnIndex],
                            .stringLink,
                            .footSupportHangerSitOnVerticalJoint,
                            twoIds[footSupportIndex] ]).name
                        
                        positions =
                        CreateIosPosition.forLeftRightAsArrayFromPosition(
                            SitOnToHangerVerticalJointDefaultOrigin(parent.baseType).value
                        )
                        
                        position =
                            parent.modifiedOriginDictionary[name] ??
                                positions[footSupportIndex]
                        self.dictionaryOut += [name :  position]
                        
                        
                        name =
                        CreateNameFromParts([
                            .footSupportHangerSitOnVerticalJoint,
                            sitOnIds[sitOnIndex],
                            .stringLink,
                            .footSupportHangerLink,
                            twoIds[footSupportIndex],
                        ]).name
                        
                        positions =
                        CreateIosPosition.forLeftRightAsArrayFromPosition(
                            HangerVerticalJointToHangerLinkDefaultOrigin(parent.baseType).value
                        )
                        
                        position = parent.modifiedOriginDictionary[name] ??
                            positions[footSupportIndex]
                        self.dictionaryOut += [name : position]
                    }
                    
                    let footSupportIds: [Part] =
                    footPlateInOnePieceState ? twoIds: [.id0]
                    
                    for footSupportIndex in 0..<footSupportIds.count {
                        name =
                        CreateNameFromParts([
                            .footSupportHorizontalJoint,
                            sitOnIds[sitOnIndex],
                            .stringLink,
                            .footSupport,
                            footSupportIds[footSupportIndex] ]).name
                        
                        positions = footPlateInOnePieceState ?
                        [FootSupportJointToFootSupportInOnePieceDefaultOrigin(parent.baseType).value]:
                        CreateIosPosition.forLeftRightAsArrayFromPosition(
                                HangerVerticalJointToHangerLinkDefaultOrigin(parent.baseType).value
                            )
                        
                        position = parent.modifiedOriginDictionary[name] ?? positions[footSupportIndex]
                        
                        self.dictionaryOut += [name : position]
                    }
                }
            }
        }
    }
}
