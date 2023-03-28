//
//  CreateObjectApp.swift
//  CreateObject
//
//  Created by Brian Abraham on 09/01/2023.
//

import SwiftUI

@main
struct CreateObjectApp: App {
    @StateObject var epVM = ObjectPickViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(epVM.getCurrentObjectType())
            //ContentView()
                .environmentObject(epVM)
        }
    }
}
