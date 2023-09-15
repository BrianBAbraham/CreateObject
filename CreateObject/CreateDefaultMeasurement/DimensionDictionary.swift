//
//  DimensionDictionary.swift
//  CreateObject
//
//  Created by Brian Abraham on 07/09/2023.
//

import Foundation


enum DimensionGroup {
    case rearWheel
    case midWheel
    case frontWheel
    case body
    case foot
    case side
    case back
}

/// <#Description#>
struct DimensionDictionary {
    var forPart: Part3DimensionDictionary = [:]
    
    
    init(
        _ originIdNodes: [OriginIdNodes],
        _ defaultDimensions: [Dimension3d],
        _ dimensionIn: Part3DimensionDictionary,
        _ sitOnIndex: Int) {
            
       
  
           // for sitOnIndex in 0..<originIdNodes.count {//provides sitOn number
                let sitOnId: Part = [.id0,.id1][sitOnIndex]
                let parts = originIdNodes[sitOnIndex].nodes

                for partIndex in 0..<parts.count{
                    let idsForPart: [Part] = originIdNodes[sitOnIndex].ids[partIndex]
                    for partIdIndex in  0..<idsForPart.count {
                
                        let nameStart: [Part] =
                        [.object, .id0, .stringLink]
                        
                        let nameEnd: [Part] = parts[partIndex] == .sitOn ?
                            [sitOnId, .stringLink, .sitOn, sitOnId] : [idsForPart[partIdIndex], .stringLink, .sitOn, sitOnId]
                        
                        let x = nameStart + [ parts[partIndex]] + nameEnd
                        let partName = CreateNameFromParts(x).name
                        let dimension = dimensionIn[partName] ?? defaultDimensions[partIndex]
                        self.forPart +=
                        [partName: dimension ]
                }
            }
       // }
    }
}


//MARK: GET DIMENSIONS
//retrieves a passed value if extant else a default value
struct OccupantSupportDimensionDictionary {
    let parent: DimensionOriginCornerDictionaries
    let preTiltOccupantSupportOrigin: DimensionOriginCornerDictionaries.PreTiltOccupantSupportOrigin?
    let preTiltWheelOrigin:
        DimensionOriginCornerDictionaries.PreTiltWheelOrigin?
    
