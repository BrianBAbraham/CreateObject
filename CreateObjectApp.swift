//
//  CreateObjectApp.swift
//  CreateObject
//
//  Created by Brian Abraham on 09/01/2023.
//






import SwiftUI

@main
struct CreateObjectApp: App {
   
    @StateObject var objectPickerVM = ObjectPickerViewModel()
    @StateObject var partPickerVM = PartPickerViewModel()
    
    
    @StateObject var objectDataGetterVM = ObjectDataGetterViewModel()
    @StateObject var objectShowMenuVM = ObjectShowMenuViewModel()
    @StateObject var objectEditVM = ObjectEditViewModel()
    @StateObject var coreDataVM = CoreDataViewModel()
    @StateObject var sceneVM = SceneViewModel()
    @StateObject var unitsVM = UnitSystemViewModel()
   
    @StateObject var movementDataGetter = MovementDataViewModel()
    @StateObject var movementPickVM = MovementPickViewModel()
    @StateObject var movementDataProcessorVM = MovementDataProcessorViewModel()
    
    @StateObject var objectViewModel = ObjectViewModel()
 
    @StateObject var rulerVM = RulerViewModel()
    @StateObject var recenterVM = RecenterViewModel()
    @StateObject var arcViewModel = ArcViewModel()
    
    @StateObject var tiltEditVM = TiltEditViewModel()


    var body: some Scene {
        WindowGroup {
                ContentView()
                .environmentObject(objectPickerVM)
                .environmentObject(partPickerVM)
                
            
            
                .environmentObject(movementDataGetter)
               
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
               .environmentObject(objectViewModel)
               .environmentObject(tiltEditVM)
        }
    }
}



