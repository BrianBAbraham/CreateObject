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
            
        let originIdNodesForFoot =
            getOriginIdNodesForSupport(.foot)


        let footDimensions =
            AllOccupantFootRelated(
                parent.baseType,
                originIdNodesForFoot[0].nodes
            ).defaultDimensions
            
            forFoot +=
            DimensionDictionary(
                originIdNodesForFoot,
                footDimensions,
                parent.dimensionIn,
                0
            ).forPart
            
            
            
            let allWheelRelated =
                AllWheelRelated(
                    parent.baseType)
            
            
            
print (allWheelRelated)
print(preTiltWheelOrigin!.allOriginIdNodesForRear.ids)
print(preTiltWheelOrigin!.allOriginIdNodesForMid.ids)
print(preTiltWheelOrigin!.allOriginIdNodesForFront.nodes)
print(preTiltWheelOrigin!.allOriginIdNodesForFront.ids)
            
                   
        }

//print (getPartAndIdForWheel(.rearWheel))
//
//print (getPartAndIdForSupport(.back))


  
//            forBack =
//                getDictionary(
//                AllOccupantBackRelated(
//                    parent.baseType,
//                ) )
                
            //forBody = getDictionaryForBody()
                
           
                
//            forSide = getDictionary(
//                AllOccupantSideRelated(
//                    parent.baseType) )
//

            
        func getOriginIdNodesForSupport (
            _ dimensionGroup: DimensionGroup)
            -> [OriginIdNodes] {
            var originIdNodes: [OriginIdNodes] = []
            
            if let unwrappedPreTiltSupport = preTiltOccupantSupportOrigin  {
                switch dimensionGroup {
                case .back:
                    originIdNodes =
                    unwrappedPreTiltSupport.allOriginIdNodesForBackSupportForBothSitOn
                case .foot:
                    originIdNodes =
                    unwrappedPreTiltSupport.allOriginIdNodesForFootSupportForBothSitOn
                case .side:
                    originIdNodes =
                    unwrappedPreTiltSupport.allOriginIdNodesForSideSupportForBothSitOn
                default: break
                }
            }
            return originIdNodes
        }
            
            
        func getPartAndIdForWheel (
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
            
         

//        func getDictionary(
//            _ originIdNodes: [OriginIdNodes],
//            _ dimensions: [Dimension3d])
//        -> Part3DimensionDictionary {
//            DimensionDictionary(
//                originIdNodes,
//                dimensions,
//                parent.dimensionIn
//            ).forPart
//        }
    
}



