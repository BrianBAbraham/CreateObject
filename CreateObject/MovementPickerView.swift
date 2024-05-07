//
//  MovementPickerView.swift
//  CreateObject
//
//  Created by Brian Abraham on 13/04/2024.
//

import SwiftUI

struct MovementPickerView: View {
    @EnvironmentObject var movementPickVM: MovementPickViewModel
    @State private var movementName: String// = Movement.none.rawValue
    let menuItems = Movement.allCases.map {
        $0.rawValue
    }
    
    init (_ movementName: String) {
        _movementName = State(initialValue: movementName)
    }
    
    var body: some View {
      
        ZStack{
            Picker(
                "",
                selection: $movementPickVM.movementName
            ) {
                ForEach(
                    menuItems,
                    id: \.self
                ) { item in
                    Text(
                        item
                    )
                }
            }
            .onChange(
                of: movementPickVM.movementName
            ) {
                oldValue,
                newValue in
                
                movementPickVM.updateMovementImageData(
                    to: newValue
                )
                
                movementName = newValue
            }
            //Start work around: removes grey background from iPhone 13 mini
            //physical device
            .opacityAndScaleToHidePickerLabel()
            
            DuplicatePickerText(name: movementName )
            //End work around
        }
    }
}


//struct AngleSetter: View {
//    @EnvironmentObject var movementPickVM: MovementPickViewModel
//    
//    var body: some View {
//        Stepper("Adjust Angle: \(movementPickVM.startAngle, specifier: "%.0f") degrees", value: $movementPickVM.startAngle, step: 5.0)
//    }
//}

struct AngleSetter: View {
    @EnvironmentObject var movementPickVM: MovementPickViewModel
    var setAngle: (Double) -> Void  // Closure to set the angle
    var body: some View {
        let boundStepperValue =
        Binding(
            get: {0.0}
            ,
            set: {
                newValue in
                self.setAngle(newValue)
            }
        )
        HStack{
            Stepper("", value: boundStepperValue, step: 10.0)
        }
    }
}


struct OriginSetter: View {
    @EnvironmentObject var movementPickVM: MovementPickViewModel
    var setValue: (Double) -> Void  // Closure to set the stepper
    var label: String
    var body: some View {
        let boundStepperValue =
        Binding(
            get: {0.0}
            ,
            set: {
                newValue in
                self.setValue(newValue)
            }
        )
        HStack{
            Stepper("", value: boundStepperValue, step: 10.0)
        }
    }
    
    
}


//import PhotosUI
//
//struct Photo: View {
//    @State private var photosPickerItem: PhotosPickerItem?
//    @State var myImage: Image?
//    var body: some View {
//        
//        PhotosPicker(selection: $photosPickerItem, matching: .screenshots){
//            Image(uiImage: avatarImage ?? UIImage(resource: .defaultAvatar))
//            myImage ??  Image(systemName:  "star.fill")
//        }
//        .onChange(of: photosPickerItem) {_ , _ in
//            Task {
//                if let photosPickerItem,
//                   let data = try? await photosPickerItem.loadTransferable(type: Data.self){
//                    
//                    if let image = UIImage(data: data) {
//                        myImage = image
//                    }
//                }
//
//            }
//            
//        }
//    }
//}



//struct MovementPickerViewX: View {
//    @EnvironmentObject var movementPickVM: MovementPickViewModel
//    @State private var selectedMenuNameItem: String = Movement.none.rawValue
//    let menuItems = Movement.allCases.map { $0.rawValue }
//    
//    // Binding to a Bool? which can trigger a reset
//    @Binding var resetSelection: Bool?
//    
//    var body: some View {
//        Picker("", selection: $selectedMenuNameItem) {
//            ForEach(menuItems, id: \.self) { item in
//                Text(item)
//            }
//        }
//        .onChange(of: selectedMenuNameItem) { oldValue, newValue in
//            movementPickVM.updateMovement(
//                to: newValue,
//                origin: 500.0,
//                startAngle: 10.0,
//                endAngle: 80.0,
//                forward: 0.0
//            )
//        }
//        .onChange(of: resetSelection) {_, _ in
//            if resetSelection == true {
//                selectedMenuNameItem = Movement.none.rawValue
//                // Optionally reset the Boolean to nil after acting on it
//                resetSelection = nil
//            }
//        }
//    }
//}

//
//#Preview {
//    MovementPickerView()
//}


struct AnglePickerView: View {
    @EnvironmentObject var movementPickVM: MovementPickViewModel
    
   // @State private var selectedMenuNameItem: String = Movement.none.rawValue
    
    
    
    let menuItems = WhichAngle.allCases.map {
        $0.rawValue
    }
    
    
    var body: some View {
        HStack {
          
            Picker(
                "",
                selection: $movementPickVM.objectAngleName
            ) {
                ForEach(
                    menuItems,
                    id: \.self
                ) { item in
                    Text(
                        item
                    )
                }
            }
    //        .onChange(
    //            of: movementPickVM.movementName
    //        ) {
    //            oldValue,
    //            newValue in
    //
    //            movementPickVM.setMovementName(newValue)
    //
    //            movementPickVM.updateMovement(
    //                to: newValue,
    //                origin: -500.0,
    //
    //                forward: 0.0
    //            )
    //        }
            Text("angle")
        }
        
    }
}


enum WhichAngle: String, CaseIterable {
    case end  = "end"
    case start = "start"
    case startAndEnd = "both"
}
