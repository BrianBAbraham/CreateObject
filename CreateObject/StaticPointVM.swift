//
//  StaticPointVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 04/05/2024.
//

//import Foundation
//import Combine
//
//class StaticPointViewModel: ObservableObject {
//    
//    
//    @Published var staticPoint: PositionAsIosAxes = ZeroValue.iosLocation
//    
//    var staticPointUpdate: PositionAsIosAxes = ZeroValue.iosLocation {
//        didSet {
//            movementImageData = getMovementImageData()
//        }
//    }
//    
//    //EXTRACTIONS FROM DATA LAYER
//    //intialise movement data
//    //movement are single object data plus transformed object data
//    //showing movment or movments
//    @Published private var movementImageData = MovementImageData (
//        ObjectImageService.shared.objectImageData,//object data
//        movementType: .turn, //transform data
//        staticPoint: ZeroValue.iosLocation, //transform data
//        startAngle: 0.0, //transform data
//        endAngle: 0.0, //transform data
//        forward: 0.0 //transform data
//    )
//    
//    init(){
//        
//    }
//    
//    
//    func getMovementImageData() -> MovementImageData{
//        let movementImageData =
//        MovementImageData(
//            objectImageData,
//            movementType: movementType,
//            staticPoint: staticPointUpdate,
//            startAngle: startAngle,
//            endAngle: endAngle,
//            forward: forward
//        )
//        return movementImageData
//    }
//}
