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


//struct Parent {
//    let parentProperty: Int
//
//    struct Child {
//        func accessParentProperty(parent: Parent) {
//            let value = parent.parentProperty
//            print(value) // Output: 10
//        }
//    }
//}


struct Parent {
    let data1: Int
    let data2: Int

    struct ChildA {
        init(parent: Parent) {
            
            var data1ForChildA = parent.data1
            var data2ForChildA = parent.data2
        }
        }
    }
    
//    struct ChildB {
//        var dataForChildA: Int {
//            data * 2
//    }
    
//}

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


//struct CreateDefaultOriginDictionary {
//    var dictionary: PositionDictionary = [:]
//
//    init(
//        _ parts: [Part],
//        _ origins: [PositionAsIosAxes],
//        _ twinSitOnOptions: TwinSitOnOptions) {
//            
//        var idsForPart: [Part] = [.id0, .id1]
//        var idsForSitOn: [Part] =  [.id0, .id1]
//        
//        // any part with backSupport in the name will only have one item per sitOn
//        let onlyOneExists = [Part.backSupport.rawValue]
//        let enumCodedSoAnyMemberCanBeUsed = 0
//        idsForPart =
//            onlyOneExists.contains(where: parts[enumCodedSoAnyMemberCanBeUsed].rawValue.contains) ? [.id0]: idsForPart
//
//        idsForSitOn =
//            (twinSitOnOptions[.frontAndRear] ?? false ||
//            twinSitOnOptions[.leftAndRight] ?? false)  ? idsForSitOn: [.id0]
//            
//        for partId in  idsForPart {
//            for sitOnId in idsForSitOn {
//                let nameEnd: [Part] = [partId, .stringLink, .sitOn, sitOnId]
//                
//                for index in 0..<parts.count {
//                    let x = [parts[index]] + nameEnd
//                    self.dictionary +=
//                    [CreateNameFromParts(x).name: dimensions[index] ]
//                }
//            }
//        }
//    }
//}


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


struct ObjectDefaultDimension2 {
    var dictionary: Part3DimensionDictionary = [:]
    let modifiedPartDictionary: Part3DimensionDictionary
    let modifiedOriginDictionary: PositionDictionary
    let modifiedAngleDictionary: AngleDictionary
    //let requestOccupantBodySupportDictionary: RequestOccupantBodySupportDictionary
    let baseType: BaseObjectTypes
    let twinSitOnOptions: TwinSitOnOptions
    
    init(
        _ baseType: BaseObjectTypes,
        _ twinSitOnOptions: TwinSitOnOptions,
        _ modifiedPartDictionary: Part3DimensionDictionary = [:],
        _ modifiedOriginDictinary: PositionDictionary = [:],
        _ modifiedAngleDictionary: AngleDictionary = [:]) {
            
        self.baseType = baseType
        self.twinSitOnOptions = twinSitOnOptions
        self.modifiedPartDictionary = modifiedPartDictionary
        self.modifiedOriginDictionary = modifiedOriginDictinary
        self.modifiedAngleDictionary = modifiedAngleDictionary
            
        //self.requestOccupantBodySupportDictionary =
            dictionary +=
            RequestOccupantBodySupportDictionary(parent: self).dictionary
            
            dictionary +=
            RequestOccupantFootSupportDictionary(parent: self).dictionary
        
//        dictionary =
//        createDefaultObjectDictionary(
//            baseType,
//            twinSitOnOptions)
//
//        func createDefaultObjectDictionary(
//            _ baseType: BaseObjectTypes,
//            _ twinSitOnOptions: TwinSitOnOptions)
//            -> Part3DimensionDictionary {
//                var defaultDimensionDictionary =
//                        RequestOccupantBodySupportDefaultDimensionDictionary(
//                            baseType,
//                            twinSitOnOptions,
//                            modifiedPartDictionary).dictionary
//
//                    defaultDimensionDictionary +=
//                            RequestOccupantFootSupportDefaultDimensionDictionary(
//                                baseType,
//                                twinSitOnOptions,
//                                modifiedPartDictionary).dictionary
//
//                     defaultDimensionDictionary +=
//                        RequestOccupantBackSupportDefaultDimensionDictionary(
//                            baseType, twinSitOnOptions).dictionary
//
//                    defaultDimensionDictionary +=
//                        RequestOccupantSideSupportDefaultDimensionDictionary(
//                            baseType,
//                            twinSitOnOptions,
//                            modifiedPartDictionary).dictionary
//
//                return defaultDimensionDictionary
//        }
    }
    
