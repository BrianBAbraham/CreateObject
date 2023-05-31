//
//  EditFootSupportPosition.swift
//  CreateObject
//
//  Created by Brian Abraham on 12/04/2023.
//

import SwiftUI

struct EditFootSupportLeftRightPosition: View {
  
    let dictionary: PositionDictionary

    @State private var leftAndRight = true
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var  twinSitOnVM: TwinSitOnViewModel

    
    init(
        _ dictionaryForMeasurement: PositionDictionary){
        dictionary = dictionaryForMeasurement
    }
    
    var body: some View {
       
        let toggleLabel =  leftAndRight ? "R = L": "R ≠ L"
       
        VStack{
           
            Spacer()

            TwinSitOnSelection()
            
            Toggle(toggleLabel,isOn: $leftAndRight)
                .onChange(of: leftAndRight) { value in
                }
                .padding(.horizontal)

            if leftAndRight {
                FootSupportWithHangerLinkLengthSlider(dictionary,"L",.id, .footSupport)
            } else {
                FootSupportWithHangerLinkLengthSlider(dictionary,"L",.id0, .footSupport)
                FootSupportWithHangerLinkLengthSlider(dictionary,"R",.id1, .footSupport)
            }
        }
    }
}




struct TwinSitOnSelection: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var twinSitOnVM: TwinSitOnViewModel

    var name: String {
        objectPickVM.getCurrentObjectName()
    }

    var options: [TwinSitOnOption] {
        twinSitOnVM.getTwinSitOnConfiguration()  //TWIN
    }


    var body: some View {

        if (name.contains("wheelchair") ? true: false) &&
            twinSitOnVM.getState() {
            ExclusiveToggles(
                twinSitOnVM.getManyState(options),
                options,
                .sitOnPosition)
        } else {
            EmptyView()
        }
    }
}

struct EditFootSupportWithHangerInOnePiecePosition: View {
    let dictionary: PositionDictionary
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
  
    
    init(
        _ dictionaryForMeasurement: PositionDictionary
    ) {
        dictionary = dictionaryForMeasurement
    }
    
    var body: some View {
        FootSupportWithHangerLinkLengthSlider(dictionary,"length",.id, .footSupportInOnePiece)
    }
}


struct FootSupportWithoutHangerInOnePieceSlider: View {
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
   // let displayLength: String
    @State private var proposedLength = 0.0
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var  twinSitOnVM: TwinSitOnViewModel
    let curentDictionary: PositionDictionary

    
    init(_ currentDictionary: PositionDictionary){
 
        self.curentDictionary = currentDictionary
    }
    
    var body: some View {
        let sitOnId = twinSitOnVM.getSitOnId()
        
        let currentLength =
            Measurement(
                value: objectEditVM.getPrimaryAxisToFootSupportEndLength(
                    dictionary: self.curentDictionary,
                    name: "slider",
                    part: .footSupportInOnePiece,
                    Part.id0
            ) [0], unit: UnitLength.millimeters)
   
        
        var editedDictionary: PositionDictionary = [:]
        
        let defaultDictionary = objectPickVM.getDefaultObjectDictionary()
        
         let displayLength = String(format: "%.0f",currentLength.value)
        

        
        let minToMax = objectEditVM.getPrimaryAxisToFootSupportEndExtrema(
            defaultDictionary,
            curentDictionary,
            .footSupportInOnePiece,
            sitOnId)
        
        let boundLength = Binding(
            get: {currentLength.value},
            set: {self.proposedLength = $0}
        )
        
        HStack {
            Text("length")
            Slider(value: boundLength, in: minToMax, step: 100
            )
            .onChange(of: proposedLength) { value in

                editedDictionary =
                objectEditVM.setPrimaryToFootSupportFrontLengthWhenNoFootHanger(
                    curentDictionary,
                    .id0,
                    proposedLength - currentLength.value
                )
                objectPickVM.editCurrentMeasurements(.footSupport, .foot, (length: proposedLength, width: 900))
                
                objectPickVM.setCurrentObjectWithDefaultOrEditedDictionary(
                    objectPickVM.getCurrentObjectName(),
                    editedDictionary
                )
                
                //experimental

                
                
            }
            Text(displayLength)
        }
        .padding(.horizontal)
    }
      
}

struct FootSupportWithHangerLinkLengthSlider: View {
    let curentDictionary: PositionDictionary
    @State private var proposedLength = 0.0
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var  twinSitOnVM: TwinSitOnViewModel
    
    let leftOrRight: String
    let idIntForSide: Int
    let idForSide: Part
    let idToIdIntDictionary = [Part.id: 0, Part.id0: 0, Part.id1: 1]
    let onePieceOrLeftRightFootSupport: Part
 
    
    init(
        _ dictionaryForMeasurement: PositionDictionary,
        _ leftOrRight: String,
        _ id: Part,
        _ part: Part){
            
        curentDictionary = dictionaryForMeasurement
        self.leftOrRight = leftOrRight
        self.idForSide = id
        self.idIntForSide = idToIdIntDictionary[id]!
        onePieceOrLeftRightFootSupport = part
       
    }
    
    var body: some View {
       // let curentDictionary = objectPickVM.getCurrentObjectDictionary()
        var editedDictionary: PositionDictionary = [:]
        let sitOnId = twinSitOnVM.getSitOnId()
        let currentLength =
        Measurement(
            value: objectEditVM.getPrimaryAxisToFootSupportEndLength(
                dictionary: objectPickVM.getCurrentObjectDictionary(),
                name: "slider",
                part: onePieceOrLeftRightFootSupport,
                sitOnId
                ) [idIntForSide],
            unit: UnitLength.millimeters)
        
        let defaultDictionary = objectPickVM.getDefaultObjectDictionary()
        
        let minToMax =
            objectEditVM.getPrimaryAxisToFootSupportEndExtrema(
                defaultDictionary,
                curentDictionary,
                onePieceOrLeftRightFootSupport,
                sitOnId)
        
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

                //print("proposed: \(Int(proposedLength)) current: \(Int(currentLength.value))  \(idForSide.rawValue)")
                editedDictionary =
                    objectEditVM.setPrimaryToFootSupportWithHangerFrontLength(
                        curentDictionary,
                        idForSide,
                        proposedLength - currentLength.value,
                        sitOnId)
                
               
                
                objectPickVM.setCurrentObjectWithDefaultOrEditedDictionary(
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
