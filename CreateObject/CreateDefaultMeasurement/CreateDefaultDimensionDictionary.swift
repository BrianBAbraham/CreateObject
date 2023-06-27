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

//struct ObjectDefaultOrModifiedCornerDictionary {
//    var orignDictionaryPostAngleOut: PositionDictionary = [:]
//    var dimensionDictionaryPostAngleOut: Part3DimensionDictionary = [:]
//    var cornerDictionaryOut: PositionDictionary = [:]
//    let defaultOrModifiedPartDictionary: Part3DimensionDictionary
//    let defaultOrModifiedOriginDictionary: PositionDictionary
//    let defaultOrModifiedAngleDictionary: AngleDictionary
//    let baseType: BaseObjectTypes
//    let twinSitOnOptions: TwinSitOnOptions
//    let objectOptionDictionaries: OptionDictionary
//
//    init(
//        _ baseType: BaseObjectTypes,
//        _ twinSitOnOptions: TwinSitOnOptions,
//        _ objectOptionDictionaries: OptionDictionary,
//        _ defautlOrModifiedPartDictionary: Part3DimensionDictionary = [:],
//        _ defaultOrModifiedOriginDictionary: PositionDictionary = [:],
//        _ defaultOrModifiedAngleDictionary: AngleDictionary = [:] ) {
//
//            self.baseType = baseType
//            self.twinSitOnOptions = twinSitOnOptions
//            self.objectOptionDictionaries = objectOptionDictionaries
//            self.defaultOrModifiedPartDictionary = defautlOrModifiedPartDictionary
//            self.defaultOrModifiedOriginDictionary = defaultOrModifiedOriginDictionary
//            self.defaultOrModifiedAngleDictionary = defaultOrModifiedAngleDictionary
//
//            let defaultOrModifiedOriginNames =
//            Set(DictionaryInArrayOut().getNameValue(defaultOrModifiedOriginDictionary))
//            let childSitOnName =
//            CreateNameFromParts([.stringLink,.sitOn,.stringLink]).name
//
//            let nonSitOn =
//            Set([CreateNameFromParts([.stringLink,.sleepOnSupport,.stringLink]).name, CreateNameFromParts([.stringLink,.sleepOnSupport,.stringLink]).name])
//
//            if defaultOrModifiedOriginNames.contains(childSitOnName) {
//
//            }
//
//            if !defaultOrModifiedOriginNames.isDisjoint(with: nonSitOn) {
//
//            }
//
//            func forSitOn () {
//
//
//            }
//
//
//            func forNonSitOn() {
//
//            }
//
//            let childFootSupportName = CreateNameFromParts([.stringLink,.footSupport,.stringLink]).name
//
//        }
//}

//MARK: PARENT
struct ObjectDefaultOrModifiedSpecification {
    
    static let sitOnHeight = 500.0
    var partDictionaryOut: Part3DimensionDictionary = [:]
    var parentToPartOriginDictionaryOut: PositionDictionary = [:]
    var objectToPartOriginDictionaryOut: PositionDictionary = [:]
    var angleChangeDictionaryOut: AngleDictionary = [:]
    let modifiedPartDictionary: Part3DimensionDictionary
    let modifiedOriginDictionary: PositionDictionary
    let modifiedAngleDictionary: AngleDictionary
    let baseType: BaseObjectTypes
    let twinSitOnOptions: TwinSitOnOptions
    let objectOptionDictionaries: [OptionDictionary]
    var twinSitOnState: Bool //= false
    let oneOrTwoIds: [Part]
    