    //individual dictionaries permit easy exclusion
    var forBack:  Part3DimensionDictionary = [:]
    var forBody:  Part3DimensionDictionary = [:]
    var forFoot:  Part3DimensionDictionary = [:]
    var forSide: Part3DimensionDictionary = [:]
    var forWheels: Part3DimensionDictionary = [:]

    
    init(
        parent: DimensionOriginCornerDictionaries) {
            self.parent = parent
            
        preTiltOccupantSupportOrigin =
        parent.preTiltOccupantFootBackSideSupportOrigin as? DimensionOriginCornerDictionaries.PreTiltOccupantSupportOrigin

        preTiltWheelOrigin =
        parent.preTiltWheelOrigin as? DimensionOriginCornerDictionaries.PreTiltWheelOrigin
            
            
            
            
            
            
//        let originIdNodesForFoot =
//            getOriginIdNodesForSupport(.foot)
//
//        let footDimensions =
//            AllOccupantFootRelated(
//                parent.baseType,
//                originIdNodesForFoot[0].nodes
//            ).defaultDimensions
            
           
            
            //if BaseObjectGroups().hasFootSupport.contains(parent.baseType) {
                forFoot += getOriginIdNodesForSupport(.foot, 0)
            //}
                forSide += getOriginIdNodesForSupport(.side, 0)
//print (forSide)
            //if BaseObjectGroups().hasBackSupport.contains(parent.baseType) {
                forBack += getOriginIdNodesForSupport(.back, 0)
            //}
            

//            DimensionDictionary(
//                originIdNodesForFoot,
//                footDimensions,
//                parent.dimensionIn,
//                0
//            ).forPart
            
            
            
        let allWheelRelated =
            AllWheelRelated(
                parent.baseType)
        let originIdNodesForWheelRear =
            getOriginIdNodesForWheel(.rearWheel)
        let originIdNodesForWheelFront =
            getOriginIdNodesForWheel(.frontWheel)
        
        let onlyOneWheelSet = 0
        forWheels +=
        DimensionDictionary(
            [originIdNodesForWheelRear],
            allWheelRelated.defaultRearMidFrontDimension.rear,
            parent.dimensionIn,
            onlyOneWheelSet
        ).forPart
        
        forWheels +=
        DimensionDictionary(
            [originIdNodesForWheelFront],
            allWheelRelated.defaultRearMidFrontDimension.front,
            parent.dimensionIn,
            onlyOneWheelSet
        ).forPart
           
            
            
//            print(allWheelRelated.defaultRearMidFrontDimension.front)
//            print("\n\n")
//            print(preTiltWheelOrigin!.allOriginIdNodesForFront.nodes)
//            print(preTiltWheelOrigin!.allOriginIdNodesForFront.ids)
//print(preTiltWheelOrigin!.allOriginIdNodesForRear.ids)
//print(preTiltWheelOrigin!.allOriginIdNodesForMid.ids)
//
//print(preTiltWheelOrigin!.allOriginIdNodesForFront.ids)
            
                   
        }



            
        func getOriginIdNodesForSupport (
            _ dimensionGroup: DimensionGroup,
            _ sitOnIndex: Int)
            -> Part3DimensionDictionary {
            var originIdNodes: [OriginIdNodes] = []
            var dimensions: [Dimension3d] = []
            var dictionary: Part3DimensionDictionary = [:]
            // objects which do not have a part have a originIdNode.count = 0
            if let unwrappedPreTiltSupport = preTiltOccupantSupportOrigin  {
                switch dimensionGroup {
                case .back:
                    originIdNodes =
                    unwrappedPreTiltSupport.allOriginIdNodesForBackSupportForBothSitOn
                    if originIdNodes.count > 0 {
                        dimensions =
                            AllOccupantBackRelated(
                                parent.baseType,
                                originIdNodes[sitOnIndex].nodes
                            ).defaultDimensions

                        dictionary =
                            DimensionDictionary(
                                originIdNodes,
                                dimensions,
                                parent.dimensionIn,
                                sitOnIndex
                            ).forPart
                    } else {
                        dictionary = [:]
                    }
                    
                        
                case .foot:
                    originIdNodes =
                    unwrappedPreTiltSupport.allOriginIdNodesForFootSupportForBothSitOn
                    if originIdNodes.count > 0 {
                        dimensions =
                            AllOccupantFootRelated(
                                parent.baseType,
                                originIdNodes[sitOnIndex].nodes
                            ).defaultDimensions

                        dictionary =
                        DimensionDictionary(
                            originIdNodes,
                            dimensions,
                            parent.dimensionIn,
                            sitOnIndex
                        ).forPart
                    } else {
                        dictionary = [:]
                    }

                case .side:
                    originIdNodes =
                        unwrappedPreTiltSupport.allOriginIdNodesForSideSupportForBothSitOn
                    if originIdNodes.count > 0 {
                        dimensions =
                            AllOccupantSideRelated(
                                parent.baseType,
                                originIdNodes[sitOnIndex].nodes
                            ).defaultDimensions
                        dictionary =
                            DimensionDictionary(
                                originIdNodes,
                                dimensions,
                                parent.dimensionIn,
                                sitOnIndex
                            ).forPart
                    } else {
                        dictionary = [:]
                    }
                default: break
                }
            }
            return dictionary
        }
            
            
        func getOriginIdNodesForWheel (
            _ dimensionGroup: DimensionGroup)
            -> OriginIdNodes {
            var originIdNode:OriginIdNodes = ZeroValue.originIdNodes
            if let unwrappedWheel = preTiltWheelOrigin  {
                switch dimensionGroup {
                case .frontWheel:
                    originIdNode =
                    unwrappedWheel.allOriginIdNodesForFront
                case .midWheel:
                    originIdNode =
                    unwrappedWheel.allOriginIdNodesForMid
                case .rearWheel:
                    originIdNode =
                    unwrappedWheel.allOriginIdNodesForRear
                default: break
                }
            }
            return originIdNode
        }


//        func  getDictionaryForBody()
//            -> Part3DimensionDictionary {
//                let dimension =
//                    OccupantBodySupportDefaultDimension(
//                        parent.baseType).value
//
//
//                let parts: [Part] =
//                    parent.twinSitOnState ? [.sitOn, .sitOn]: [.sitOn]
//                let ids: [Part] =
//                    parent.twinSitOnState ? [.id0, .id1]: [.id0]
//
//                return
//                    DimensionDictionary(
//                        parts,
//                        ids,
//                        [dimension],
//                        parent.twinSitOnOption,
//                        parent.dimensionIn
//                    ).forPart
//        }
            
         


    
}



