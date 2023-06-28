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
        _ twinSitOnOptions: TwinSitOnOptionDictionary) {
            
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
        _ twinSitOnOptions: TwinSitOnOptionDictionary,
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
                _ twinSitOnOptions: TwinSitOnOptionDictionary)
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
        _ twinSitOnOptions: TwinSitOnOptionDictionary) {
            
            dictionary =
                createDefaultOriginDictionary(
                baseType,
                twinSitOnOptions)
            
            func createDefaultOriginDictionary(
                _ baseType: BaseObjectTypes,
                _ twinSitOnOptions: TwinSitOnOptionDictionary)
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

//MARK: - PARENT
//
struct ObjectDefaultOrModifiedDictionaries {
    
    static let sitOnHeight = 500.0
    var dimensionDefault: Part3DimensionDictionary = [:]
    var parentToPartOriginDefault: PositionDictionary = [:]
    var objectToPartOriginDefault: PositionDictionary = [:]
    var angleChangeDefault: AngleDictionary = [:]
    let dimensionIn: Part3DimensionDictionary
    let objectToPartOriginIn: PositionDictionary
    var objectToPartOriginOut: PositionDictionary = [:]
    let angleChangeIn: AngleDictionary
    let baseType: BaseObjectTypes
    let twinSitOnOption: TwinSitOnOptionDictionary
    let objectOptions: [OptionDictionary]
    var twinSitOnState: Bool //= false
    let oneOrTwoIds: [Part]
    
    /// provide default dictionaries or provide dictionaries which are edited in accordance with an UI edited inputted dictionary
    ///
    /// - Parameters:
    ///   - baseType: as Enum
    ///   - twinSitOnOption: dictionary as [Enum: Bool] indicating a configuration with two seats
    ///   - objectOptions: dictionary as [Enum: Bool] indicating options for object
    ///   - dimension: empty or default or modified dictionary of part as [String: Dimension3d]
    ///   - objectToPartOrigin: empty or default or modified dictionary as  [String: PositionAsIosAxes] indicating part origin
    ///   - angleChange: empty or default or modified dictionary as [String: Measurement<UnitAngle>] indicating object configuration angles but not angles of parts which change during movement
    init(
        _ baseType: BaseObjectTypes,
        _ twinSitOnOption: TwinSitOnOptionDictionary,
        _ objectOptions: [OptionDictionary],
        _ dimension: Part3DimensionDictionary = [:],
        _ objectToPartOrigin: PositionDictionary = [:],
        _ angleChange: AngleDictionary = [:] ) {
            
        self.baseType = baseType
        self.twinSitOnOption = twinSitOnOption
        self.objectOptions = objectOptions
        self.dimensionIn = dimension
        self.objectToPartOriginIn = objectToPartOrigin
        self.angleChangeIn = angleChange
            
        twinSitOnState = TwinSitOn(twinSitOnOption).state
        
        oneOrTwoIds = twinSitOnState ? [.id0, .id1]: [.id0]
            
        dimensionDefault +=
        OccupantBodySupportDimension(parent: self).dictionaryOut
        dimensionDefault +=
        OccupantBackSupportDimension(parent: self).dictionaryOut
        dimensionDefault +=
        OccupantFootSupportDimension(parent: self).dictionaryOut
        dimensionDefault +=
        OccupantSideSupportDimension(parent: self).dictionaryOut
        
        parentToPartOriginDefault +=
        OccupantBodySupportOrigin(parent: self).parentToPartDictionaryOut

        // parent to body support is identical to object to body support
        objectToPartOriginDefault += parentToPartOriginDefault
            
        let occupantFootSupportOrigin =
            OccupantFootSupportOrigin(parent: self)
            
        parentToPartOriginDefault +=
            occupantFootSupportOrigin.parentToPart
    
        objectToPartOriginDefault +=
            occupantFootSupportOrigin.objectToPart
            
        angleChangeDefault =
            ObjectAngleChange(parent: self).dictionary

        objectToPartOriginDefault +=
            OccupanBodySupportRotationOrigin(parent: self).objectToPart
 
        //replace the parts values which are rotated with the rotated values
        objectToPartOriginOut =
            Replace(initial: objectToPartOriginDefault,
                    replacement:
                        PositionAfterRotation(parent: self).forObjectToPartOrigin
                ).intialWithReplacements

            
//print("ROTATED")
//DictionaryInArrayOut().getNameValue(objectToPartOriginOut).forEach{print($0)}

            
        }
    
    
    
    //MARK: - ROTATION
    struct PositionAfterRotation {
        var forObjectToPartOrigin: PositionDictionary = [:]
        var forDimension: Part3DimensionDictionary = [:]

        init(
            parent: ObjectDefaultOrModifiedDictionaries ) {
            for sitOnId in parent.oneOrTwoIds {
                let tiltOriginPart: [Part] =
                    [.object, .id0, .stringLink, .bodySupportAngleJoint, .id0, .stringLink, .sitOn, sitOnId]
                let tiltOriginName =
                    CreateNameFromParts(tiltOriginPart).name
                let angleName =
                    CreateNameFromParts([.bodySupportAngle, .stringLink, .sitOn, sitOnId]).name

                if let tiltOrigin = parent.objectToPartOriginDefault[tiltOriginName] {
                    let angleChange =
                        parent.angleChangeDefault[angleName] ??
                        ZeroValue.angle
                    
                    forSitOnTilt(
                        parent,
                        tiltOrigin,
                        angleChange,
                        sitOnId)
                    }
                }
            }
       /*
        all parts attached to the body support are rotated
        about the Ios x axis
        but the angle of rotation is zero
        unless the option dictionary permits the UI to set a
        non-zero angle in angleChangeIn
        or an object has a non-zero angle
        set in angleChangeDefault
        if an object with only some parts attached
        to the body support are to be rotated then additional code
        which checks the base type can be added
        */
        
       mutating func forSitOnTilt (
            _ parent: ObjectDefaultOrModifiedDictionaries,
            _ originOfRotation: PositionAsIosAxes,
            _ changeOfAngle: Measurement<UnitAngle>,
            _ sitOnId: Part) {
                
            let allPartsSubjectToAngle = PartGroupsFor().allAngle
            let partsOnLeftAndRight = PartGroupsFor().leftAndRight
            
            for part in  allPartsSubjectToAngle {
                let partIds: [Part] =  partsOnLeftAndRight.contains(part) ? [.id0, .id1]: [.id0]
                
                for partId in partIds {
                    let partName =
                    CreateNameFromParts([
                        .object, .id0, .stringLink, part, partId, .stringLink, .sitOn, sitOnId]).name
                    
                    if let originOfPart = parent.objectToPartOriginDefault[partName] {
                        
                        let newPosition =
                        PositionOfPointAfterRotationAboutPoint(
                            staticPoint: originOfRotation,
                            movingPoint: originOfPart,
                            angleChange: changeOfAngle).fromObjectOriginToPointWhichHasMoved
                        
                        forObjectToPartOrigin += [partName: newPosition]
                    }
                }
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
    
    
    //MARK: ANGLES
    
    struct ObjectAngleChange {
        var dictionary: AngleDictionary = [:]
        
        init(
            parent: ObjectDefaultOrModifiedDictionaries) {
            
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
                        OccupantBodySupportDefaultAngleChange(parent.baseType).value,
                        OccupantBackSupportDefaultAngleChange(parent.baseType).value,
                        OccupantFootSupportDefaultAngleChange(parent.baseType).value
                    ]
                var name: String
                var angle: Measurement<UnitAngle>
                for index in 0..<partForNames.count {
                    name =
                        CreateNameFromParts(partForNames[index]).name
                    angle =
                        parent.angleChangeIn[name] ?? defaultAngles[index]
                    dictionary += [name: angle]
                }
            }
        }
    }
    
    
    //MARK: DIMENSION FOR BACK
    struct OccupantBackSupportDimension {
        var dictionaryOut: Part3DimensionDictionary = [:]
       
        init(
            parent: ObjectDefaultOrModifiedDictionaries) {
            
            getDictionary()
            
            func getDictionary() {
                    
                let allOccupantRelated =
                    AllOccupantBackRelated(
                        parent.baseType)
                dictionaryOut =
                    CreateDefaultDimensionDictionary(
                        allOccupantRelated.parts,
                        allOccupantRelated.dimensions,
                        parent.twinSitOnOption
                    ).dictionary
            }
        }
    }
    
    
    //MARK: DIMENSION FOR BODY
    struct OccupantBodySupportDimension {
        var dictionaryOut: Part3DimensionDictionary = [:]
        
        init(
            parent: ObjectDefaultOrModifiedDictionaries) {
                
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
                        parent.twinSitOnOption
                    ).dictionary
            }
        }
    }
    
    
    //MARK: DIMENSION FOR FOOT
    struct OccupantFootSupportDimension {
        var dictionaryOut: Part3DimensionDictionary = [:]
       
        init(
            parent: ObjectDefaultOrModifiedDictionaries) {
            
            getDictionary()
            
            func getDictionary() {
                    
                let allOccupantRelated =
                    AllOccupantFootRelated(
                        parent.baseType,
                        parent.dimensionIn)
                dictionaryOut =
                    CreateDefaultDimensionDictionary(
                        allOccupantRelated.parts,
                        allOccupantRelated.dimensions,
                        parent.twinSitOnOption
                    ).dictionary
            }
        }
    }
    
    
    //MARK: DIMENSION FOR SIDE
    struct OccupantSideSupportDimension {
        var dictionaryOut: Part3DimensionDictionary = [:]
       
        init(
            parent: ObjectDefaultOrModifiedDictionaries) {
            
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
                        parent.twinSitOnOption
                    ).dictionary
            }
        }
    }

    
    //MARK: ORIGIN FOR BODY
    struct OccupantBodySupportOrigin {
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
            parent: ObjectDefaultOrModifiedDictionaries) {
        
            stability = Stability(parent.baseType)
            
            frontAndRearState = parent.twinSitOnOption[.frontAndRear] ?? false
            leftandRightState = parent.twinSitOnOption[.leftAndRight] ?? false
  
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
                let modifiedDimension: Dimension3d? = parent.dimensionIn[name]
                return
                   modifiedDimension ?? bodySupportDefaultDimension
            }
              
                
            func getModifiedMaximumHangerLinkDimension(_ id: Part)
                -> Dimension3d {
                    let index = id == .id0 ? 0: 1
                    let footSupportInOnePieceState = parent.objectOptions[index][.footSupportInOnePiece] ?? false
                    let names: [String] =
                    [CreateNameFromParts([.footSupportHangerLink, .id0, .stringLink, .sitOn, id]).name]
                    var modifiedDimensions: [Dimension3d?] = [parent.dimensionIn[names[0]]]
                    
                    if footSupportInOnePieceState {
                        
                    } else {
                        let name =
                        CreateNameFromParts([.footSupportHangerLink, .id1, .stringLink, .sitOn, id]).name
                        modifiedDimensions += [parent.dimensionIn[name]]
                        
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
                     z: ObjectDefaultOrModifiedDictionaries.sitOnHeight)
                )
                
                if frontAndRearState {
                    origin.append(
                            (x: 0.0,
                            y:
                                
                            stability.atRear +
                            occupantBodySupportsDimension[0].length +
                            occupantFootSupportHangerLinksDimension[0].length +
                            occupantBodySupportsDimension[1].length/2,
                             z: ObjectDefaultOrModifiedDictionaries.sitOnHeight)
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
                     z: ObjectDefaultOrModifiedDictionaries.sitOnHeight)
                    ]
                }
            }
                
            func forMidPrimaryOrigin(){
                let baseLength = frontAndRearState ?
                    distanceBetweenFrontAndRearWheels.ifFrontAndRearSitOn: distanceBetweenFrontAndRearWheels.ifNoFrontAndRearSitOn
                
                origin.append(
                (x: 0.0,
                 y: 0.5 * (baseLength - occupantBodySupportsDimension[0].length),
                 z: ObjectDefaultOrModifiedDictionaries.sitOnHeight)
                )
                
                if frontAndRearState {
                    origin =
                    [
                    (x: 0.0,
                     y: -origin[0].y,
                     z: ObjectDefaultOrModifiedDictionaries.sitOnHeight)
                     ,
                    (x: 0.0,
                     y: origin[0].y,
                    z: ObjectDefaultOrModifiedDictionaries.sitOnHeight)
                    ]
                }
                
                if leftandRightState {
                    origin =
                    [
                    (x: 0.0,
                     y: -origin[0].y,
                     z: ObjectDefaultOrModifiedDictionaries.sitOnHeight)
                     ,
                    (x: 0.0,
                     y: origin[0].y,
                    z: ObjectDefaultOrModifiedDictionaries.sitOnHeight)
                    ]
                }
            }
                
            func forFrontPrimaryOrgin() {
                origin.append(
                    (x: 0.0,
                     y:
                    -(stability.atFront +
                        occupantBodySupportsDimension[0].length/2),
                     z: ObjectDefaultOrModifiedDictionaries.sitOnHeight )
                     )
                
                if frontAndRearState {
                    origin = [
                        (x: 0.0,
                         y:
                            -stability.atFront -
                            occupantBodySupportsDimension[0].length -
                            occupantFootSupportHangerLinksDimension[1].length -
                            occupantBodySupportsDimension[1].length/2,
                         z: ObjectDefaultOrModifiedDictionaries.sitOnHeight
                         ),
                        origin[0]
                    ]
                }
                
                if leftandRightState {
                    origin = [
                        (x: -leftAndRightX(),
                         y: origin[0].y,
                         z: ObjectDefaultOrModifiedDictionaries.sitOnHeight),
                        (x: leftAndRightX(),
                         y: origin[0].y,
                         z: ObjectDefaultOrModifiedDictionaries.sitOnHeight)
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
    
    //MARK: BODY ROTATION ORIGIN
    struct OccupanBodySupportRotationOrigin {
        var parentToPart: PositionDictionary = [:]
        var objectToPart: PositionDictionary = [:]
        
        init(
            parent: ObjectDefaultOrModifiedDictionaries) {
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
                    parent.objectToPartOriginDefault[sitOnOriginName]!
                
                let occupantBodySupportParentToRotationOrigin =
                    parent.objectToPartOriginIn[sitOnOriginName] ??
                        OccupantBodySupportDefaultParentToRotationOrigin(parent.baseType).value
                let objectToAngleJointOrigin =
                    CreateIosPosition.addTwoTouples(
                    occupantBodySupportOrigin,
                    occupantBodySupportParentToRotationOrigin)
                
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
    struct OccupantFootSupportOrigin {
        var parentToPart: PositionDictionary = [:]
        var objectToPart: PositionDictionary = [:]
       
        init(
            parent: ObjectDefaultOrModifiedDictionaries) {
            
            getDictionary()
//print(objectToPartDictionaryOut)
            func getDictionary() {
                let twoIds: [Part] = [.id0, .id1]
                let sitOnIds = parent.oneOrTwoIds
                var parentChildPositions: [PositionAsIosAxes]
                
                for sitOnIndex in 0..<sitOnIds.count {
                    
                    let sitOnId = sitOnIds[sitOnIndex]
                   
                    let footPlateInOnePieceState =
                    parent.objectOptions[sitOnIndex][.footSupportInOnePiece] ?? false
                    
                    for footSupportIndex in [1, 0] {
                        
                        parentChildPositions = []
                        
                        parentChildPositions.append(
                            GetValueFromDictionary(
                                parent.parentToPartOriginDefault,
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
                        _ defaultParentToPartOriginPosition: PositionAsIosAxes,
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
                            defaultParentToPartOriginPosition)

                        let positionOut =
                            parent.objectToPartOriginIn[name] ??
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
