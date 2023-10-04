//
//  LeftAndRightOrigin.swift
//  CreateObject
//
//  Created by Brian Abraham on 12/09/2023.
//

import Foundation

struct LeftAndRightOrigin {
    let names: [String]
    let rightAndUnilateralOrigin: [PositionAsIosAxes]
    let partIds: [[Part]]
    var left:
        [PositionAsIosAxes] {
            getLeftOrigin()
        }
    var right:
        [PositionAsIosAxes] {
            getLeftOrigin()
        }
    var all: [PositionAsIosAxes] {
        rightAndUnilateralOrigin + left
    }

    func getLeftOrigin ()
        -> [PositionAsIosAxes] {
print (names)
        var leftOrigin: [PositionAsIosAxes] = []
        for index in 0..<rightAndUnilateralOrigin.count {
            if partIds[index].count == 2 {
                let left = CreateIosPosition.getLeftFromRight(rightAndUnilateralOrigin[index])
                leftOrigin.append(left)
            } else {
                
                if partIds[index] == [.id0] {
                    print ("detection")
                let left =
                    CreateIosPosition.getLeftFromRight(rightAndUnilateralOrigin[index])
                    print (left)
                    print ("")
                    leftOrigin.append(left)
                } else {
                    /// this adds redundant right values since values
                    /// after the final occurance of a partIds element == 2
                    /// are not used when assigned to the dictionary but this
                    /// save coding
                    leftOrigin.append(rightAndUnilateralOrigin[index])
                }
            }
        }
        return leftOrigin
    }
}
