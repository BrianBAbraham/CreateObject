//
//  EditObjectMenuView.swift
//  CreateObject
//
//  Created by Brian Abraham on 10/04/2023.
//

import SwiftUI

//struct SliderAccentColor: ViewModifier {
//    @EnvironmentObject var vm: ChairManoeuvreProjectVM
//    var grayOutSlider: Color {
//        vm.getIsAnyChairSelected() ? .blue: .gray
//    }
//    func body(content: Content) -> some View {
//        content
//            .accentColor(grayOutSlider)
//    }
//}

struct EditObjectMenuView: View {
    var dictionary: PositionDictionary = [:]
    @State private var applySymmetry = false
    @State private var affectOtherParts = false
    @State private var imperial = false

    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    
    
    init(){
        //self.dictionary = objectPickVM.getRelevantDictionary(.forMeasurement)
    }
    
    

    
    var body: some View {
        
        let dictionary = objectPickVM.getRelevantDictionary(.forMeasurement)
    
        if objectPickVM.getCurrentObjectType().contains("hair") {
            EditFootSupportPosition(dictionary)
        } else {
            EmptyView()
        }
  
//            .onAppear{objectPickVM.toggleEditOccuring()
//                print("TOBBLE")
//            }
//            .onDisappear{objectPickVM.toggleEditOccuring()
//                print("FOBBLE")
//            }

    }

       
        //        VStack {
        //            VStack {
        //                Menu("Measurement Location") {
        //                    Button("External", action: cancelOrder)
        //                    Button("Internal", action: cancelOrder)
        //                    Button("Center", action: cancelOrder)
        //                }
        //
        //                Menu("Edit Options") {
        //                    Button("origin", action: placeOrder)
        //                    Button("corners", action: adjustOrder)
        //                    Menu("wheelchair") {
        //                        Menu("independent electric") {
        //                            Button("mid drive", action: rename)
        //                            Button("front drive", action: delay)
        //                            Button("rear drive", action: delay)
        //                        }
        //                        Menu("manual") {
        //                            Button("front drive", action: delay)
        //                            Button("rear drive", action: delay)
        //                        }
        //                        Menu("assisted electric") {
        //                            Button("front drive", action: delay)
        //                            Button("rear drive", action: delay)
        //                        }
        //                    }
        //                    Button("sides", action: cancelOrder)
        //                    Button("length", action: cancelOrder)
        //                    Button("width", action: cancelOrder)
        //                }
        //            }
        //
        //            VStack {
        //                Toggle("apply symmmetry", isOn: $applySymmetry ).frame(width: 200)
        //                Toggle("affect other parts", isOn: $affectOtherParts).frame(width: 200)
        //                Toggle("Imperial", isOn: $imperial).frame(width: 200)
        //            }
        //        }
        
        //        func sliderChairWidth(_ boundWidth: Binding<Double>) -> some View {
        //            Slider(value: boundWidth, in: 300.0...1000.0, step: 10)
        //                .onChange(of: proposedChairExternalWidthMeasurement) { value in
        //                    vm.replacePartsInExistingChairManoeuvre(proposedChairExternalWidthMeasurement, .chairWidth)
        //                }
        //        }
        
//                func sliderChairLength(_ boundLength: Binding<Double>) -> some View {
//                    Slider(value: boundLength, in: 500.0...2500.0, step: 10
//                    )
//                    .onChange(of: proposedLength) { value in
//                        print(value)
//                    }
//                }
        
        //    func placeOrder() { }
        //    func adjustOrder() { }
        //    func rename() { }
        //    func delay() { }
        //    func cancelOrder() { }
    
}

struct EditObjectMenuView_Previews: PreviewProvider {
    static var previews: some View {
        EditObjectMenuView()
            .environmentObject(ObjectPickViewModel())
    }
        
}

/// 
