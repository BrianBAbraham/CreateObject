//
//  CreateDefaultDimensionDictionary.swift
//  CreateObject
//
//  Created by Brian Abraham on 02/06/2023.
//

import Foundation


struct DimensionDictionary {
    var forPart: Part3DimensionDictionary = [:]
    
    /// makes uses of dictionary value
    /// or uses passsed default value
    /// - Parameters:
    ///   - parts: all the parts associated with that section of the object
    ///   - defaultDimensions: default
    ///   - twinSitOnOptions:
    ///   - dimensionIn: may have no value, a default value or an edited value
    init(
        _ parts: [Part],
        _ defaultDimensions: [Dimension3d],
        _ twinSitOnOptions: TwinSitOnOptionDictionary,
        _ dimensionIn: Part3DimensionDictionary) {
            
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
                    let partName = CreateNameFromParts(x).name
                    let dimension = dimensionIn[partName] ?? defaultDimensions[index]
                    self.forPart +=
                    [partName: dimension ]
                }
            }
        }
    }
}


//struct ObjectDefaultDimension {
//    let dictionary: Part3DimensionDictionary
//    let modifiedPartDictionary: Part3DimensionDictionary
//    let modifiedOriginDictionary: PositionDictionary
//    let modifiedAngleDictionary: AngleDictionary
//
//    init(
//        _ baseType: BaseObjectTypes,
//        _ twinSitOnOptions: TwinSitOnOptionDictionary,
//        _ modifiedPartDictionary: Part3DimensionDictionary = [:],
//        _ modifiedOriginDictinary: PositionDictionary = [:],
//        _ modifiedAngleDictionary: AngleDictionary = [:]) {
//
//            self.modifiedPartDictionary = modifiedPartDictionary
//            self.modifiedOriginDictionary = modifiedOriginDictinary
//            self.modifiedAngleDictionary = modifiedAngleDictionary
//
//            dictionary =
//            createDefaultObjectDictionary(
//                baseType,
//                twinSitOnOptions)
//
//            func createDefaultObjectDictionary(
//                _ baseType: BaseObjectTypes,
//                _ twinSitOnOptions: TwinSitOnOptionDictionary)
//                -> Part3DimensionDictionary {
//                    var defaultDimensionDictionary =
//                            RequestOccupantBodySupportDefaultDimensionDictionary(
//                                baseType,
//                                twinSitOnOptions,
//                                modifiedPartDictionary).dictionary
//
//                        defaultDimensionDictionary +=
//                                RequestOccupantFootSupportDefaultDimensionDictionary(
//                                    baseType,
//                                    twinSitOnOptions,
//                                    modifiedPartDictionary).dictionary
//
//                         defaultDimensionDictionary +=
//                            RequestOccupantBackSupportDefaultDimensionDictionary(
//                                baseType, twinSitOnOptions).dictionary

//                        defaultDimensionDictionary +=
//                            RequestOccupantSideSupportDefaultDimensionDictionary(
//                                baseType,
//                                twinSitOnOptions,
//                                modifiedPartDictionary).dictionary
                    
//                    return defaultDimensionDictionary
//            }
//    }
//}




//struct ObjectDefaultOrigin {
//    let dictionary: PositionDictionary
//
//    init(
//        _ baseType: BaseObjectTypes,
//        _ twinSitOnOptions: TwinSitOnOptionDictionary) {
//
//            dictionary =
//                createDefaultOriginDictionary(
//                baseType,
//                twinSitOnOptions)
//
//            func createDefaultOriginDictionary(
//                _ baseType: BaseObjectTypes,
//                _ twinSitOnOptions: TwinSitOnOptionDictionary)
//            -> PositionDictionary{
//
//                return [:]
//            }
//        }
//}


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
struct ObjectDefaultOrEditedDictionaries {
    
    static let sitOnHeight = 500.0

