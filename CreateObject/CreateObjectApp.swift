//
//  CreateObjectApp.swift
//  CreateObject
//
//  Created by Brian Abraham on 09/01/2023.
//

import SwiftUI

@main
struct CreateObjectApp: App {
    @StateObject var objectPickVM = ObjectPickViewModel()
    @StateObject var partEditVM = PartEditViewModel()
    //@StateObject var  corerDataViewModel = CoreDataViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(objectPickVM.getCurrentObjectType())
                //.environment(\.managedObjectContext,CoreDataViewModel().container.viewContext)
                .environmentObject(objectPickVM)
                .environmentObject(partEditVM)
        }
    }
}