    init(
        _ baseType: BaseObjectTypes,
        _ twinSitOnOptions: TwinSitOnOptions,
        _ objectOptionDictionaries: [OptionDictionary],
        _ modifiedPartDictionary: Part3DimensionDictionary = [:],
        _ modifiedOriginDictinary: PositionDictionary = [:],
        _ modifiedAngleDictionary: AngleDictionary = [:] ) {
            
        self.baseType = baseType
        self.twinSitOnOptions = twinSitOnOptions
        self.objectOptionDictionaries = objectOptionDictionaries
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
        
        
            
            
        parentToPartOriginDictionaryOut +=
        RequestOccupantBodySupportOriginDictionary(parent: self).parentToPartDictionaryOut

        objectToPartOriginDictionaryOut += parentToPartOriginDictionaryOut// sit on is first item
            
        let occupantFootSupportOriginDefaultOrModifiedDictionary =
            OccupantFootSupportOriginDefaultOrModifiedDictionary(parent: self)
            
        parentToPartOriginDictionaryOut += occupantFootSupportOriginDefaultOrModifiedDictionary.parentToPart
    
        objectToPartOriginDictionaryOut +=
        occupantFootSupportOriginDefaultOrModifiedDictionary.objectToPart
            
//print(objectToPartOriginDictionaryOut)
            
            
        angleChangeDictionaryOut =
            RequestOccupantAngleDictionary(parent: self).defaultOrModified

        objectToPartOriginDictionaryOut +=
            OccupanBodySupportRotationOriginDefaultOrModifiedDictionary(parent: self).objectToPart
 
//print(angleChangeDictionaryOut)
//DictionaryInArrayOut().getNameValue(objectToPartOriginDictionaryOut).forEach{print($0)}
ObjectAfterRotationDictionary(parent: self)

//print(objectToPartOriginDictionaryOut)
//let test = ObjectAfterRotationDictionary(parent: self)
            
        }
    
    
    
    //MARK: ROTATION
    struct ObjectAfterRotationDictionary {
        var forOrigin: PositionDictionary = [:]
        var forDimension: Part3DimensionDictionary = [:]

        /// act on origin
        /// act on dimension
        /// rotate all seat with all back and feet part
        /// OR
        /// rotate all seat with all back
        /// then
        /// rotate all back
        /// rotate all head
        /// AND
        /// rotate all foot
        ///
        
        init(
            parent: ObjectDefaultOrModifiedSpecification ) {
                
            //let sitOnIds =
            
            for sitOnId in parent.oneOrTwoIds {
                let tiltOriginPart: [Part] =
                    [.object, .id0, .stringLink, .bodySupportAngleJoint, .id0, .stringLink, .sitOn, sitOnId]
                let tiltOriginName =
                CreateNameFromParts(tiltOriginPart).name
                    let angleName =
                CreateNameFromParts([.bodySupportAngle, .stringLink, .sitOn, sitOnId]).name
//print("test in progress")
//print(tiltOriginName)
//print(parent.objectToPartOriginDictionaryOut)
//print("")
                if let tiltOrigin = parent.objectToPartOriginDictionaryOut[tiltOriginName] {
//print("success")
//print(tiltOriginName)
//print(tiltOrigin)
//print("")
                    forSitOnTilt(
                        parent,
                        tiltOrigin,
                        parent.angleChangeDictionaryOut[angleName] ?? Measurement(value: 0.0, unit: UnitAngle.radians),
                        sitOnId)
                } else {
print("failure")
                }
                }
            }
        
        func forSitOnTilt (
            _ parent: ObjectDefaultOrModifiedSpecification,
            _ originOfRotation: PositionAsIosAxes,
            _ changeOfAngle: Measurement<UnitAngle>,
            _ sitOnId: Part) {
                
            let allPartsSubjectToAngle = PartGroupsFor().allAngle
            let partsOnLeftAndRight = PartGroupsFor().leftAndRight
       
                for part in  allPartsSubjectToAngle {
                let partId: [Part] =  partsOnLeftAndRight.contains(part) ? [.id0, .id1]: [.id0]
          
                for partId in partId {
                    let partName =
                        CreateNameFromParts([
                            .object, .id0, .stringLink, part, partId, .stringLink, .sitOn, sitOnId]).name
                        
                    if let originOfPart = parent.parentToPartOriginDictionaryOut[partName] {
                        let newPosition =
                        PositionOfPointAfterRotationAboutPoint(
                            staticPoint: originOfRotation,
                            movingPoint: originOfPart,
                            angleChange: changeOfAngle).fromOriginToPointWhichHasMoved
print("old pos")
print(partName)
print(originOfPart)
print(originOfRotation)
print(newPosition)
print("new pos")
print("")
                    }
                }
            }
        }
        
        
        func forNonSitOn(_ parent: ObjectDefaultOrModifiedSpecification) {
            let thereIsOnlyOne = 0
//            if tiltRequiredState[thereIsOnlyOne] {
//
//            }
        }
    
            

    }
    
    
    
    
    
    
    
    
    /// rules if parent is object if contains
    /// rules if parent is sitOn if contains  sitOn_id0_n
    /// rules if parent is backSupport
    /// tilt: get  part centre from rotation centtre and transfrom origin and transform part  dimension then sum transformed origin and transformed dimension for viewed size in plane
    ///  get % + child from parent and transform
    ///  repeat for each child
    ///  recline:  repeat above using new rotation centre and new angle but acting on tillted origin and tilted dimension
    
    
    //MARK: ANGLES
    