    struct RequestOccupantBodySupportDictionary {
        var dictionary: Part3DimensionDictionary = [:]
        let baseType: BaseObjectTypes
        let modifiedPartDictionary: Part3DimensionDictionary
        let twinSitOnOptions: TwinSitOnOptions
        
        init(
            parent: ObjectDefaultDimension2) {
            baseType = parent.baseType
            twinSitOnOptions = parent.twinSitOnOptions
            modifiedPartDictionary = parent.modifiedPartDictionary
                
                
            getDictionary()
                func getDictionary() {
                    let dimension =
                        OccupantBodySupportDefaultDimension(
                            baseType,
                            modifiedPartDictionary).value
                    let dimensions =
                    TwinSitOn(twinSitOnOptions).state ? [dimension, dimension]: [dimension]
                    let parts: [Part] =
                    TwinSitOn(twinSitOnOptions).state ? [.sitOn, .sitOn]: [.sitOn]
                    
                    dictionary =
                        CreateDefaultDimensionDictionary(
                            parts,
                            dimensions,
                            twinSitOnOptions
                        ).dictionary
            }
        }
    }
    
    struct RequestOccupantFootSupportDictionary {
        var dictionary: Part3DimensionDictionary = [:]
        let baseType: BaseObjectTypes
        let modifiedPartDictionary: Part3DimensionDictionary
        let twinSitOnOptions: TwinSitOnOptions
        
        init(
            parent: ObjectDefaultDimension2) {
            baseType = parent.baseType
            twinSitOnOptions = parent.twinSitOnOptions
            modifiedPartDictionary = parent.modifiedPartDictionary
                
            getDictionary()
            
            func getDictionary() {
                    
                let allOccupantRelated =
                    AllOccupantFootRelated(
                        baseType,
                        modifiedPartDictionary)
                dictionary =
                    CreateDefaultDimensionDictionary(
                        allOccupantRelated.parts,
                        allOccupantRelated.dimensions,
                        twinSitOnOptions
                    ).dictionary
            }
        }
    }
    
    //MARK: ORIGIN
    struct OccupantBodySupportOrigin {
        static let sitOnHeight = 500.0
        let stability: Stability
        var origin: [PositionAsIosAxes] = []
        let frontAndRearState: Bool
        let leftandRightState: Bool
        var dictionaryOut: PositionDictionary = [:]
        let occupantBodySupport: [Dimension3d]
        let occupantFootSupportHangerLink: Dimension3d
        let distanceBetweenFrontAndRearWheels: DistanceBetweenFrontAndRearWheels
        
        let baseType: BaseObjectTypes
        let modifiedPartDictionary: Part3DimensionDictionary
        let twinSitOnOptions: TwinSitOnOptions
        
