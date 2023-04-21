//
//  EditFootSupportPosition.swift
//  CreateObject
//
//  Created by Brian Abraham on 12/04/2023.
//

import SwiftUI

struct EditFootSupportPosition: View {
  
    //var objectLength: Double = 0.0
    let dictionary: PositionDictionary
    @State private var proposedWidth = 100.0
    @State private var proposedLeftLength = 200.0
    @State private var proposedRightLength = 200.0
    @State private var showLeftLength = true
    @State private var leftAndRight = true
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    
    init(_ dictionary: PositionDictionary){
        self.dictionary = dictionary
    }
    
    
    var body: some View {
        
        let currentLength =
        objectEditVM.getPrimaryAxisToFootPlateEndLength(
            objectPickVM.getCurrentDictionary()
        )
        
        
//        let boundWidth = Binding(
//            get: {0},
//            set: {self.proposedWidth = $0}
//        )
 
        
//        let boundLeftLength = Binding(
//            get: {currentLength[0]},
//            set: {self.proposedLeftLength = $0}
//        )
//        let boundRightLength = Binding(
//            get: {currentLength[1]},
//            set: {self.proposedRightLength = $0}
//        )
        
//var editedDictionary: PositionDictionary = [:]
        var toggleLabel =  leftAndRight ? "R = L": "R ≠ L"
        
        VStack{
            Spacer()
           // VStack {
            Toggle(toggleLabel,isOn: $leftAndRight)
                .onChange(of: leftAndRight) { value in
                    // set both footplate to the foot plate with maximum length
                }
            //{}
                

            if leftAndRight {
                FootLengthSlider(dictionary,"L",.id)
            } else {
                FootLengthSlider(dictionary,"L",.id0)
                FootLengthSlider(dictionary,"R",.id1)
            }
          
        }

    }
       
}


struct FootLengthSlider: View {
    let dictionary: PositionDictionary
    @State private var proposedLength = 200.0
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    
    let leftOrRight: String
    let idInt: Int
    let id: Part
    let idToIdIntDictionary = [Part.id: 0, Part.id0: 0, Part.id1: 1]    // id0 0
// id1 1
    //id 0
    
    init(
        _ dictionary: PositionDictionary,
        _ leftOrRight: String,
        _ id: Part){
        self.dictionary = dictionary
        self.leftOrRight = leftOrRight
        self.id = id
        self.idInt = idToIdIntDictionary[id]!
    }
    
    var body: some View {
        var editedDictionary: PositionDictionary = [:]
        
        let currentLength =
        Measurement(value:
        objectEditVM.getPrimaryAxisToFootPlateEndLength(
            objectPickVM.getCurrentDictionary()
        ) [idInt], unit: UnitLength.millimeters)
        
        let displayLength = String(format: "%.0f",currentLength.value)
        //String(format: "%.1f", currentLength.converted(to: UnitLength.inches).value) + "\""
        
        let boundLength = Binding(
            get: {currentLength.value},
            set: {self.proposedLength = $0}
        )
        
        HStack {
            Text(leftOrRight)
            Slider(value: boundLength, in: 500.0...1500.0, step: 1
            )
            .onChange(of: proposedLength) { value in
                editedDictionary =
                objectEditVM.setPrimaryToFootPlateFrontLength(
                    dictionary,
                   id,
                    proposedLength - currentLength.value
                )
                objectPickVM.setObjectDictionary(
                    objectPickVM.getCurrentObjectType(),
                    editedDictionary)
            }
            Text(displayLength)
        }
    }
        //.padding([.leading, .trailing])
}




//struct FeetLengthSlider: View {
//    let dictionary: PositionDictionary
//    @State private var proposedLength = 200.0
//    @EnvironmentObject var objectPickVM: ObjectPickViewModel
//    @EnvironmentObject var objectEditVM: ObjectEditViewModel
//
//    let leftOrRight: String
//    let id: Int
//
//
//    init(
//        _ dictionary: PositionDictionary,
//        _ leftOrRight: String,
//        _ id: Int){
//        self.dictionary = dictionary
//        self.leftOrRight = leftOrRight
//        self.id = id
//    }
//
//    var body: some View {
//       var editedDictionary: PositionDictionary = [:]
//
//        let currentLength =
//        objectEditVM.getPrimaryAxisToFootPlateEndLength(
//            objectPickVM.getCurrentDictionary()
//        )
//
//        let boundLength = Binding(
//            get: {currentLength[id]},
//            set: {self.proposedLength = $0}
//        )
//
//        HStack {
//            Text(leftOrRight)
//            Slider(value: boundLength, in: 500.0...1500.0, step: 1
//            )
//            .onChange(of: proposedLength) { value in
//                editedDictionary =
//                objectEditVM.setPrimaryToFootPlateFrontLength(
//                    dictionary,
//                    .id,//[.id0, .id1][id],
//                    proposedLength - currentLength[id]
//                )
//                objectPickVM.setObjectDictionary(
//                    objectPickVM.getCurrentObjectType(),
//                    editedDictionary)
//            }
//         Text("\(Int(currentLength[id]))")
//        }
//        //.padding([.leading, .trailing])
//
//    }
//}


//struct EditFootSupportPosition_Previews: PreviewProvider {
//
//    static var previews: some View {
//
//
//                let dictionary = objectPickVM.getRelevantDictionary(.forMeasurement)
//        EditFootSupportPosition(dictionary)
//            .environmentObject(ObjectPickViewModel())
//    }
//}
