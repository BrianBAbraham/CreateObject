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
//    static let backSupportHeight =
//        InitialOccupantBackSupportMeasurement.backSupportHeight
//    static let fromBackSupportTopToHeadSupport =
//        (x: 0, y: backSupportHeight/2 , z: 0.0)
//    static let headSupportHeight =
//        InitialOccupantBackSupportMeasurement.backSupportHeight +
//        200.0
}







struct CreateOccupantHeadSupport {

    var dictionary: PositionDictionary = [:]
    let supportIndex: Int
    
    init(
        _ parentFromPrimaryOrigin: [PositionAsIosAxes],
        _ supportIndex: Int,
        _ objectOptions: OptionDictionary
        ) {
            
        let headSupportMeasurement = InitialOccupantHeadSupportMeasurement.headSupport
        let headSupporLinkMeasurement = InitialOccupantHeadSupportMeasurement.headSupportLink
            
        let headSupportFromParentOrigin =
            getPartFromParentOrigin(
                objectOptions,
                .headSupport)
            
        let headSupportLinkFromParentOrigin =
            getPartFromParentOrigin(
                objectOptions,
                .headSupportLink)
        
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
                case .headSupport:
                    let headSupportHalfLength =
                        headSupportMeasurement.length/2
                    lengths = [headSupportHalfLength, gapLlength, backSupportHalfLength]
                case .headSupportLink:
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
                        .headSupport,
                        parentFromPrimaryOrigin[supportIndex],
                        headSupportFromParentOrigin,
                        supportIndex)

                let headSupportLinkDictionary =
                    CreateOnePartOrSideSymmetricParts(
                        headSupporLinkMeasurement,
                        .headSupportLink,
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
