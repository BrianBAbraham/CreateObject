//
//  ViewModifier.swift
//  CreateObject
//
//  Created by Brian Abraham on 08/03/2024.
//

import SwiftUI


struct GreenWithOpacity: ViewModifier {
    var opacity: Double
    
    init(opacity: Double = 0.2) {
        self.opacity = opacity
    }
    
    func body(content: Content) -> some View {
        content.background(Color.green.opacity(opacity))
    }
}

extension View {
    func backgroundModifier() -> some View {
        self.modifier(GreenWithOpacity())
    }
}


//struct AddShadowToPickerModifier: ViewModifier {
//    func body(content: Content) -> some View {
//        GeometryReader { geometry in
//            content
//                .background(
//                    RoundedRectangle(cornerRadius: 9)
//                        .foregroundColor(.white)
//                        .shadow(color: Color.black.opacity(0.2), radius: 1, x: 3, y: 3)
//                        //.clipShape(RoundedRectangle(cornerRadius: 12))
//                        .frame(width: geometry.size.width, height: geometry.size.height)
//                )
//        }
//    }
//}
//
//extension View {
//    func addShadowToPicker() -> some View {
//        self.modifier(AddShadowToPickerModifier())
//    }
//}

//extension Picker {
//    func addShadowToPicker() -> some View {
//        self.overlay(
//            GeometryReader { geometry in
//                RoundedRectangle(cornerRadius: 9)
//                    .foregroundColor(.white)
//                    .shadow(color: Color.black.opacity(0.2), radius: 1, x: 3, y: 3)
//                    .clipShape(RoundedRectangle(cornerRadius: 12))
//                    .frame(width: geometry.size.width, height: geometry.size.height)
//            }
//            .padding() // Add padding to prevent the shadow from being clipped
//        )
//    }
//}
