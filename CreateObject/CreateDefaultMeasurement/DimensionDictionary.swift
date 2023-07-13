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
                    let nameStart: [Part] = [.object, .id0, .stringLink]
                    let nameEnd: [Part] = parts[index] == .sitOn ?
                    [sitOnId, .stringLink, .sitOn, .id0] : [partId, .stringLink, .sitOn, sitOnId]
                    let x = nameStart + [parts[index]] + nameEnd
                    let partName = CreateNameFromParts(x).name
                    let dimension = dimensionIn[partName] ?? defaultDimensions[index]
                    self.forPart +=
                    [partName: dimension ]
                }
            }
        }
    }
}



//MARK: - PARENT
//
struct ObjectDefaultOrEditedDictionaries {
    
    static let sitOnHeight = 500.0

    let preTiltDimensionIn: Part3DimensionDictionary
    var postTiltDimension: Part3DimensionDictionary = [:]
    
    var preTiltParentToPartOrigin: PositionDictionary = [:]
    
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
    ///   - objectOptions: dictionary as [Enum: Bool] indicating options for object one per sitOn
    ///   - preTiltDimension: empty or default or modified dictionary of part  UI does produce postTilttDimesnsion it supplies angle
    ///   - objectToPartOrigin: empty or default or modified dictionary as  [String: PositionAsIosAxes] indicating part origin, preTilt
    ///   - parentToPartOrigin: empty or default or modified dictionary as  [String: PositionAsIosAxes] indicating part origin, preTilt
    ///   - angleChange: empty or default or modified dictionary as [String: Measurement<UnitAngle>] indicating object configuration angles but not angles of parts which change during movement: sitOn tilt but not caster orientation
    init(
        _ baseType: BaseObjectTypes,
        _ twinSitOnOption: TwinSitOnOptionDictionary,
        _ objectOptions: [OptionDictionary],
        _ preTiltDimension: Part3DimensionDictionary = [:],
        _ objectToPartOrigin: PositionDictionary = [:],
        _ parentToPartOrigin: PositionDictionary = [:],
        _ angleChangeIn: AngleDictionary = [:] ) {
            
        self.baseType = baseType
        self.twinSitOnOption = twinSitOnOption
        self.objectOptions = objectOptions
        self.preTiltDimensionIn = preTiltDimension
        self.preTiltObjectToPartOriginIn = objectToPartOrigin
        self.preTiltParentToPartOriginIn = parentToPartOrigin
        self.angleChangeIn = angleChangeIn
            
        twinSitOnState = TwinSitOn(twinSitOnOption).state
        
        oneOrTwoIds = twinSitOnState ? [.id0, .id1]: [.id0]
            
        createOccupantSupportPostTiltDimensionDictionary()
            
        createPreTiltObjectToPartOriginDictionary()
             
        angleChangeDefault =
            ObjectAngleChange(parent: self).dictionary
        
        creatPostTiltObjectToPartOriginDictionary()

            
DictionaryInArrayOut().getNameValue( postTiltObjectToPartOrigin).forEach{print($0)}
//DictionaryInArrayOut().getNameValue( postTiltDimension).forEach{print($0)}
//print("")
        createCornerDictionary()
            
        // Rotations are applied
        func createOccupantSupportPostTiltDimensionDictionary() {
            let occupantSupportDimensionDictionary =
                OccupantSupportPostTiltDimensionDictionary(parent: self)
            postTiltDimension += occupantSupportDimensionDictionary.forBack
            postTiltDimension += occupantSupportDimensionDictionary.forBody
            postTiltDimension += occupantSupportDimensionDictionary.forFoot
            postTiltDimension += occupantSupportDimensionDictionary.forSide
        }
            
  
        func createPreTiltObjectToPartOriginDictionary() {
            
            //this must be assigned here and not in the array
            //for the array elements to access the property
            //in the struct
            preTiltObjectToPartOrigin +=
                PreTiltOccupantBodySupportOrigin(parent: self).objectToPartDictionary
            
            
            let preTilt: [PreTiltOrigin] =
                [
                PreTiltOccupantSupportOrigin(parent: self),
                ]
              
            for element in preTilt {
                preTiltObjectToPartOrigin +=
                    element.objectToPartDictionary
            }
        }
            
            
        func creatPostTiltObjectToPartOriginDictionary() {
            //replace the part origin positions which are rotated with the rotated values
            postTiltObjectToPartOrigin +=
            Replace(
                initial:
                    preTiltObjectToPartOrigin,
                replacement:
                    OriginPostTilt(parent: self).forObjectToPartOrigin
                ).intialWithReplacements
        }
        
            
            /// corners c0...c7 of a cuboid are located as follows
            /// they are viewed as per IOS axes facing the screen
            /// c0...c3 are z = 0 in the UI
            /// c4..c7 are z = 1 in the UI
            /// c0 top left,,
            /// c1 top right,
            /// c2 bottom left,
            /// c3 bottom left
            /// repeat for c4...c7
        func createCornerDictionary(){
            
            let noJointPostTiltOrigin = postTiltObjectToPartOrigin.filter({!$0.key.contains("Joint")})
            
            for (key, _) in noJointPostTiltOrigin {
                let O = noJointPostTiltOrigin[key]!
                let D = postTiltDimension[key] ?? ZeroValue.dimension3D

                let hD = HalfThis(D).dimension
                let c0 = (x: O.x - hD.width, y: O.y - hD.length, z: O.z - hD.height)
                let c1 = (x: O.x + hD.width, y: O.y - hD.length, z: O.z - hD.height)
                let c2 = (x: O.x + hD.width, y: O.y + hD.length, z: O.z - hD.height)
                let c3 = (x: O.x - hD.width, y: O.y + hD.length, z: O.z - hD.height)
                let c4 = (x: O.x - hD.width, y: O.y - hD.length, z: O.z + hD.height)
                let c5 = (x: O.x + hD.width, y: O.y - hD.length, z: O.z + hD.height)
                let c6 = (x: O.x + hD.width, y: O.y + hD.length, z: O.z + hD.height)
                let c7 = (x: O.x - hD.width, y: O.y + hD.length, z: O.z + hD.height)
                let corners =
                    [ c0,c1,c2,c3,c4,c5,c6,c7]
//print(key)
//print(corners)
            }
            
            /// given tilted dimensions and origins create the eight corners
            /// extract x-y or y-z or x-z corners
            ///
        }
            
    }
    
    
    
