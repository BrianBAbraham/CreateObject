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
        
        
        /// leftAndRight
        /// if both one slider
        /// if not both left and right
        
        let boundLeftLength = Binding(
            get: {currentLength[0]},
            set: {self.proposedLeftLength = $0}
        )
        let boundRightLength = Binding(
            get: {currentLength[1]},
            set: {self.proposedRightLength = $0}
        )
        
        var editedDictionary: PositionDictionary = [:]
        
        VStack{
            Spacer()
            VStack {
                Toggle(isOn: $leftAndRight)
                    { Text("Both")}
                    .padding([.leading, .trailing])
                
                    HStack {
                        Text("L")
                        Slider(value: boundLeftLength, in: 500.0...1500.0, step: 1
                        )
                        .onChange(of: proposedLeftLength) { value in
                            editedDictionary =
                            objectEditVM.setPrimaryToFootPlateFrontLength(
                                dictionary,
                                .id0,
                                proposedLeftLength - currentLength[0]
                            )
                            objectPickVM.setObjectDictionary(
                                objectPickVM.getCurrentObjectType(),
                                editedDictionary)
                        }
                     Text("\(Int(currentLength[0]))")
                    }
            }
            
            .padding([.leading, .trailing])
            HStack {
                Text("R")
                Slider(value: boundRightLength, in: 500.0...1500.0, step: 1
                )
                .onChange(of: proposedRightLength) { value in
                    editedDictionary =
                    objectEditVM.setPrimaryToFootPlateFrontLength(
                        dictionary,
                        .id1,
                        proposedRightLength - currentLength[1]
                        )
                    objectPickVM.setObjectDictionary(
                        objectPickVM.getCurrentObjectType(),
                        editedDictionary)
                }
                Text("\(Int(currentLength[1]))")
            }
            .padding([.leading, .trailing])
        }

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
