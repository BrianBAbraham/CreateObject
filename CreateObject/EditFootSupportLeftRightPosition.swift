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
   // @EnvironmentObject var objectEditVM: ObjectEditViewModel

    
    init(
        _ dictionaryForMeasurement: PositionDictionary){
        dictionary = dictionaryForMeasurement
    }
    
    var body: some View {
        
        let toggleLabel =  leftAndRight ? "R = L": "R ≠ L"
       
        VStack{
           
            Spacer()
            
           // DoubleSeatSelection()
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

//struct DoubleSeatSelection: View {
//    @EnvironmentObject var objectPickVM: ObjectPickViewModel
//    @EnvironmentObject var twinSitOnVM: TwinSitOnViewModel
//    
//    var name: String {
//        objectPickVM.getCurrentObjectName()
//    }
//    
//    var options: [ObjectOptions] {
//        getDoubleSeatLayoutOptions() //TWIN
//    }
//    
//    var options2: [TwinSitOnOption] {
//        twinSitOnVM.getTwinSitOnConfiguration()  //TWIN
//    }
//    var options2states: [Bool] {
//        twinSitOnVM.getManyState(options2) //TWIN
//    }
//  
//    func getDoubleSeatLayoutOptions() //TWIN
//    -> [ObjectOptions] {
//        
//        var options:[ObjectOptions] = []
//        if objectPickVM.getObjectOptionDictionary(ObjectOptions.doubleSitOnFrontAndRear) {
//            options =
//            [ObjectOptions.doubleSitOnFront, ObjectOptions.doubleSitOnRear]
//        }
//        
//        if objectPickVM.getObjectOptionDictionary(ObjectOptions.doubleSitOnLeftAndRight) {
//            options =
//            [ObjectOptions.doubleSitOnLeft, ObjectOptions.doubleSitOnRight]
//        }
//        return options
//    }
//    
//    var body: some View {
//        // && twinSitOnVM.getState  //TWIN
//        
//        // option2states // TWIN
//        //option2 //TWIN
//        if (name.contains("wheelchair") ? true: false) &&
//            objectPickVM.getCurrentOptionThereAreDoubleSitOn() {
//            ExclusiveToggles(
//                objectPickVM.getCurrentOptionState(options),
//                options,
//                .sitOnChoice)
//        } else {
//            EmptyView()
//        }
//    }
//}


struct TwinSitOnSelection: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var twinSitOnVM: TwinSitOnViewModel

    var name: String {
        objectPickVM.getCurrentObjectName()
    }

//    var options: [ObjectOptions] {
//        getDoubleSeatLayoutOptions() //TWIN
//    }

    var options2: [TwinSitOnOption] {
        twinSitOnVM.getTwinSitOnConfiguration()  //TWIN
    }
    var options2states: [Bool] {
        twinSitOnVM.getManyState(options2) //TWIN
    }

//    func getDoubleSeatLayoutOptions() //TWIN
//    -> [ObjectOptions] {
//
//        var options:[ObjectOptions] = []
//        if objectPickVM.getObjectOptionDictionary(ObjectOptions.doubleSitOnFrontAndRear) {
//            options =
//            [ObjectOptions.doubleSitOnFront, ObjectOptions.doubleSitOnRear]
//        }
//
//        if objectPickVM.getObjectOptionDictionary(ObjectOptions.doubleSitOnLeftAndRight) {
//            options =
//            [ObjectOptions.doubleSitOnLeft, ObjectOptions.doubleSitOnRight]
//        }
//        return options
//    }

    var body: some View {
        // && twinSitOnVM.getState  //TWIN

        // option2states // TWIN
        //option2 //TWIN
        if (name.contains("wheelchair") ? true: false) &&
            twinSitOnVM.getState("TwinSitOnSelectiion calling")
            //objectPickVM.getCurrentOptionThereAreDoubleSitOn()
        {
            ExclusiveToggles(
                twinSitOnVM.getManyState(options2),
                //objectPickVM.getCurrentOptionState(options2),
                options2,
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
    let curentDictionary: PositionDictionary

    
    init(_ currentDictionary: PositionDictionary){
 
        self.curentDictionary = currentDictionary
    }
    
    var body: some View {
        
        
        let currentLength =
            Measurement(
                value: objectEditVM.getPrimaryAxisToFootSupportEndLength(
                    dictionary: self.curentDictionary,
                    name: "slider",
                    part: .footSupportInOnePiece
            ) [0], unit: UnitLength.millimeters)
   
        
        var editedDictionary: PositionDictionary = [:]
        
        let defaultDictionary = objectPickVM.getDefaultObjectDictionary()
        
         let displayLength = String(format: "%.0f",currentLength.value)
        

        
        let minToMax = objectEditVM.getPrimaryAxisToFootSupportEndExtrema(
            defaultDictionary,
            curentDictionary,
            .footSupportInOnePiece)
        
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

                objectPickVM.setCurrentObjectDictionary(
                    objectPickVM.getCurrentObjectName(),
                    editedDictionary)
            }
            Text(displayLength)
        }
        .padding(.horizontal)
    }
      
}

struct FootSupportWithHangerLinkLengthSlider: View {
    let curentDictionary: PositionDictionary
    @State private var proposedLength = 200.0
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    
    let leftOrRight: String
    let idInt: Int
    let id: Part
    let idToIdIntDictionary = [Part.id: 0, Part.id0: 0, Part.id1: 1]
    let onePieceOrLeftRightFootSupport: Part
    
    init(
        _ dictionaryForMeasurement: PositionDictionary,
        _ leftOrRight: String,
        _ id: Part,
        _ part: Part){
        curentDictionary = dictionaryForMeasurement
        self.leftOrRight = leftOrRight
        self.id = id
        self.idInt = idToIdIntDictionary[id]!
        onePieceOrLeftRightFootSupport = part
    }
    
    var body: some View {
        var editedDictionary: PositionDictionary = [:]
        
        let currentLength =
        Measurement(
            value: objectEditVM.getPrimaryAxisToFootSupportEndLength(
                dictionary: objectPickVM.getCurrentObjectDictionary(),
                name: "slider",
                part: onePieceOrLeftRightFootSupport
        ) [idInt], unit: UnitLength.millimeters)
        
        let defaultDictionary = objectPickVM.getDefaultObjectDictionary()
        
        let minToMax =
            objectEditVM.getPrimaryAxisToFootSupportEndExtrema(
                defaultDictionary,
                curentDictionary,
                onePieceOrLeftRightFootSupport)
        
        let displayLength = String(format: "%.0f",currentLength.value)
        //String(format: "%.1f", currentLength.converted(to: UnitLength.inches).value) + "\""
        
        let boundLength = Binding(
            get: {currentLength.value},
            set: {self.proposedLength = $0}
        )
        
        HStack {
            Text(leftOrRight)
            Slider(value: boundLength, in: minToMax, step: 5
            )
            .onChange(of: proposedLength) { value in
                editedDictionary =
                    objectEditVM.setPrimaryToFootSupportWithHangerFrontLength(
                        curentDictionary,
                        id,
                        proposedLength - currentLength.value)
                
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