    //MARK: ORIGIN POST TILT
    struct OriginPostTilt {
        var forObjectToPartOrigin: PositionDictionary = [:]
        var forDimension: Part3DimensionDictionary = [:]

        init(
            parent: ObjectDefaultOrEditedDictionaries ) {
            for sitOnId in parent.oneOrTwoIds {
                let tiltOriginPart: [Part] =
                    [.object, .id0, .stringLink, .bodySupportRotationJoint, .id0, .stringLink, .sitOn, sitOnId]
                let originOfRotationName =
                    CreateNameFromParts(tiltOriginPart).name
                let angleName =
                    CreateNameFromParts([.bodySupportAngle, .stringLink, .sitOn, sitOnId]).name

                if let originOfRotation = parent.preTiltObjectToPartOrigin[originOfRotationName] {
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
                    
                    if let originOfPart = parent.preTiltObjectToPartOrigin[partName] {
                        
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
        
        // MARK: write code
        mutating func forSitOnWithoutFootTilt() {}
        
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
                     
                     if let originOfPart = parent.preTiltObjectToPartOrigin[partName] {
                         
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
        
        // MARK: write code
        mutating func forHeadSupport(){}
    }
    
    
    
    
    
    
    
    
    /// rules if parent is object if contains
    /// rules if parent is sitOn if contains  sitOn_id0_n
    /// rules if parent is backSupport
    /// tilt: get  part centre from rotation centtre and transfrom origin and transform part  dimension then sum transformed origin and transformed dimension for viewed size in plane
    ///  get % + child from parent and transform
    ///  repeat for each child
    ///  recline:  repeat above using new rotation centre and new angle but acting on tillted origin and tilted dimension
    
    
    //MARK: SET ANGLES
    
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
    struct OccupantSupportPostTiltDimensionDictionary {
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
                        PreTiltOccupantBodySupportDefaultDimension(
                            parent.baseType).value
                    
                    let angle =
                        OccupantBodySupportDefaultAngleChange(parent.baseType).value
                    
                    let rotatedDimension =
                        ObjectCorners(
                            dimensionIn: dimension,
                            angleChangeIn:  angle
                        ).rotatedDimension
                    
//print(parent.baseType.rawValue)
//print(rotatedDimension)
//print("")
                    
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
    
 

    
    //MARK: BODY SUPPORT ORIGIN
    /// The ability to add two seats side by side or back to front
    /// commbined with the the different object origins with respect
    /// to the body support, for example, front drive v rear drive
    /// requires the following considerable logic
    struct PreTiltOccupantBodySupportOrigin: PreTiltOrigin {
        var parentToPartDictionary: PositionDictionary = [:]
        var objectToPartDictionary: PositionDictionary = [:]
        
        let stability: Stability
        var origin: [PositionAsIosAxes] = []
        let frontAndRearState: Bool
        let leftandRightState: Bool

        var occupantBodySupportsDimension: [Dimension3d] = []
        var occupantSideSupportsDimension: [[Dimension3d]] = []
        
        var occupantFootSupportHangerLinksDimension: [Dimension3d] = []
        let lengthBetweenWheels: LengthBetween
        
        init(
            parent: ObjectDefaultOrEditedDictionaries) {
        
            stability = Stability(parent.baseType)
            
            frontAndRearState = parent.twinSitOnOption[.frontAndRear] ?? false
            leftandRightState = parent.twinSitOnOption[.leftAndRight] ?? false
  
            let bodySupportDefaultDimension = PreTiltOccupantBodySupportDefaultDimension(parent.baseType).value
                
            let sideSupportDefaultDimension = PreTiltOccupantSideSupportDefaultDimension(parent.baseType).value
                
            occupantBodySupportsDimension =
                [getModifiedSitOnDimension(.id0)] +
                (parent.twinSitOnState ? [getModifiedSitOnDimension(.id1)] : [])
                
            occupantSideSupportsDimension =
                [getModifiedSideSupportDimension(.id0)] +
                (parent.twinSitOnState ? [getModifiedSideSupportDimension(.id1)] : [])
                         
            let occupantFootSupportHangerLinkDefaultDimension =
                PretTiltOccupantFootSupportDefaultDimension(parent.baseType).getHangerLink()
                //OccupantFootSupportHangerLinkDefaultDimension(parent.baseType).value
                
            occupantFootSupportHangerLinksDimension =
                [getModifiedMaximumHangerLinkDimension(.id0)] +
                (parent.twinSitOnState ? [getModifiedMaximumHangerLinkDimension(.id1)]: [])
                
                
             
            lengthBetweenWheels =
                LengthBetween(
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
        
            objectToPartDictionary = parentToPartDictionary
                
                
            func getModifiedSitOnDimension(_ id: Part)
                -> Dimension3d {
                let name =
                    CreateNameFromParts([.object, .id0, .stringLink, .sitOn, id, .stringLink, .sitOn, id]).name
                let modifiedDimension = parent.preTiltDimensionIn[name] ?? bodySupportDefaultDimension
                return
                   modifiedDimension
            }
            
                
            func getModifiedSideSupportDimension(_ id: Part)
                -> [Dimension3d] {
                    var sideSupportDimension: [Dimension3d] = []
                    let sideSupportIds: [Part] = [.id0, .id1]
                    for sideId in sideSupportIds {
                        let name =
                            CreateNameFromParts([.object, .id0, .stringLink, .sideSupport, sideId, .stringLink, .sitOn, id]).name
                        let modifiedDimension = parent.preTiltDimensionIn[name] ?? sideSupportDefaultDimension
                        sideSupportDimension.append(modifiedDimension)
                    }
                return
                    sideSupportDimension
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
                        self.parentToPartDictionary[
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
                    lengthBetweenWheels.frontRearIfFrontAndRearSitOn(): lengthBetweenWheels.frontRearIfNoFrontAndRearSitOn()
                
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
                    (occupantBodySupportsDimension[0].width +
                     occupantBodySupportsDimension[1].width)/2 +
                    occupantSideSupportsDimension[0][1].width +
                    occupantSideSupportsDimension[1][0].width
                }
        }
    }
    
    // occupantBodySupportsDimension[0].width + occupantBodySupportsDimension[1].width +                         PreTiltOccupantSideSupportDefaultDimension(parent.baseType
    //).value.width * 2
    
    
    //MARK: FOOT/SIDE/BACK/ROTATE ORIGIN
    struct PreTiltOccupantSupportOrigin: PreTiltOrigin {
        var parentToPartDictionary: PositionDictionary = [:]
        var objectToPartDictionary: PositionDictionary = [:]
        let defaultFootOrigin: PreTiltOccupantFootSupportDefaultOrigin
        let defaultBackOrigin: PreTiltOccupantBackSupportDefaultOrigin
        
        init(
            parent: ObjectDefaultOrEditedDictionaries) {
            
            defaultFootOrigin = PreTiltOccupantFootSupportDefaultOrigin(parent.baseType)
            defaultBackOrigin = PreTiltOccupantBackSupportDefaultOrigin(parent.baseType)
            let allPartIds = getAllPartIds()
                
            getDictionary(allPartIds)

                func getDictionary(
                    _ allPartIds: [Part]) {
                // -x, +x so .id0, .id1
                
                let sitOnIds = parent.oneOrTwoIds
                var parentChildPositions: [PositionAsIosAxes]
                
                let onlyOneBackSupportId: Part = .id0
                let onlyOneRotationJointId: Part = .id0
                
            for sitOnIndex in 0..<sitOnIds.count {
                let sitOnId = sitOnIds[sitOnIndex]
               
                let footPlateInOnePieceState =
                parent.objectOptions[sitOnIndex][.footSupportInOnePiece] ?? false
                
                let headSupportState =
                parent.objectOptions[sitOnIndex][.headSupport] ?? false
    
                //for indexForSide in [0,1] {
                    
                    parentChildPositions = []
                    //first position in array
                    //parentChildPositions.append(
                let objectToParent =
                        GetValueFromDictionary(
                            parent.preTiltObjectToPartOrigin,
                            [.object, .id0, .stringLink,.sitOn, sitOnId, .stringLink, .sitOn, sitOnId]).value //)
                    
                    //SIT ON ROTATION JOINT
//                    addToDictionary([
//                            .sitOn,
//                            sitOnId,
//                            .stringLink,
//                            .bodySupportRotationJoint],
//                            [onlyOneRotationJointId],
//                            PreTiltOccupantBodySupportDefaultOrigin(parent.baseType)
//                                .getBodySupportToBodySupportRotationJoint(),
//                            [0])
                    //BACK
//                    addToDictionary([
//                            .sitOn,
//                            sitOnId,
//                            .stringLink,
//                            .backSupporRotationJoint],
//                            [onlyOneBackSupportId],
//                            defaultBackOrigin
//                                .getSitOnToBackSupportRotationJoint(),
//                            [0])
//
//                    addToDictionary([
//                        .backSupporRotationJoint,
//                        sitOnId,
//                        .stringLink,
//                        .backSupport],
//                        [onlyOneBackSupportId],
//                        defaultBackOrigin
//                            .getRotationJointToBackSupport() ,
//                        [0])
//
//                    if headSupportState {
//                        addToDictionary([
//                            .backSupport,
//                            sitOnId,
//                            .stringLink,
//                            .backSupportHeadLinkRotationJoint],
//                            [onlyOneBackSupportId],
//                            defaultBackOrigin
//                                .getBackSupportToHeadLinkRotationJoint(),
//                            [0])
//
//                        addToDictionary([
//                            .backSupportHeadLinkRotationJoint,
//                            sitOnId,
//                            .stringLink,
//                            .backSupportHeadLinkRotationJoint],
//                            [onlyOneBackSupportId],
//                            defaultBackOrigin
//                                .getHeadLinkRotationJointToHeadSupport(),
//                            [0])
//                    }
                    
                    //SIDE
//                    addToDictionary([
//                        .sitOn,
//                        sitOnId,
//                        .stringLink,
//                        .sideSupportRotationJoint],
//                        allPartIds,
//                        PreTiltOccupantSideSupportDefaultOrigin(parent.baseType).getSitOnToSideSupportRotationJoint(),
//                        [0, 1])
//
//                    addToDictionary([
//                        .sideSupportRotationJoint,
//                        sitOnId,
//                        .stringLink,
//                        .sideSupport],
//                        allPartIds,
//                        PreTiltOccupantSideSupportDefaultOrigin(parent.baseType).getSideSupportRotationJointToSideSupport(),
//                        [0, 1])
                    
                    //FOOT
                    addToDictionary([
                        .sitOn,
                        sitOnId,
                        .stringLink,
                        .footSupportHangerJoint],
                        allPartIds,
                        objectToParent,
                        defaultFootOrigin
                            .getSitOnToHangerJoint(),
                        [0, 1])
                    
//                    addToDictionary([
//                        .footSupportHangerJoint,
//                        sitOnId,
//                        .stringLink,
//                        .footSupportJoint],
//                        allPartIds,
//                        defaultFootOrigin
//                            .getHangerJointToFootJoint(),
//                        [0, 1])
//
//                    if footPlateInOnePieceState {
//                        addToDictionary([
//                            .footSupportJoint,
//                            sitOnId,
//                            .stringLink,
//                            .footSupportInOnePiece],
//                            [.id0],
//                            defaultFootOrigin.getJointToOnePieceFoot(),
//                            [0])
//                    } else {
//                        addToDictionary([
//                            .footSupportJoint,
//                            sitOnId,
//                            .stringLink,
//                            .footSupport],
//                            allPartIds,
//                            defaultFootOrigin.getJointToTwoPieceFoot(),
//                            [0, 1])
//                    }
                //}
                    
                    func addToDictionary(
                        _ parts: [Part],
                        _ allPartIds: [Part],
                        _ objectToParent: PositionAsIosAxes,
                        _ defaultParentToPartOriginPosition: PositionAsIosAxes,
                        _ indicesForSide: [Int] )
                        {
                        for indexForSide in indicesForSide {
                            var parentChildPositions = [objectToParent]
                            let partId = allPartIds[indexForSide]
                            let partsWithId = parts + [partId]
                            let name =
                            CreateNameFromParts(
                                partsWithId).name
                            
                            // returns -x, +x for +x input
                            // unless x=0, returns x=0, x=0
                            let defaultPositions =
                            CreateIosPosition.forLeftRightAsArrayFromPosition(
                                defaultParentToPartOriginPosition)
                            
                            let positionOut =
                            parent.preTiltObjectToPartOriginIn[name] ??
                            defaultPositions[indexForSide]
                            
                            self.parentToPartDictionary += [name : positionOut]
                            
                            parentChildPositions.append(positionOut)
                            
                            //twoIds[indexForSide] assigns -x to .id0 and +x to .id1
                            print(parentChildPositions)
                            let objectName =
                            CreateNameFromParts(
                                [.object, .id0] +
                                Array(parts[2...3] + [allPartIds[indexForSide], .stringLink, .sitOn, sitOnId])).name
                            
                            self.objectToPartDictionary +=
                            [objectName: CreateIosPosition.addArrayOfTouples(parentChildPositions)]
                        }
                    }
                }
            }
        }
        
        func getAllPartIds()
        -> [Part] {
            [.id0, .id1]
        }
    }
    /// where is the best place to manage the bilateral and single item dictiionary
    /// at source of item or creation of dictiornary

//MARK: BASE ORIGIN
    
    struct WheelOrigin {
        var parentToPartDictionary: PositionDictionary = [:]
        var objectToPartDictionary: PositionDictionary = [:]
        let lengthBetweenFrontAndRearWheels: Double
        let parent: ObjectDefaultOrEditedDictionaries
        let bodySupportOrigin: PreTiltOccupantBodySupportOrigin
        let wheelAndCasterVerticalJointOrigin: WheelAndCasterVerticalJointOrigin
        let casterOrigin: CasterOrigin
        
        init(
            parent: ObjectDefaultOrEditedDictionaries,
            bodySupportOrigin: PreTiltOccupantBodySupportOrigin ) {
                
            self.parent = parent
            self.bodySupportOrigin = bodySupportOrigin
            
            lengthBetweenFrontAndRearWheels =
                getLengthBetweenFrontAndRearWheels()
            
            let widthBetweenWheelsAtOrigin = getWidthBetweenWheels()
            
            wheelAndCasterVerticalJointOrigin =
                WheelAndCasterVerticalJointOrigin(
                     parent.baseType,
                     lengthBetweenFrontAndRearWheels,
                    widthBetweenWheelsAtOrigin)

            let allPartIds: [Part] = getAllIds()

            casterOrigin = CasterOrigin(parent.baseType)
            
                //the number of origin is
                //1 if only two wheels
                //2 if 3 or four wheels
                //3 if six wheels
            let defaultObjectToWheelBaseJointOrigin =
                getDefaultObjecToWheelBaseJointOrigin()
                
            let defaultWheelBaseJointToForkOrigin  =
                getDefaultWheelBaseJointToForkOrigin()
            
            let defaultForkToCasterWheelOrigin =
                getDefaultForkToCasterWheelOrigin()
                    
                
                getDictionary(
                    defaultObjectToWheelBaseJointOrigin,
                    defaultWheelBaseJointToForkOrigin,
                    defaultForkToCasterWheelOrigin,
                    allPartIds)
                   
                    
 /// objectToPart1, part1ToPart2...partNToPartN+1
/// objectToPartN, partNToPartN+1
                func getDictionary(
                    _ originOfWheelBaseJoint: [PositionAsIosAxes],
                    _ originOfFork: [PositionAsIosAxes],
                    _ originOfWheel: [PositionAsIosAxes],
                    _ allPartIds: [Part]
                    ) {
                    //let twoIds: [Part] = [.id0, .id1]
                    let onlyOneSitOnId: [Part] = [.id0]
                    var parentChildPositions: [PositionAsIosAxes]
                    
                    for sitOnIndex in 0..<onlyOneSitOnId.count {
                        let sitOnId = onlyOneSitOnId[sitOnIndex]
                        
                        // fetch the origins for the base type one, two or three with +x or x =0
                        // baseWheelJointIndex are ordered so that
                        // each origin if a pair assigns to the next baseWheelJointIndexPair
                       
                        
                        for indexForSide in [1,0] {
                            
                            parentChildPositions = []
                            
                            //first positiion in array
                            parentChildPositions.append(GetValueFromDictionary(
                                parent.preTiltObjectToPartOrigin,
                                [.object, .id0, .stringLink, .baseWheelJoint, sitOnId, .stringLink, .sitOn, sitOnId]).value )
                            
                            //WheelBaseJoint
                            for baseWheelJointId in allPartIds {
                                addToDictionary([
                                        .object,
                                        .id0,
                                        .stringLink,
                                        .baseWheelJoint,
                                        baseWheelJointId],
                                        PreTiltOccupantBodySupportDefaultOrigin(parent.baseType)
                                            .getBodySupportToBodySupportRotationJoint(),
                                                indexForSide
                                            )
                            }
                        
                        }
                            
                        func addToDictionary(
                            _ parts: [Part],
                            _ defaultParentToPartOriginPosition: PositionAsIosAxes,
                            _ indexForSide: Int ){

                            let name =
                                CreateNameFromParts(
                                parts).name

                            let defaultPositions =
                                CreateIosPosition.forLeftRightAsArrayFromPosition(
                                defaultParentToPartOriginPosition)

                            let positionOut =
                                parent.preTiltObjectToPartOriginIn[name] ??
                                defaultPositions[indexForSide]


                            self.parentToPartDictionary += [name : positionOut]

                            parentChildPositions.append(positionOut)


//                            let objectName =
//                                    CreateNameFromParts(
//                                        [.object, .id0] +
//                                        Array(parts[2...3] + [twoIds[indexForSide], .stringLink, .sitOn, sitOnId])).name
//
//                            self.objectToPartDictionary +=
//                                [objectName: CreateIosPosition.addArrayOfTouples(parentChildPositions)]

                        }

                    }
                        
                }
                
            
            func getAllIds()
                -> [Part]{
                // id locations are assigned as clockwise order
                // as visually layed out
                //
                // id0...id1 for two
                //
                // id0...id1 for three front
                //    id2
                //
                //    id0    for three rear
                // id2...id1
                //
                // id0...id1 for four
                // id3...id2
                //
                // id0...id1 for six
                // id5...id2
                // id4...id3
                //
                // location in array with left right as pairs
                let twoIds: [Part] = [.id0, .id1]
                var requiredIds: [Part] = []
                //create selection process for number of ids
                  if BaseObjectGroups().fourWheels.contains(parent.baseType) {
                      requiredIds = twoIds + [.id3, .id2]
                      //index for side 0,1 then 01
                  }

                  if BaseObjectGroups().sixWheels.contains(parent.baseType) {
                      requiredIds = twoIds + [.id5, .id2, .id4, .id3]
                  }

                  if parent.baseType == .scooterRearDrive3Wheeler {
                      requiredIds = [.id0,.id2, .id1]
                      // indexForSide 0, then 0,1
                  }

                  if parent.baseType == .scooterFrontDrive3Wheeler {
                      requiredIds = twoIds  + [.id2]
                      //indexForSide 0,1 then 0
                  }
                return requiredIds
            }
                
            
                
            func getLengthBetweenFrontAndRearWheels ()
                -> Double {
                TwinSitOn(parent.twinSitOnOption).frontAndRearState ?
                    bodySupportOrigin.lengthBetweenWheels.frontRearIfFrontAndRearSitOn():
                    bodySupportOrigin.lengthBetweenWheels.frontRearIfNoFrontAndRearSitOn()
            }
            
            func getWidthBetweenWheels()
                -> Double {
                
                let bodySupportDimension =
                        bodySupportOrigin.occupantBodySupportsDimension
                let sideSupportDimension =
                        bodySupportOrigin.occupantSideSupportsDimension
                   
                    let widthWithoutStability =
                        bodySupportDimension.count == 2 ?
                            (forIndex(0) + forIndex(1)): forIndex(0)
                    let width = widthWithoutStability +
                    Stability(parent.baseType).atLeft +
                    Stability(parent.baseType).atRight
                    
                    func forIndex(_ id: Int) -> Double {
                        return
                            bodySupportDimension[id].width + sideSupportDimension[id][0].width + sideSupportDimension[id][1].width
                    }
                    return width
                }

            
        }
        

//        func getDictionaryForFixedWheel(
//            _ originOfBaseContact: [PositionAsIosAxes]
//            ) {
//
//
//
//            }
        
        
        func getDefaultObjecToWheelBaseJointOrigin ()
            -> [PositionAsIosAxes] {
            var wheelOrigin =
                Array(repeating: ZeroValue.iosLocation, count: 3)
            
            if BaseObjectGroups().allCaster.contains(parent.baseType) {
                
                if parent.baseType == .allCasterSixHoist {
                    wheelOrigin =
                        wheelAndCasterVerticalJointOrigin.getCasterWhenAllSixCaster()
                    
                } else {
                    wheelOrigin = wheelAndCasterVerticalJointOrigin.getCasterWhenAllCaster()
                }
                
            }
            
            if BaseObjectGroups().rearPrimaryOrigin.contains(parent.baseType) {
                wheelOrigin =
                wheelAndCasterVerticalJointOrigin.getDriveWheels()
                +
                wheelAndCasterVerticalJointOrigin.getCasterwhenRearPrimaryOrigin()
            }
                
            if BaseObjectGroups().frontPrimaryOrigin.contains(parent.baseType) {
                wheelOrigin =
                wheelAndCasterVerticalJointOrigin.getDriveWheels()
                +
                wheelAndCasterVerticalJointOrigin.getCasterWhenFrontPrimaryOrgin()
            }
                
            if BaseObjectGroups().midPrimaryOrigin.contains(parent.baseType) {
                wheelOrigin =
                wheelAndCasterVerticalJointOrigin.getDriveWheels()
                +
                wheelAndCasterVerticalJointOrigin.getCasterWhenMidPrimaryOrigin()
            }
                return wheelOrigin
        }
        
        
        func getDefaultWheelBaseJointToForkOrigin ()
            -> [PositionAsIosAxes] {
            var forkOrigin =
                Array(repeating: ZeroValue.iosLocation, count: 3)
                
            if BaseObjectGroups().allCaster.contains(parent.baseType) {
                let forkForSixCasterOrigin =
                parent.baseType == .allCasterSixHoist ? [casterOrigin.forMidCasterVerticalJointToFork()]: []
               
                forkOrigin =
                    [casterOrigin.forRearCasterVerticalJointToFork()] +
                    forkForSixCasterOrigin +
                    [casterOrigin.forFrontCasterVerticalJointToFork()]
 
            }
            
            if BaseObjectGroups().rearPrimaryOrigin.contains(parent.baseType) {
                forkOrigin =
                    [casterOrigin.forRearCasterVerticalJointToFork()]
            }
                
            if BaseObjectGroups().frontPrimaryOrigin.contains(parent.baseType) {
                forkOrigin =
                [casterOrigin.forFrontCasterVerticalJointToFork()]
            }
                
            if BaseObjectGroups().midPrimaryOrigin.contains(parent.baseType) {
                forkOrigin =
                    [casterOrigin.forRearCasterVerticalJointToFork()] +
                    [casterOrigin.forFrontCasterVerticalJointToFork()]
            }
                return forkOrigin
        }
        
        
        func getDefaultForkToCasterWheelOrigin ()
            -> [PositionAsIosAxes] {
            var forkOrigin =
                Array(repeating: ZeroValue.iosLocation, count: 3)
                
            if BaseObjectGroups().allCaster.contains(parent.baseType) {
                let forkForSixCasterOrigin =
                parent.baseType == .allCasterSixHoist ? [casterOrigin.forMidCasterForkToWheel()]: []
               
                forkOrigin =
                    [casterOrigin.forRearCasterForkToWheel()] +
                    forkForSixCasterOrigin +
                    [casterOrigin.forFrontCasterForkToWheel()]
 
            }
            
            if BaseObjectGroups().rearPrimaryOrigin.contains(parent.baseType) {
                forkOrigin =
                    [casterOrigin.forRearCasterForkToWheel()]
            }
                
            if BaseObjectGroups().frontPrimaryOrigin.contains(parent.baseType) {
                forkOrigin =
                [casterOrigin.forFrontCasterForkToWheel()]
            }
                
            if BaseObjectGroups().midPrimaryOrigin.contains(parent.baseType) {
                forkOrigin =
                    [casterOrigin.forRearCasterForkToWheel()] +
                    [casterOrigin.forFrontCasterForkToWheel()]
            }
                return forkOrigin
        }
        

        
        
        func forRearPrimaryOrigin() {
        }
        
        
        func forMidPrimaryOrigin() {
        }
        
        func forFrontPrimaryOrgin() {
        }
        
    }
    

    
    
}


protocol PreTiltOrigin {
    var parentToPartDictionary: PositionDictionary {get}
    var objectToPartDictionary: PositionDictionary {get}
}



//MARK: CORNERS
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
        width: dimensionIn.width,
        length: maximumLengthAfterRotationAboutX,
        height: dimensionIn.height)
    }
    

    func calculateFrom( dimension: Dimension3d)
    -> [PositionAsIosAxes] {
        let (w,l,h) = dimension
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
