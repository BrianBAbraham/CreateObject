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
    @State private var proposedLength = 200.0
    @EnvironmentObject var vm: ObjectPickViewModel
    
    init(_ dictionary: PositionDictionary){
        self.dictionary = dictionary
    }
    
    
    var body: some View {
        
        let objectLength = vm.getFootSupportHangerLength()
        
        
        let boundWidth = Binding(
            get: {0},
            set: {self.proposedWidth = $0}
        )
        let boundLength = Binding(
            get: {objectLength},
            set: {self.proposedLength = $0}
        )
        
        
        VStack{
            HStack {
                //sliderChairLength(boundLength)
                Slider(value: boundLength, in: 500.0...2500.0, step: 10
                )
                .onChange(of: proposedLength) { value in
//                    vm.getCornersJoiningTwoPartsPossiblyOnTwoSides(
//                        .footSupportHangerSitOnVerticalJoint,
//                        .footSupportHorizontalJoint
                        
                        vm.getCornerDictionaryForPartDerivedFromTwoParts(
                            .footSupportHangerSitOnVerticalJoint,
                            .footSupportHorizontalJoint,
                            .footSupportHangerLink
                        )
                     //print(value)
                }
                Text("\(Int(objectLength))")
                
            }
            
            .padding([.leading, .trailing])
            HStack {
                //sliderChairWidth(boundWidth)
                Text("width")
                
            }
            
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