        init(
            parent: ObjectDefaultDimension2) {
            baseType = parent.baseType
            twinSitOnOptions = parent.twinSitOnOptions
            modifiedPartDictionary = parent.modifiedPartDictionary
                
                
            
            stability = Stability(baseType)
            frontAndRearState = twinSitOnOptions[.frontAndRear] ?? false
            leftandRightState = twinSitOnOptions[.leftAndRight] ?? false
  
                
            let sitOnName0 = CreateNameFromParts([.sitOn, .id0, .stringLink, .object, .id0]).name
            let sitOnName1 = CreateNameFromParts([.sitOn, .id1, .stringLink, .object, .id0]).name
            
            let modifiedSitOnDimension0 =
                modifiedPartDictionary[sitOnName0]
            let modifiedSitOnDimension1 =
                modifiedPartDictionary[sitOnName1]
                
            occupantBodySupport =
                [
                modifiedSitOnDimension0 ??
                OccupantBodySupportDefaultDimension(baseType, modifiedPartDictionary).value,
                modifiedSitOnDimension1 ??
                OccupantBodySupportDefaultDimension(baseType, modifiedPartDictionary).value,
                ]
                
            occupantFootSupportHangerLink =
                OccupantFootSupportHangerLinkDefaultDimension(baseType, modifiedPartDictionary).value
                
            distanceBetweenFrontAndRearWheels =
                 DistanceBetweenFrontAndRearWheels(baseType, modifiedPartDictionary)
                
            if BaseObjectGroups().rearPrimaryOrigin.contains(baseType) {
                forRearPrimaryOrigin()
            }
            if BaseObjectGroups().frontPrimaryOrigin.contains(baseType) {
                forFrontPrimaryOrgin()
            }
            if BaseObjectGroups().midPrimaryOrigin.contains(baseType) {
                forMidPrimaryOrigin()
            }
                
            
            getDictionary()
        
                
                
//            func getModifiedDimension(_ partAndParentPart: [Part])
//            -> [Dimension3d?] {
//                let name0 = CreateNameFromParts([partAndParentPart[0], .id0, .stringLink, partAndParentPart[1], .id0]).name
//            }
                
            func getDictionary() {
                let ids: [Part] =
                    (frontAndRearState || leftandRightState) ?
                    [.id0, .id1] :  [.id0]
                
                    
                    for index in 0..<ids.count {
                        self.dictionaryOut[
                            CreateNameFromParts([
                                .sitOn,
                                ids[index],
                                .stringLink,
                                .object,
                                .id0]).name] = origin[index]
                    }
            }
            
            func forRearPrimaryOrigin() {
                origin.append(
                    (x: 0.0,
                    y:
                    stability.atRear +
                     occupantBodySupport[0].length/2,
                     z: Self.sitOnHeight)
                )
                
                if frontAndRearState {
                    origin.append(
                            (x: 0.0,
                            y:
                                
                            stability.atRear +
                             occupantBodySupport[0].length +
                             occupantFootSupportHangerLink.length +
                            occupantBodySupport[1].length/2,
                             z: Self.sitOnHeight)
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
                     z: Self.sitOnHeight)
                    ]
                }
            }
                
            func forMidPrimaryOrigin(){
                let baseLength = frontAndRearState ?
                    distanceBetweenFrontAndRearWheels.ifFrontAndRearSitOn: distanceBetweenFrontAndRearWheels.ifNoFrontAndRearSitOn
                
                origin.append(
                (x: 0.0,
                 y: 0.5 * (baseLength - occupantBodySupport[0].length),
                 z: Self.sitOnHeight)
                )
                
                if frontAndRearState {
                    origin =
                    [
                    (x: 0.0,
                     y: -origin[0].y,
                     z: Self.sitOnHeight)
                     ,
                    (x: 0.0,
                     y: origin[0].y,
                    z: Self.sitOnHeight)
                    ]
                }
                
                if leftandRightState {
                    origin =
                    [
                    (x: 0.0,
                     y: -origin[0].y,
                     z: Self.sitOnHeight)
                     ,
                    (x: 0.0,
                     y: origin[0].y,
                    z: Self.sitOnHeight)
                    ]
                }
            }
                
            func forFrontPrimaryOrgin() {
                origin.append(
                    (x: 0.0,
                     y:
                    -(stability.atFront +
                        occupantBodySupport[0].length/2),
                     z: Self.sitOnHeight )
                     )
                
                if frontAndRearState {
                    origin = [
                        (x: 0.0,
                         y:
                            -stability.atFront -
                            occupantBodySupport[0].length -
                            occupantFootSupportHangerLink.length -
                            occupantBodySupport[1].length/2,
                         z: Self.sitOnHeight
                         ),
                        origin[0]
                    ]
                }
                
                if leftandRightState {
                    origin = [
                        (x: -leftAndRightX(),
                         y: origin[0].y,
                         z: Self.sitOnHeight),
                        (x: leftAndRightX(),
                         y: origin[0].y,
                         z: Self.sitOnHeight)
                    ]
                }
            }
                
                func leftAndRightX ()
                    -> Double {
                        (occupantBodySupport[0].width + occupantBodySupport[1].width)/2 +
                         OccupantSideSupportDefaultDimension(baseType, modifiedPartDictionary).value.width
                }
        }
    }
}
