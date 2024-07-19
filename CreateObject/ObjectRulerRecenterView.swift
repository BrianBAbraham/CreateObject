//
//  ObjectRulerRecenterView.swift
//  CreateObject
//
//  Created by Brian Abraham on 19/07/2024.
//

import SwiftUI

struct ObjectRulerRecenterView: View {
    @EnvironmentObject var recenterVM: RecenterViewModel
    @State private var isPressed = false

    var body: some View {
        Button(action: {
            // Start the button press animation
            withAnimation(.easeInOut(duration: 0.2)) {
                isPressed = true
            }

            // Schedule the recenter action and the reset of the button state after the animation completes
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                // Execute the recenter function after the initial animation
                recenterVM.setRecenterState()

                // Then, with a slight delay, reset the button state with another animation
                withAnimation(.easeInOut(duration: 0.4)) {
                    isPressed = false
                }
            }
        }) {
            Text("Center Ruler & Object")
                .font(.system(size: 10))
                .foregroundColor(.blue)
                .scaleEffect(isPressed ? 2.0 : 1) // Apply scale effect based on the isPressed state
        }
        .buttonStyle(.plain)
        .padding()
    }
}
