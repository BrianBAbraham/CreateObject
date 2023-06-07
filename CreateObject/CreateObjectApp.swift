//
//  CreateObjectApp.swift
//  CreateObject
//
//  Created by Brian Abraham on 09/01/2023.
//

import SwiftUI

@main
struct CreateObjectApp: App {
    @StateObject var twinSitOnVM = TwinSitOnViewModel()
  
    @StateObject var objectPickVM = ObjectPickViewModel()
    
    @StateObject var objectEditVM = ObjectEditViewModel()
    @StateObject var coreDataVM = CoreDataViewModel()
    @StateObject var sceneVM = SceneViewModel()

    var body: some Scene {
        WindowGroup {

            ContentView()
                .environmentObject(twinSitOnVM)
                .environmentObject(objectPickVM)
                .environmentObject(objectEditVM)
                .environmentObject(coreDataVM)
                .environmentObject(sceneVM)
        }
    }
}


//@main
//struct CreateObjectApp: App {
//    @StateObject var twinSitOnVM = TwinSitOnViewModel()
//    @StateObject var objectPickVM = ObjectPickViewModel()
//    var body: some Scene {
//        WindowGroup {
//             ContentView()
//
//        }
//    }
//}
