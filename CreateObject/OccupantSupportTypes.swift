//
//  OccupantSupportTypes.swift
//  CreateObject
//
//  Created by Brian Abraham on 10/01/2023.
//

import Foundation

//protocol OccupantSupport {}
//
//struct Seat: OccupantSupport, Equatable {
//    let subtype: Subtype
//    enum Subtype {
//        case standard
//        case tilting
//        case reclining
//    }
//    init (_ subtype: Subtype) {
//        self.subtype = subtype
//    }
//}
//
//struct Stand: OccupantSupport, Equatable {
//    let subtype: Subtype
//    enum Subtype {
//        case perching
//        case standing
//    }
//    init (_ subtype: Subtype) {
//        self.subtype = subtype
//    }
//}
//
//struct Sling: OccupantSupport, Equatable {
//    let subtype: Subtype
//    enum Subtype {
//        case reclining
//        case sitting
//        case stretcher
//
//    }
//    init (_ subtype: Subtype) {
//        self.subtype = subtype
//    }
//}

//enum LeftRightSymmetry {
//    case left
//    case leftAndRight
//    case none
//    case one
//    case right
//}

enum OccupantSupportNumber {
    case one
    case twoSideBySide
    case twoFrontAndBack
}

enum OccupantSupportTypes {
    case seatedStandard
    case seatedReclining
    case seatedTilting
    
    case standingPerched
    case standingStandard
    
    case slingReclining
    case slingSeated
    case slingStreatcher
    
}


