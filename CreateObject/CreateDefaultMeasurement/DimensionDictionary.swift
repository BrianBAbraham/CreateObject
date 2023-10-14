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
    case tiltInSpace
}

/// it is acknowledged that the use of nodes, an array of parts in order from object to part repeated to end of node chairn
/// creates a duplication since for example many parts have sitOn as a parent and therefore the sitOn dimension is created but
/// adds no further elments to the dicitionary as it alreay exists
/// However, this keeps the node chains intact
struct DimensionDictionary {
    var forPart: Part3DimensionDictionary = [:]
    
    
    init(
        _ originIdNodes: [OriginIdPartChain],
        _ defaultDimensions: [Dimension3d],
        _ dimensionIn: Part3DimensionDictionary,
        _ sitOnIndex: Int) {
            
        let sitOnId: Part = [.id0,.id1][sitOnIndex]
        let parts = originIdNodes[sitOnIndex].chain
//print(defaultDimensions)
//print(parts)
//print(parts.count)
        for partIndex in 0..<parts.count  {
            let idsForPart: [Part] = originIdNodes[sitOnIndex].ids[partIndex]
            for partIdIndex in  0..<idsForPart.count {
        
                let nameStart: [Part] =
                [.object, .id0, .stringLink]
                
                let nameEnd: [Part] = parts[partIndex] == .sitOn ?
                    [sitOnId, .stringLink, .sitOn, sitOnId] : [idsForPart[partIdIndex], .stringLink, .sitOn, sitOnId]
                if parts == LabelInPartChainOut.sitOnTiltJoint {
                 
                }
                let x = nameStart + [ parts[partIndex]] + nameEnd
                let partName = CreateNameFromParts(x).name
                let dimension = dimensionIn[partName] ?? defaultDimensions[partIndex]
                self.forPart +=
                [partName: dimension ]
            }
        }
    }
}


//MARK: GET DIMENSIONS
//retrieves a passed value if extant else a default value
struct OccupantSupportDimensionDictionary {
    let parent: DictionaryProvider

    let preTiltWheelOrigin:
        DictionaryProvider.PreTiltWheelOrigin?
    let allWheelRelated: AllWheelRelated
    
    var forBody:  Part3DimensionDictionary = [:]

    var forWheels: Part3DimensionDictionary = [:]
    var forTiltInSpace: Part3DimensionDictionary = [:]

    
    init(
        parent: DictionaryProvider) {
            self.parent = parent
            allWheelRelated =
                 AllWheelRelated(
                     parent.objectType)
            


        preTiltWheelOrigin =
            parent.preTiltWheelOrigin as? DictionaryProvider.PreTiltWheelOrigin
            
        let preTiltBodySupportOrigin =
                parent.preTiltOccupantBodySupportOrigin as?
                DictionaryProvider.PreTiltOccupantBodySupportOrigin
            
        for index in 0..<parent.oneOrTwoIds.count {

                

            if let preTiltBodySupportOrigin {
                let dimension = OccupantBodySupportDefaultDimension(parent.objectType).value
                forBody +=
                DimensionDictionary(
                    preTiltBodySupportOrigin.allOriginIdPartChain[index],
                    [dimension, dimension],
                    parent.dimensionDicIn,
                    index).forPart
            }
        }
        
        forWheels += getDictionaryForWheel(.rearWheel)
        if BaseObjectGroups().sixWheels.contains(parent.objectType) {
            forWheels += getDictionaryForWheel(.midWheel)
        }
        forWheels += getDictionaryForWheel(.frontWheel)
    }
    
    func getDictionaryForWheel (
        _ dimensionGroup: DimensionGroup)
        -> Part3DimensionDictionary{
        let onlyOneWheelSet = 0
        var dimensions: [Dimension3d] = []
        let originIdNodes = getOriginIdNodesForWheel(dimensionGroup)
        switch dimensionGroup {
        case .rearWheel:
            dimensions =  allWheelRelated.defaultRearMidFrontDimension.rear
        case .midWheel:
            dimensions =  allWheelRelated.defaultRearMidFrontDimension.mid
        case .frontWheel:
            dimensions =  allWheelRelated.defaultRearMidFrontDimension.front

            
            
        default: break
        }
        return
            DimensionDictionary(
                [originIdNodes],
                dimensions,
                parent.dimensionDicIn,
                onlyOneWheelSet
            ).forPart
    }
    
    
    func getOriginIdNodesForWheel (
        _ dimensionGroup: DimensionGroup)
        -> OriginIdPartChain {
        var originIdNode:OriginIdPartChain = ZeroValue.originIdPartChain
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
}