    let preTiltDimensionIn: Part3DimensionDictionary
    var preTiltDimension: Part3DimensionDictionary = [:]
    
    
    var preTiltParentToPartOriginOut: PositionDictionary = [:]
    
    var preTiltObjectToPartOrigin: PositionDictionary = [:]
    var postTiltObjectToPartOrigin: PositionDictionary = [:]


    let preTiltObjectToPartOriginIn: PositionDictionary
    let preTiltParentToPartOriginIn: PositionDictionary
    
    let angleChangeIn: AngleDictionary
    var angleChangeDefault: AngleDictionary = [:]


    let baseType: BaseObjectTypes
    let twinSitOnOption: TwinSitOnOptionDictionary
    let objectOptions: [OptionDictionary]
    var twinSitOnState: Bool //= false
    let oneOrTwoIds: [Part]
    
    /// using values taken from dictionaries
    /// either passed in, which may be the result of UI edit,
    /// or if nil value provide default values
    /// and make the necessary changes to all dictionaries
    /// resulting from those values.  For example, if the UI
    /// alters an angle, all the values dependant on that angle
    /// are changed
    ///
    /// - Parameters:
    ///   - baseType: as Enum
    ///   - twinSitOnOption: dictionary as [Enum: Bool] indicating a configuration with two seats
    ///   - objectOptions: dictionary as [Enum: Bool] indicating options for object
    ///   - dimension: empty or default or modified dictionary of part as [String: Dimension3d]
    ///   - objectToPartOrigin: empty or default or modified dictionary as  [String: PositionAsIosAxes] indicating part origin
    ///   - parentToPartOrigin: empty or default or modified dictionary as  [String: PositionAsIosAxes] indicating part origin
    ///   - angleChange: empty or default or modified dictionary as [String: Measurement<UnitAngle>] indicating object configuration angles but not angles of parts which change during movement
    init(
        _ baseType: BaseObjectTypes,
        _ twinSitOnOption: TwinSitOnOptionDictionary,
        _ objectOptions: [OptionDictionary],
        _ dimension: Part3DimensionDictionary = [:],
        _ objectToPartOrigin: PositionDictionary = [:],
        _ parentToPartOrigin: PositionDictionary = [:],
        _ angleChangeIn: AngleDictionary = [:] ) {
            
        self.baseType = baseType//= .allCasterTiltInSpaceShowerChair
        self.twinSitOnOption = twinSitOnOption
        self.objectOptions = objectOptions
        self.preTiltDimensionIn = dimension
        self.preTiltObjectToPartOriginIn = objectToPartOrigin
        self.preTiltParentToPartOriginIn = parentToPartOrigin
        self.angleChangeIn = angleChangeIn
            
        twinSitOnState = TwinSitOn(twinSitOnOption).state
        
        oneOrTwoIds = twinSitOnState ? [.id0, .id1]: [.id0]
            

        createOccupantSupportDimensionDictionary()
        createOccupantSupportObjectToPartOriginDictionary()
            

DictionaryInArrayOut().getNameValue( preTiltDimension).forEach{print($0)}
            

//            for angle in [5.0, 10.0, 20.0, 30.0,40.0,50.0,60.0,90.0] {
//print(
//ObjectCorners (
//dimensionIn: OccupantBodySupportDefaultDimension(.allCasterBed).value,
//angleChange: Measurement(value: angle, unit: UnitAngle.degrees)).maximumLength
//)
           // }
//    print(
//        PositionOfPointAfterRotationAboutPoint(staticPoint: ZeroValue.iosLocation, movingPoint: (x: 0.0, y: 1000.0, z: 0.0), angleChange: Measurement(value: 90.0, unit: UnitAngle.degrees)).fromStaticToPointWhichHasMoved
//
//    )
            
        func createOccupantSupportDimensionDictionary() {
            let occupantSupportDimensionDictionary =
                OccupantSupportDimensionDictionary(parent: self)
                
            preTiltDimension += occupantSupportDimensionDictionary.forBack
            preTiltDimension += occupantSupportDimensionDictionary.forBody
            preTiltDimension += occupantSupportDimensionDictionary.forFoot
            preTiltDimension += occupantSupportDimensionDictionary.forSide
            
            
        }
            
       // Rotations are applied
        func createOccupantSupportObjectToPartOriginDictionary() {
            preTiltParentToPartOriginOut +=
            PreTiltOccupantBodySupportOrigin(parent: self).parentToPartDictionaryOut

            // parent to body support is identical to object to body support
            postTiltObjectToPartOrigin += preTiltParentToPartOriginOut
                
            let occupantFootSupportOrigin =
                PreTiltOccupantFootSupportOrigin(parent: self)
                
            preTiltParentToPartOriginOut +=
                occupantFootSupportOrigin.parentToPart
        
            postTiltObjectToPartOrigin +=
                occupantFootSupportOrigin.objectToPart
                
            angleChangeDefault =
                ObjectAngleChange(parent: self).dictionary

            postTiltObjectToPartOrigin +=
                //OccupanBodySupportRotationOrigin(parent: self).objectToPart
                OccupantSupportRotationOriginDictionary(parent: self, .bodySupportAngleJoint).objectToPartOut
     
            postTiltObjectToPartOrigin +=
                //OccupanBodySupportRotationOrigin(parent: self).objectToPart
                OccupantSupportRotationOriginDictionary(parent: self, .backSupportAngleJoint).objectToPartOut
            
            
            //replace the part origin positions which are rotated with the rotated values
            postTiltObjectToPartOrigin =
                Replace(
                    initial: postTiltObjectToPartOrigin,
                    replacement:
                            PositionAfterRotation(parent: self).forObjectToPartOrigin
                    ).intialWithReplacements
        }
    }
    
    
    
