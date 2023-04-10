//
//  EditObjectMenuView.swift
//  CreateObject
//
//  Created by Brian Abraham on 10/04/2023.
//

import SwiftUI

struct EditObjectMenuView: View {
    @State private var applySymmetry = false
    @State private var affectOtherParts = false
    @State private var imperial = false
    
    var body: some View {
        
        VStack {
            VStack {
                Menu("Measurement Location") {
                    Button("External", action: cancelOrder)
                    Button("Internal", action: cancelOrder)
                    Button("Center", action: cancelOrder)
                }
                
                Menu("Edit Options") {
                    Button("origin", action: placeOrder)
                    Button("corners", action: adjustOrder)
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
                    Button("sides", action: cancelOrder)
                    Button("length", action: cancelOrder)
                    Button("width", action: cancelOrder)
                }
            }

            VStack {
                Toggle("apply symmmetry", isOn: $applySymmetry ).frame(width: 200)
                Toggle("affect other parts", isOn: $affectOtherParts).frame(width: 200)
                Toggle("Imperial", isOn: $imperial).frame(width: 200)
            }
        }
    }

    func placeOrder() { }
    func adjustOrder() { }
    func rename() { }
    func delay() { }
    func cancelOrder() { }
}

struct EditObjectMenuView_Previews: PreviewProvider {
    static var previews: some View {
        EditObjectMenuView()
    }
}
