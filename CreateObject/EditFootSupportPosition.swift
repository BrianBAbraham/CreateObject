//
//  EditFootSupportPosition.swift
//  CreateObject
//
//  Created by Brian Abraham on 12/04/2023.
//

import SwiftUI

struct EditFootSupportPosition: View {
  
    let dictionary: PositionDictionary

    @State private var leftAndRight = true
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel

    
    init(
        _ dictionaryForMeasurement: PositionDictionary){
        dictionary = dictionaryForMeasurement
    }
    
    var body: some View {
        
        let toggleLabel =  leftAndRight ? "R = L": "R ≠ L"
       
        VStack{
            Text( objectPickVM.getCurrentObjectName())
            Spacer()
        
            Toggle(toggleLabel,isOn: $leftAndRight)
                .onChange(of: leftAndRight) { value in
                }
                .padding(.horizontal)

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
    let curentDictionary: PositionDictionary
    @State private var proposedLength = 200.0
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    
    let leftOrRight: String
    let idInt: Int
    let id: Part
    let idToIdIntDictionary = [Part.id: 0, Part.id0: 0, Part.id1: 1]
    
    init(
        _ dictionaryForMeasurement: PositionDictionary,
        _ leftOrRight: String,
        _ id: Part){
        curentDictionary = dictionaryForMeasurement
        self.leftOrRight = leftOrRight
        self.id = id
        self.idInt = idToIdIntDictionary[id]!
    }
    
    var body: some View {
        var editedDictionary: PositionDictionary = [:]
        
        let currentLength =
        Measurement(
            value: objectEditVM.getPrimaryAxisToFootPlateEndLength(
                dictionary: objectPickVM.getCurrentObjectDictionary(),
            name: "slider"
        ) [idInt], unit: UnitLength.millimeters)
        
        let defaultDictionary = objectPickVM.getDefaultObjectDictionary()
        
        let minToMax = objectEditVM.getPrimaryAxisToFootPlateEndExtrema(defaultDictionary, curentDictionary)
        
        let displayLength = String(format: "%.0f",currentLength.value)
        //String(format: "%.1f", currentLength.converted(to: UnitLength.inches).value) + "\""
        
        let boundLength = Binding(
            get: {currentLength.value},
            set: {self.proposedLength = $0}
        )
        
        HStack {
            Text(leftOrRight)
            Slider(value: boundLength, in: minToMax, step: 1
            )
            .onChange(of: proposedLength) { value in
                editedDictionary =
                objectEditVM.setPrimaryToFootPlateFrontLength(
                    curentDictionary,
                   id,
                    proposedLength - currentLength.value
                )
                objectPickVM.setCurrentObjectDictionary(
                    objectPickVM.getCurrentObjectName(),
                    editedDictionary)
            }
            Text(displayLength)
        }
        .padding(.horizontal)
    }
}





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
