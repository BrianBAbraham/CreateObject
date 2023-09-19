//
//  Tilt.swift
//  CreateObject
//
//  Created by Brian Abraham on 05/09/2023.
//

import Foundation


struct ObjectToCornersPostTilt{
    let objectToPartPostTilt: PositionDictionary = [:]
    let partToCornersPostTilt: PositionDictionary = [:]
    let objectToCornersPostTiltForTopView: PositionDictionary = [:]
    let objecToCornersPostTitleForSideView: PositionDictionary = [:]
    
    init () {
        
    }
}

/// Dimension3/angle/ in -> corners out
/// Rotation centre choice is irrelevant to results
/// Cubiod centre is chosen
/// Rotation is about -x -- x axis of IOS position
/// Corners are as 'Corners quick help'
struct PartToCornersPostTilt {
    let dimensionIn: Dimension3d
    let angleChangeIn: Measurement<UnitAngle>
    var areInitially: [PositionAsIosAxes] {
        CreateIosPosition.getCornersFromDimension( dimensionIn) }
    var aferRotationAre: [PositionAsIosAxes] {
        calculatePositionAfterRotation(areInitially, angleChangeIn)
    }

    
    func calculatePositionAfterRotation(
        _ corners: [PositionAsIosAxes],
        _ angleChange: Measurement<UnitAngle>)
        -> [PositionAsIosAxes] {
        var rotatedCorners: [PositionAsIosAxes] = []
        
        let cuboidCentre = ZeroValue.iosLocation
        for corner in corners {
            rotatedCorners.append(
                PositionOfPointAfterRotationAboutPoint(
                    staticPoint: cuboidCentre,
                    movingPoint: corner,
                    angleChange: angleChange).fromStaticToPointWhichHasMoved )
        }
        return rotatedCorners
    }

}



//MARK: ORIGIN POST TILT
struct OriginPostTilt {
    var forObjectToPartOrigin: PositionDictionary = [:]
    var forDimension: Part3DimensionDictionary = [:]

    init(
        parent: DimensionOriginCornerDictionaries ) {
        for sitOnId in parent.oneOrTwoIds {
            let tiltOriginPart: [Part] =
                [.object, .id0, .stringLink, .bodySupportRotationJoint, .id0, .stringLink, .sitOn, sitOnId]
            let originOfRotationName =
                CreateNameFromParts(tiltOriginPart).name
            let angleName =
                CreateNameFromParts([.bodySupportAngle, .stringLink, .sitOn, sitOnId]).name

            if let originOfRotation = parent.preTiltObjectToPartOrigin[originOfRotationName] {
                let angleChange =
                    parent.angle[angleName] ??
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
        _ parent: DimensionOriginCornerDictionaries,
        _ originOfRotation: PositionAsIosAxes,
        _ changeOfAngle: Measurement<UnitAngle>,
        _ sitOnId: Part) {
            
        let allPartsSubjectToAngle = TiltGroupsFor().allAngle
        let partsOnLeftAndRight = TiltGroupsFor().leftAndRight
        
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
    
    // MARK: - write code
    mutating func forSitOnWithoutFootTilt() {}
    
    mutating func forBackRecline (
         _ parent: DimensionOriginCornerDictionaries,
         _ originOfRotation: PositionAsIosAxes,
         _ changeOfAngle: Measurement<UnitAngle>,
         _ sitOnId: Part) {
             
         let allPartsSubjectToAngle = TiltGroupsFor().backAndHead
         let partsOnLeftAndRight = TiltGroupsFor().leftAndRight
         
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
    
    // MARK: - write code
    mutating func forHeadSupport(){}
}
