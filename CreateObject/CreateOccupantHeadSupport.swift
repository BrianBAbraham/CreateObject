//
//  CreateOccupantHeadSupport.swift
//  CreateObject
//
//  Created by Brian Abraham on 26/05/2023.
//

import Foundation

struct InitialOccupantHeadSupportMeasurement {
    
    static let headSupport = (length: 100.0, width: 200.0)
    static let headSupportLink = (length: 200.0, width: 30.0)
    static let headBackSupportHeightGap = 100.0
    static let headTopAboveBackSupport =
        headSupport.length + headBackSupportHeightGap
}







struct CreateOccupantHeadSupport {

    var dictionary: PositionDictionary = [:]
    let supportIndex: Int
    
    init(
        _ parentFromPrimaryOrigin: [PositionAsIosAxes],
        _ supportIndex: Int,
        _ objectOptions: OptionDictionary,
        _ defaultDictionary: Part3DimensionDictionary
        ) {
            
            let sitOnId: Part = [.id0, .id1][supportIndex]
        
        let headSupportMeasurement =
            DimensionChange(
            GetDimensionFromDictionary(
                defaultDictionary,
                [ .backSupportHeadSupport, .id0, .stringLink, .sitOn, sitOnId]
            ).dimension3D ).from3Dto2D
            //InitialOccupantHeadSupportMeasurement.headSupport
        
        let headSupporLinkMeasurement = InitialOccupantHeadSupportMeasurement.headSupportLink
            
        let headSupportFromParentOrigin =
            getPartFromParentOrigin(
                objectOptions,
                .backSupportHeadSupport)
            
        let headSupportLinkFromParentOrigin =
            getPartFromParentOrigin(
                objectOptions,
                .backSupportHeadSupportLink)
        
        self.supportIndex = supportIndex

        getDictionary(
            supportIndex,
            parentFromPrimaryOrigin
        )
            
        func getPartFromParentOrigin (
            _ objectOptions: OptionDictionary,
            _ part: Part )
            -> PositionAsIosAxes {
                
            let backSupportLengthFromPrimaryOrigin =
                InitialOccupantBackSupportMeasurement(objectOptions).backSupportFromParentOrigin.y
            let gapLlength =
                InitialOccupantHeadSupportMeasurement.headBackSupportHeightGap
            let backSupportHalfLength =
                InitialOccupantBackSupportMeasurement.backSupportHeight/2
            var lengths: [Double] = []
            
            switch part {
                case .backSupportHeadSupport:
                    let headSupportHalfLength =
                        headSupportMeasurement.length/2
                    lengths = [headSupportHalfLength, gapLlength, backSupportHalfLength]
                case .backSupportHeadSupportLink:
                    let linkHalfLength = InitialOccupantHeadSupportMeasurement.headSupportLink.length/2
                    lengths = [linkHalfLength, backSupportHalfLength]
                default :
                    break
            }
            let yLength = lengths.reduce(0, +)
//print(lengths)
            let yLengthWithTilt =
                objectOptions[.reclinedBackSupport] ?? false ?
                Tilted(InitialOccupantBackSupportMeasurement.maximumBackSupportRecline).factor * yLength:
                Tilted(InitialOccupantBackSupportMeasurement.minimumBackSupportRecline).factor * yLength
            let yFinalLength = backSupportLengthFromPrimaryOrigin - yLengthWithTilt
                return
                    (x: 0.0, y: yFinalLength , z: 0.0 )
        }
            
            
            func getDictionary(
                _ supportIndex: Int,
                _ parentFromPrimaryOrigin: [PositionAsIosAxes]

                ) {
//print(parentFromPrimaryOrigin)
//print(partFromParentOrigin)
//print("")
                    
                let headSupportDictionary =
                    CreateOnePartOrSideSymmetricParts(
                       headSupportMeasurement,
                        .backSupportHeadSupport,
                        parentFromPrimaryOrigin[supportIndex],
                        headSupportFromParentOrigin,
                        supportIndex)

                let headSupportLinkDictionary =
                    CreateOnePartOrSideSymmetricParts(
                        headSupporLinkMeasurement,
                        .backSupportHeadSupportLink,
                        parentFromPrimaryOrigin[supportIndex],
                        headSupportLinkFromParentOrigin,
                        supportIndex)
                    
//               let headSupportJointDictionary =
//                    CreateOnePartOrSideSymmetricParts(
//                        measurementFor.backSupportJoint,
//                        .headSupportJoint,
//                        parentFromPrimaryOrigin[supportIndex],
//                        measurementFor.backSupportJointFromParentOrigin,
//                        supportIndex)

                dictionary =
                    Merge.these.dictionaries([
                        //headSupportJointDictionary.cornerDictionary,
                        headSupportDictionary.cornerDictionary,
                        headSupportDictionary.originDictionary,
                        headSupportLinkDictionary.cornerDictionary,
                        headSupportLinkDictionary.originDictionary
                    ])

            }
            
            
    }
    

    


    
}