    struct RequestOccupantAngleDictionary {
        var defaultOrModified: AngleDictionary = [:]
        
        init(
            parent: ObjectDefaultOrModifiedSpecification) {
            
                for id in parent.oneOrTwoIds {
                    setAngleDictionary( id)
                }
                
                
                func setAngleDictionary( _ id: Part) {
                let partForNames: [[Part]] =
                    [
                        [.bodySupportAngle, .stringLink, .sitOn, id],
                        [.backSupportReclineAngle, .stringLink, .sitOn, id],
                        [.legSupportAngle, .stringLink, .sitOn, id]
                    ]
                let defaultAngles =
                    [
                        OccupantBodySupportDefaultAngle(parent.baseType).value,
                        OccupantBackSupportDefaultAngle(parent.baseType).value,
                        OccupantFootSupportDefaultAngle(parent.baseType).value
                    ]
                var name: String
                var angle: Measurement<UnitAngle>
                for index in 0..<partForNames.count {
                    name =
                    CreateNameFromParts(partForNames[index]).name
                angle =
                    parent.modifiedAngleDictionary[name] ?? defaultAngles[index]
                defaultOrModified += [name: angle]
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
        var parentToPartDictionaryOut: PositionDictionary = [:]
        var objectToPartDictionaryOut: PositionDictionary = [:]
        
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
        
            objectToPartDictionaryOut = parentToPartDictionaryOut
                
                
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
                    let footSupportInOnePieceState = parent.objectOptionDictionaries[index][.footSupportInOnePiece] ?? false
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
                        self.parentToPartDictionaryOut[
                            CreateNameFromParts([
                                .object,
                                .id0,
                                .stringLink,
                                .sitOn,
                                ids[index],
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
    
    //MARK: ORIGIN FOR BODY ANGLE
    struct OccupanBodySupportRotationOriginDefaultOrModifiedDictionary {
        var parentToPart: PositionDictionary = [:]
        var objectToPart: PositionDictionary = [:]
        
        init(
            parent: ObjectDefaultOrModifiedSpecification) {
            let sitOnIds = parent.oneOrTwoIds
            
            for sitOnId in sitOnIds {
                let name =
                CreateNameFromParts(
                    [.sitOn, sitOnId, .stringLink, .bodySupportAngleJoint, .id0]
                ).name
                
                getDictionary(name, sitOnId)
            }
            

            func getDictionary(_ name: String, _ sitOnId: Part) {
                
                let sitOnOriginName =
                CreateNameFromParts([.object, .id0, .stringLink, .sitOn, sitOnId, .stringLink, .sitOn, sitOnId]).name
                
                let occupantBodySupportOrigin =
                    parent.objectToPartOriginDictionaryOut[sitOnOriginName]!
                
                let occupantBodySupportToDefaultAngleJointOrigin =
                    parent.modifiedOriginDictionary[sitOnOriginName] ??
                        OccupantBodySupportDefaultAngleJointOrigin(parent.baseType).value
                let objectToAngleJointOrigin =
                    CreateIosPosition.addTwoTouples(
                    occupantBodySupportOrigin,
                    occupantBodySupportToDefaultAngleJointOrigin)
                
                let objectToAngleJointOriginName =
                    CreateNameFromParts(
                        [.object,
                        .id0,
                        .stringLink,
                        .bodySupportAngleJoint,
                        .id0,
                        .stringLink,
                        .sitOn, sitOnId]).name
                
                objectToPart = [objectToAngleJointOriginName: objectToAngleJointOrigin]

            }
        }
    }
    
    
    //MARK: ORIGIN FOR FOOT
    struct OccupantFootSupportOriginDefaultOrModifiedDictionary {
        var parentToPart: PositionDictionary = [:]
        var objectToPart: PositionDictionary = [:]
       
        init(
            parent: ObjectDefaultOrModifiedSpecification) {
            
            getDictionary()
//print(objectToPartDictionaryOut)
            func getDictionary() {
                let twoIds: [Part] = [.id0, .id1]
                let sitOnIds = parent.oneOrTwoIds
                var parentChildPositions: [PositionAsIosAxes]
                
                for sitOnIndex in 0..<sitOnIds.count {
                    
                    let sitOnId = sitOnIds[sitOnIndex]
                   
                    let footPlateInOnePieceState =
                    parent.objectOptionDictionaries[sitOnIndex][.footSupportInOnePiece] ?? false
                    
                    for footSupportIndex in [1, 0] {
                        
                        parentChildPositions = []
                        
                        parentChildPositions.append(
                            GetValueFromDictionary(
                                parent.parentToPartOriginDictionaryOut,
                                [.object, .id0, .stringLink,.sitOn, sitOnId]).value )
                        
                        addToDictionary([
                            .sitOn,
                            sitOnId,
                            .stringLink,
                            .footSupportHangerSitOnVerticalJoint,
                            twoIds[footSupportIndex]],
                            SitOnToHangerVerticalJointDefaultOrigin(parent.baseType).value,
                            footSupportIndex)
                        
                        addToDictionary([
                            .footSupportHangerSitOnVerticalJoint,
                            sitOnId,
                            .stringLink,
                            .footSupportHorizontalJoint,
                            twoIds[footSupportIndex]],
                            HangerVerticalJointToFootSupportJointDefaultOrigin(parent.baseType).value,
                            footSupportIndex)
                        
                        
                        if footPlateInOnePieceState {

                            addToDictionary([
                                .footSupportHangerLink,
                                sitOnId,
                                .stringLink,
                                .footSupportHorizontalJoint,
                                .id0],
                                FootSupportJointToFootSupportInOnePieceDefaultOrigin(parent.baseType).value,
                                0)
                        } else {

                            addToDictionary([
                                .footSupportHorizontalJoint,
                                sitOnId,
                                .stringLink,
                                .footSupport,
                                twoIds[footSupportIndex]],
                                FootSupportJointToFootSupportInTwoPieceDefaultOrigin (parent.baseType).value,
                                footSupportIndex)
                        }
                        
                    }
                    
                    func addToDictionary(
                        _ parts: [Part],
                        _ defaultPosition: PositionAsIosAxes,
                        _ index: Int ){
                            
                        let name =
                            CreateNameFromParts(
                            parts).name


//print("parent child positions: \(parentChildPositions)")
//print("new part: \(name)")
//print("modified dictionary: \(parent.modifiedOriginDictionary)")
//print("default position of child from parent: \(defaultPosition)")
                        let defaultPositions =
                            CreateIosPosition.forLeftRightAsArrayFromPosition(
                            defaultPosition)

                        let positionOut =
                            parent.modifiedOriginDictionary[name] ??
                            defaultPositions[index]
//print("position out \(positionOut)")
                        self.parentToPart += [name : positionOut]
                        

                        parentChildPositions.append(positionOut)
//print("parent child positiions array: \(parentChildPositions)")
//print("")
//print("")
                        let objectName =
                                CreateNameFromParts(
                                    [.object, .id0] +
                                    Array(parts[2...3] + [twoIds[index], .stringLink, .sitOn, sitOnId])).name
                            
                        self.objectToPart +=
                            [objectName: CreateIosPosition.addArrayOfTouples(parentChildPositions)]
                            
                    }
                }
            }
        }
    }
}