    //MARK: - ROTATION
    struct PositionAfterRotation {
        var forObjectToPartOrigin: PositionDictionary = [:]
        var forDimension: Part3DimensionDictionary = [:]

        init(
            parent: ObjectDefaultOrEditedDictionaries ) {
            for sitOnId in parent.oneOrTwoIds {
                let tiltOriginPart: [Part] =
                    [.object, .id0, .stringLink, .bodySupportAngleJoint, .id0, .stringLink, .sitOn, sitOnId]
                let originOfRotationName =
                    CreateNameFromParts(tiltOriginPart).name
                let angleName =
                    CreateNameFromParts([.bodySupportAngle, .stringLink, .sitOn, sitOnId]).name

                if let originOfRotation = parent.postTiltObjectToPartOrigin[originOfRotationName] {
                    let angleChange =
                        parent.angleChangeDefault[angleName] ??
                        ZeroValue.angle
                    
                    forSitOnWithFootTilt(
                        parent,
                        originOfRotation,
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
        
       mutating func forSitOnWithFootTilt (
            _ parent: ObjectDefaultOrEditedDictionaries,
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
                    
                    if let originOfPart = parent.postTiltObjectToPartOrigin[partName] {
                        
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
        
        mutating func forBackRecline (
             _ parent: ObjectDefaultOrEditedDictionaries,
             _ originOfRotation: PositionAsIosAxes,
             _ changeOfAngle: Measurement<UnitAngle>,
             _ sitOnId: Part) {
                 
             let allPartsSubjectToAngle = PartGroupsFor().backAndHead
             let partsOnLeftAndRight = PartGroupsFor().leftAndRight
             
             for part in  allPartsSubjectToAngle {
                 let partIds: [Part] =  partsOnLeftAndRight.contains(part) ? [.id0, .id1]: [.id0]
                 
                 for partId in partIds {
                     let partName =
                     CreateNameFromParts([
                         .object, .id0, .stringLink, part, partId, .stringLink, .sitOn, sitOnId]).name
                     
                     if let originOfPart = parent.postTiltObjectToPartOrigin[partName] {
                         
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
    
    /// Provides extant  passed in value or if not default
    /// of the change in angle from the neutral configuration
    struct ObjectAngleChange {
        var dictionary: AngleDictionary = [:]
        
        init(
            parent: ObjectDefaultOrEditedDictionaries) {
            
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
    
    //retrieves a passed value if extant else a default value
    struct OccupantSupportDimensionDictionary {
        var forBack:  Part3DimensionDictionary = [:]
        var forBody:  Part3DimensionDictionary = [:]
        var forFoot:  Part3DimensionDictionary = [:]
        var forSide: Part3DimensionDictionary = [:]
        
        init(
            parent: ObjectDefaultOrEditedDictionaries) {
            
            forBack = getDictionaryForBack()
            forBody = getDictionaryForBody()
            forFoot = getDictionaryForFoot()
            forSide = getDictionaryForSide()
                
            func  getDictionaryForBack()
            -> Part3DimensionDictionary {
                
                let allOccupantRelated =
                    AllOccupantBackRelated(
                        parent.baseType)
                
                return
                    DimensionDictionary(
                        allOccupantRelated.parts,
                        allOccupantRelated.dimensions,
                        parent.twinSitOnOption,
                        parent.preTiltDimensionIn
                    ).forPart
            }
                
            func  getDictionaryForBody()
                -> Part3DimensionDictionary {
                    let dimension =
                        OccupantBodySupportDefaultDimension(
                            parent.baseType).value
                    
                    let angle =
                        OccupantBodySupportDefaultAngleChange(parent.baseType).value
                    
                    let rotatedDimension =
                        ObjectCorners(
                            dimensionIn: dimension,
                            angleChangeIn:  angle
                        ).rotatedDimension
                    
                    let dimensions =
                        parent.twinSitOnState ? [rotatedDimension, rotatedDimension]: [rotatedDimension]
                    
                    let parts: [Part] =
                        parent.twinSitOnState ? [.sitOn, .sitOn]: [.sitOn]
                    
                    return
                        DimensionDictionary(
                            parts,
                            dimensions,
                            parent.twinSitOnOption,
                            parent.preTiltDimensionIn
                        ).forPart
            }
                
            func  getDictionaryForFoot()
                -> Part3DimensionDictionary {
                
                    let allOccupantRelated =
                        AllOccupantFootRelated(
                            parent.baseType,
                            parent.preTiltDimensionIn)
                    return
                        DimensionDictionary(
                            allOccupantRelated.parts,
                            allOccupantRelated.dimensions,
                            parent.twinSitOnOption,
                            parent.preTiltDimensionIn
                        ).forPart
            }
                
            func  getDictionaryForSide()
                -> Part3DimensionDictionary {
//                    let allOccupantRelated =
//                        OccupantSideSupportDefaultDimension(
//                            parent.baseType
//                    )
//
                    
                    let dimension =
                    PreTiltOccupantSideSupportDefaultDimension(
                        parent.baseType).value
                    let angle =
                    OccupantBodySupportDefaultAngleChange(parent.baseType).value
                    let rotatedDimension =
                    ObjectCorners(
                        dimensionIn: dimension,
                        angleChangeIn:  angle
                    ).rotatedDimension
                    
                   return
                        DimensionDictionary(
                            [.armSupport],
                            [rotatedDimension],
                            parent.twinSitOnOption,
                            parent.preTiltDimensionIn
                        ).forPart
            }
        }
    }
    
 

    
    //MARK: ORIGIN FOR BODY
    struct PreTiltOccupantBodySupportOrigin {
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
            parent: ObjectDefaultOrEditedDictionaries) {
        
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
                let modifiedDimension: Dimension3d? = parent.preTiltDimensionIn[name]
                return
                   modifiedDimension ?? bodySupportDefaultDimension
            }
              
                
            func getModifiedMaximumHangerLinkDimension(_ id: Part)
                -> Dimension3d {
                    let index = id == .id0 ? 0: 1
                    let footSupportInOnePieceState = parent.objectOptions[index][.footSupportInOnePiece] ?? false
                    let names: [String] =
                    [CreateNameFromParts([.footSupportHangerLink, .id0, .stringLink, .sitOn, id]).name]
                    var modifiedDimensions: [Dimension3d?] = [parent.preTiltDimensionIn[names[0]]]
                    
                    if footSupportInOnePieceState {
                        
                    } else {
                        let name =
                        CreateNameFromParts([.footSupportHangerLink, .id1, .stringLink, .sitOn, id]).name
                        modifiedDimensions += [parent.preTiltDimensionIn[name]]
                        
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
                     z: ObjectDefaultOrEditedDictionaries.sitOnHeight)
                )
                
                if frontAndRearState {
                    origin.append(
                            (x: 0.0,
                            y:
                                
                            stability.atRear +
                            occupantBodySupportsDimension[0].length +
                            occupantFootSupportHangerLinksDimension[0].length +
                            occupantBodySupportsDimension[1].length/2,
                             z: ObjectDefaultOrEditedDictionaries.sitOnHeight)
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
                     z: ObjectDefaultOrEditedDictionaries.sitOnHeight)
                    ]
                }
            }
                
            func forMidPrimaryOrigin(){
                let baseLength = frontAndRearState ?
                    distanceBetweenFrontAndRearWheels.ifFrontAndRearSitOn: distanceBetweenFrontAndRearWheels.ifNoFrontAndRearSitOn
                
                origin.append(
                (x: 0.0,
                 y: 0.5 * (baseLength - occupantBodySupportsDimension[0].length),
                 z: ObjectDefaultOrEditedDictionaries.sitOnHeight)
                )
                
                if frontAndRearState {
                    origin =
                    [
                    (x: 0.0,
                     y: -origin[0].y,
                     z: ObjectDefaultOrEditedDictionaries.sitOnHeight)
                     ,
                    (x: 0.0,
                     y: origin[0].y,
                    z: ObjectDefaultOrEditedDictionaries.sitOnHeight)
                    ]
                }
                
                if leftandRightState {
                    origin =
                    [
                    (x: 0.0,
                     y: -origin[0].y,
                     z: ObjectDefaultOrEditedDictionaries.sitOnHeight)
                     ,
                    (x: 0.0,
                     y: origin[0].y,
                    z: ObjectDefaultOrEditedDictionaries.sitOnHeight)
                    ]
                }
            }
                
            func forFrontPrimaryOrgin() {
                origin.append(
                    (x: 0.0,
                     y:
                    -(stability.atFront +
                        occupantBodySupportsDimension[0].length/2),
                     z: ObjectDefaultOrEditedDictionaries.sitOnHeight )
                     )
                
                if frontAndRearState {
                    origin = [
                        (x: 0.0,
                         y:
                            -stability.atFront -
                            occupantBodySupportsDimension[0].length -
                            occupantFootSupportHangerLinksDimension[1].length -
                            occupantBodySupportsDimension[1].length/2,
                         z: ObjectDefaultOrEditedDictionaries.sitOnHeight
                         ),
                        origin[0]
                    ]
                }
                
                if leftandRightState {
                    origin = [
                        (x: -leftAndRightX(),
                         y: origin[0].y,
                         z: ObjectDefaultOrEditedDictionaries.sitOnHeight),
                        (x: leftAndRightX(),
                         y: origin[0].y,
                         z: ObjectDefaultOrEditedDictionaries.sitOnHeight)
                    ]
                }
            }
                
                func leftAndRightX ()
                    -> Double {
                        (occupantBodySupportsDimension[0].width + occupantBodySupportsDimension[1].width)/2 +
                        PreTiltOccupantSideSupportDefaultDimension(parent.baseType//, parent.modifiedPartDictionary
                        ).value.width
                }
        }
    }
    
    //MARK: BODY ROTATION ORIGIN

    
    /// Provides a dictionary of object-view of joint origins
    /// about which parts are rotated
    struct OccupantSupportRotationOriginDictionary {
        var objectToPartOut: PositionDictionary = [:]
        let angleJoint: Part

        init(
            parent: ObjectDefaultOrEditedDictionaries,
            _ angleJoint: Part) {
            
            self.angleJoint = angleJoint

            let sitOnIds = parent.oneOrTwoIds
              
            for sitOnId in sitOnIds {
                let angleJointName =
                    CreateNameFromParts(
                        [.sitOn, sitOnId, .stringLink, angleJoint, .id0]
                    ).name
                
                let sitOnOriginName =
                    CreateNameFromParts([.object, .id0, .stringLink, .sitOn, sitOnId, .stringLink, .sitOn, sitOnId]).name
                let occupantBodySupportOrigin =
                    parent.postTiltObjectToPartOrigin[sitOnOriginName]!
                
                switch angleJoint {
                   
                    case .backSupportAngleJoint:
                        calculateAndAddObjectToRotationJointWhichHaveSitOnParentIntoDictionary (
                            .backSupportAngleJoint,
                            OccupantBackSupportDefaultParentToRotationOrigin(parent.baseType).value)
                    
                    
                    case .bodySupportAngleJoint:
                        calculateAndAddObjectToRotationJointWhichHaveSitOnParentIntoDictionary (
                            .bodySupportAngleJoint,
                            OccupantBodySupportDefaultParentToRotationOrigin(parent.baseType).value
                        )
                    
    //                case .backSupportHeadLinkJoint:
    //                    parentToRotationOriginName =
    //                        createNameForParentToRotationJoint(.backSupport, .backSupportHeadLinkJoint)
    //
    //                    parentToRotationOrigin =
    //                        parent.parentToPartOriginIn[parentToRotationOriginName] ??
    //                        OccupantBodySupportDefaultParentToRotationOrigin(parent.baseType).value
                        
                    default: break
                }
                
                
                func calculateAndAddObjectToRotationJointWhichHaveSitOnParentIntoDictionary(
                    _ rotationJoint: Part, _ defaultPosition: PositionAsIosAxes) {
                    let parentToRotationOriginName =
                            createNameForParentToRotationJoint(.sitOn, rotationJoint)
                    let parentToRotationOrigin =
                        parent.preTiltParentToPartOriginIn[parentToRotationOriginName] ??
                        defaultPosition
                    let objectToRotationOrigin =
                        CreateIosPosition.addTwoTouples(
                        occupantBodySupportOrigin,
                        parentToRotationOrigin)
                    let objectToRotationOriginName =
                        createNameForObjectToRotationJoint(.sitOn, .bodySupportAngleJoint)
                    objectToPartOut += [objectToRotationOriginName: objectToRotationOrigin]
                }
                
                
                func createNameForParentToRotationJoint(_ parent: Part, _ joint: Part)
                -> String {
                    let startOfOriginName =  CreateNameFromParts([parent, sitOnId, .stringLink]).name
                    let endOfOriginName =  CreateNameFromParts([ .id0, .stringLink, .sitOn, sitOnId]).name
                    return
                        startOfOriginName + joint.rawValue + endOfOriginName
                }

                
                func createNameForObjectToRotationJoint(_ parent: Part, _ joint: Part)
                -> String {
                    return
                        CreateNameFromParts(
                            [.object,
                            .id0,
                            .stringLink,
                            angleJoint,
                            .id0,
                            .stringLink,
                            .sitOn, sitOnId]).name
                }
            }
        }
    }
    
    
    //MARK: ORIGIN FOR FOOT
    struct PreTiltOccupantFootSupportOrigin {
        var parentToPart: PositionDictionary = [:]
        var objectToPart: PositionDictionary = [:]
       
        init(
            parent: ObjectDefaultOrEditedDictionaries) {
            
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
                                parent.preTiltParentToPartOriginOut,
                                [.object, .id0, .stringLink,.sitOn, sitOnId]).value )
                        
                        addToDictionary([
                            .sitOn,
                            sitOnId,
                            .stringLink,
                            .footSupportHangerSitOnVerticalJoint,
                            twoIds[footSupportIndex]],
                            PreTiltSitOnToHangerVerticalJointDefaultOrigin(parent.baseType).value,
                            footSupportIndex)
                        
                        addToDictionary([
                            .footSupportHangerSitOnVerticalJoint,
                            sitOnId,
                            .stringLink,
                            .footSupportHorizontalJoint,
                            twoIds[footSupportIndex]],
                            PreTiltHangerVerticalJointToFootSupportJointDefaultOrigin(parent.baseType).value,
                            footSupportIndex)
                        
                        
                        if footPlateInOnePieceState {

                            addToDictionary([
                                .footSupportHangerLink,
                                sitOnId,
                                .stringLink,
                                .footSupportHorizontalJoint,
                                .id0],
                                PreTiltFootSupportJointToFootSupportInOnePieceDefaultOrigin(parent.baseType).value,
                                0)
                        } else {

                            addToDictionary([
                                .footSupportHorizontalJoint,
                                sitOnId,
                                .stringLink,
                                .footSupport,
                                twoIds[footSupportIndex]],
                                PreTiltFootSupportJointToFootSupportInTwoPieceDefaultOrigin (parent.baseType).value,
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
                            parent.preTiltObjectToPartOriginIn[name] ??
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


/// Provide all eight corner positions for part
/// Rotate about x axis left to rigth on screen
/// Provide maximum y length resulting from rotation
struct ObjectCorners {
    let dimensionIn: Dimension3d
    let angleChangeIn: Measurement<UnitAngle>
    var are: [PositionAsIosAxes] {
        calculateFrom(dimension: dimensionIn) }
    var aferRotationAre: [PositionAsIosAxes] {
        calculatePositionAfterRotation(are, angleChangeIn)
    }
    var maximumLengthAfterRotationAboutX: Double {
        calculateMaximumLength(aferRotationAre)
    }
    var rotatedDimension: Dimension3d {
        (
        length: maximumLengthAfterRotationAboutX,
        width: dimensionIn.width,
        height: dimensionIn.height)
    }
    

    func calculateFrom( dimension: Dimension3d)
    -> [PositionAsIosAxes] {
        let (l,w,h) = dimension
        return
            [
            ZeroValue.iosLocation,
            (x: w,      y: 0.0, z: 0.0 ),
            (x: w,      y: l,   z: 0.0 ),
            (x: 0.0,    y: l,   z: 0.0),
            (x: 0.0,    y: 0.0, z: h),
            (x: w,      y: 0.0, z: h),
            (x: w,      y: l,   z: h ),
            (x: 0.0,    y: l,   z: h )
            ]
    }
    
    func calculatePositionAfterRotation(
        _ corners: [PositionAsIosAxes],
        _ angleChange: Measurement<UnitAngle>)
        -> [PositionAsIosAxes] {
        var rotatedCorners: [PositionAsIosAxes] = []
        
        let useAnyIndexForRotation = 0
        for corner in corners {
            rotatedCorners.append(
                PositionOfPointAfterRotationAboutPoint(
                    staticPoint: corners[useAnyIndexForRotation],
                    movingPoint: corner,
                    angleChange: angleChange).fromStaticToPointWhichHasMoved )
        }
//print(rotatedCorners)
        return rotatedCorners
    }
    
    func calculateMaximumLength(
        _ corners: [PositionAsIosAxes])
        -> Double {
        let yValues =
            CreateIosPosition.getArrayFromPositions(corners).y
        return
            yValues.max()! - yValues.min()!
    }
}
