//
//  DimensionDictionary.swift
//  CreateObject
//
//  Created by Brian Abraham on 07/09/2023.
//

import Foundation

struct DimensionDictionary {
    var forPart: Part3DimensionDictionary = [:]
    
    /// uses UI editable dimensionIn value
    /// else uses defaultDimension value
    /// - Parameters:
    ///   - parts: all the parts associated with that section of the object
    ///   - defaultDimensions: default
    ///   - twinSitOnOptions:
    ///   - dimensionIn: no value or  default value or  edited value
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


//MARK: GET DIMENSIONS
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
            
            let dimensions =
                DimensionDictionary(
                    allOccupantRelated.parts,
                    allOccupantRelated.defaultDimensions,
                    parent.twinSitOnOption,
                    parent.preTiltDimensionIn
                ).forPart
            
print(dimensions)
            return dimensions
        }
            
        func  getDictionaryForBody()
            -> Part3DimensionDictionary {
                let dimension =
                    OccupantBodySupportDefaultDimension(
                        parent.baseType).value
                
                let angle =
                    OccupantBodySupportDefaultAngleChange(parent.baseType).value
                
                let rotatedDimension =
                    RotatedPartCorners(
                        dimensionIn: dimension,
                        angleChangeIn:  angle
                    ).lengthAlteredForRotationDimension
      
                let rotatedDimensions =
                    parent.twinSitOnState ? [rotatedDimension, rotatedDimension]: [rotatedDimension]
                
                let parts: [Part] =
                    parent.twinSitOnState ? [.sitOn, .sitOn]: [.sitOn]
                
                return
                    DimensionDictionary(
                        parts,
                        rotatedDimensions,
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
                        allOccupantRelated.defaultDimensions,
                        parent.twinSitOnOption,
                        parent.preTiltDimensionIn
                    ).forPart
        }
            
        func  getDictionaryForSide()
            -> Part3DimensionDictionary {
                
                let allOccupantRelated =
                    AllOccupantSideRelated(
                        parent.baseType,
                        parent.preTiltDimensionIn )

                
               return
                    DimensionDictionary(
                        [.sideSupport],
                        allOccupantRelated.defaultDimensions,
                        parent.twinSitOnOption,
                        parent.preTiltDimensionIn
                    ).forPart
        }
         
         //MARK:- REDUCE CODE
        func getDictionary() {
            
        }
    }
}

