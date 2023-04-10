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
    @StateObject var partEditVM = PartEditViewModel()
    //@StateObject var  corerDataViewModel = CoreDataViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(epVM.getCurrentObjectType())
//                .environment(\.managedObjectContext,CoreDataViewModel().container.viewContext)
                .environmentObject(epVM)
                .environmentObject(partEditVM)
        }
    }
}
