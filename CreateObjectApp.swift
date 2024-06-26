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
    @StateObject var objectDataGetterVM = ObjectDataGetterViewModel()
    @StateObject var objectShowMenuVM = ObjectShowMenuViewModel()
    @StateObject var objectEditVM = ObjectEditViewModel()
    @StateObject var coreDataVM = CoreDataViewModel()
    @StateObject var sceneVM = SceneViewModel()
    @StateObject var unitsVM = UnitSystemViewModel()
   
    @StateObject var movementDataGetterVM = MovementDataGetterViewModel()
    @StateObject var movementPickVM = MovementPickViewModel()
    @StateObject var movementDataProcessorVM = MovementDataProcessorViewModel()
    
 
    @StateObject var rulerVM = RulerViewModel()
    @StateObject var recenterVM = RecenterViewModel()
    @StateObject var arcViewModel = ArcViewModel()


    var body: some Scene {
        WindowGroup {
                ContentView()
                .environmentObject(movementDataGetterVM)
                .environmentObject(objectPickVM)
                .environmentObject(objectDataGetterVM)
                .environmentObject(movementPickVM)
                .environmentObject(movementDataProcessorVM)
                .environmentObject(objectShowMenuVM)
                .environmentObject(objectEditVM)
                .environmentObject(coreDataVM)
                .environmentObject(sceneVM)
                .environmentObject(unitsVM)
                .environmentObject(rulerVM)
                .environmentObject(recenterVM)
               .environmentObject(arcViewModel)
        }
    }
}



