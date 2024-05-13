//
//  MovementPickerView.swift
//  CreateObject
//
//  Created by Brian Abraham on 13/04/2024.
//

import SwiftUI

struct MovementPickerView: View {
    @EnvironmentObject var movementPickVM: MovementPickViewModel
    @State private var movementName: String
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







