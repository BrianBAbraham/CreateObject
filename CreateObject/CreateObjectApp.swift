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
    @StateObject var objectEditVM = ObjectEditViewModel()
    @StateObject var coreDataVM = CoreDataViewModel()
    @StateObject var sceneVM = SceneViewModel()
    //@StateObject var  corerDataViewModel = CoreDataViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(objectPickVM.getCurrentObjectName())
                //.environment(\.managedObjectContext,CoreDataViewModel().container.viewContext)
                .environmentObject(objectPickVM)
                .environmentObject(objectEditVM)
                .environmentObject(coreDataVM)
                .environmentObject(sceneVM)
        }
    }
}
