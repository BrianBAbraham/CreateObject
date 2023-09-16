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
            
//print (originIdNodes)
  
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
            
        // for... are empty if not present on object
        forFoot += getOriginIdNodesForSupport(.foot, 0)
        forSide += getOriginIdNodesForSupport(.side, 0)
        forBack += getOriginIdNodesForSupport(.back, 0)
            
        let preTiltBodySupportOrigin =
            parent.preTiltOccupantBodySupportOrigin as?
            DimensionOriginCornerDictionaries.PreTiltOccupantBodySupportOrigin
            
           // preTiltBodySupportOrigin?.allOriginIdNodes
            
            if let preTiltBodySupportOrigin {
                let dimension = OccupantBodySupportDefaultDimension(parent.baseType).value
                forBody +=
                DimensionDictionary(
                    preTiltBodySupportOrigin.allOriginIdNodes[0],
                    [dimension, dimension],
                    parent.dimensionIn,
                    0).forPart
            }

            
        let allWheelRelated =
            AllWheelRelated(
                parent.baseType)
        let originIdNodesForWheelRear =
            getOriginIdNodesForWheel(.rearWheel)
        let originIdNodesForWheelMid =
            getOriginIdNodesForWheel(.midWheel)
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
        
        if BaseObjectGroups().sixWheels.contains(parent.baseType) {

        forWheels +=
        DimensionDictionary(
            [originIdNodesForWheelMid],
            allWheelRelated.defaultRearMidFrontDimension.mid,
            parent.dimensionIn,
            onlyOneWheelSet
            ).forPart
        }

            
        forWheels +=
        DimensionDictionary(
            [originIdNodesForWheelFront],
            allWheelRelated.defaultRearMidFrontDimension.front,
            parent.dimensionIn,
            onlyOneWheelSet
        ).forPart
        }

        
    
    func getOriginIdNodesForSupport(
        _ dimensionGroup: DimensionGroup,
        _ sitOnIndex: Int
    ) -> Part3DimensionDictionary {
        var originIdNodesForBothSitOn: [OriginIdNodes] = []
        var dimensions: [Dimension3d] = []
        var dictionary: Part3DimensionDictionary = [:]

        if let unwrappedPreTiltSupport = preTiltOccupantSupportOrigin {
            switch dimensionGroup {
            case .back:
                originIdNodesForBothSitOn = unwrappedPreTiltSupport.allOriginIdNodesForBackSupportForBothSitOn
                if originIdNodesForBothSitOn.count > 0 {//object may not have this part
                    dimensions = AllOccupantBackRelated(parent.baseType, originIdNodesForBothSitOn[sitOnIndex].nodes).defaultDimensions
                }
            case .foot:
                originIdNodesForBothSitOn = unwrappedPreTiltSupport.allOriginIdNodesForFootSupportForBothSitOn
                if originIdNodesForBothSitOn.count > 0 {//object may not have this part
                    let relevantOriginIdNodes = originIdNodesForBothSitOn[sitOnIndex]
                    dimensions = AllOccupantFootRelated(parent.baseType, originIdNodesForBothSitOn[sitOnIndex].nodes).defaultDimensions
                }
            case .side:
                originIdNodesForBothSitOn =
                    unwrappedPreTiltSupport.allOriginIdNodesForSideSupportForBothSitOn
                if originIdNodesForBothSitOn.count > 0 {//object may not have this part
                   
                    dimensions =
                    AllOccupantSideRelated(
                        parent.baseType,
                        originIdNodesForBothSitOn[sitOnIndex]
                            .nodes )
                                .defaultDimensions
//                    AllOccupantSideRelated(
//                        parent.baseType,
//                        removeSitOn(originIdNodesForBothSitOn, sitOnIndex)[sitOnIndex]
//                            .nodes)
//                                .defaultDimensions
                }
            default: break
            }
            if originIdNodesForBothSitOn.count > 0 {
                dictionary = DimensionDictionary(originIdNodesForBothSitOn, dimensions, parent.dimensionIn, sitOnIndex).forPart
            }
        }
        
        func removeSitOn(
            _ originIdNodesForBothSitOn: [OriginIdNodes],
            _ sitOnIndex: Int)
            -> [OriginIdNodes] {
                var withoutSitOn = originIdNodesForBothSitOn
                let changedElement =
                    (
                    origin: [withoutSitOn[sitOnIndex].origin.removeFirst()],
                    ids: [withoutSitOn[sitOnIndex].ids.removeFirst()],
                    nodes: [withoutSitOn[sitOnIndex].nodes.removeFirst()])
                withoutSitOn[sitOnIndex] = changedElement
                return withoutSitOn
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



