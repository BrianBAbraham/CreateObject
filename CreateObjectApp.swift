//
//  CreateObjectApp.swift
//  CreateObject
//
//  Created by Brian Abraham on 09/01/2023.
//






import SwiftUI

@main
struct CreateObjectApp: App {
    @StateObject var bilateralPartSidePickerVM = BilateralPartSidePickerViewModel()
    @StateObject var  unilateralPartPresenceViewModel =  UnilateralPartPresenceViewModel()

    @StateObject var objectPickerVM = ObjectPickerViewModel()
    @StateObject var partPickerVM = PartPickerViewModel()

    @StateObject var dimensionPickerViewModel = DimensionPickerViewModel()
    @StateObject var dimensionStepperViewModel = DimensionStepperViewModel()
    @StateObject var originPickerViewModel = OriginPickerViewModel()
    @StateObject var originStepperViewModel = OriginStepperViewModel()
    @StateObject var bilateralPartPresenceViewModel = BilateralPartSidePresenceViewModel()
    @StateObject var propertyAngleViewModel =  PropertyAngleViewModel()
    

    @StateObject var coreDataVM = CoreDataViewModel()
    @StateObject var sceneVM = SceneViewModel()
    @StateObject var unitsVM = UnitSystemViewModel()
   
//    @StateObject var movementOriginStepperViewModel = MovementOriginStepperViewModel()
    @StateObject var objectAndRulerVM = ObjectAndRulerViewModel()
    @StateObject var movementPickVM = MovementPickerViewModel()
    @StateObject var movementAngleStepperVM = MovementAngleStepperViewModel()
    @StateObject var movementOriginStepperVM = MovementOriginStepperViewModel()
    @StateObject var movementEditScreenVM = EditScreenViewModel()
    @StateObject var movementAnglePickerVM = MovementAnglePickerViewModel()
    
    @StateObject var objectViewModel = ObjectViewModel()
 
    @StateObject var rulerVM = RulerViewModel()
    @StateObject var recenterVM = RecenterViewModel()
    @StateObject var arcViewModel = ArcViewModel()
    
    @StateObject var tiltEditVM = TiltEditViewModel()


    var body: some Scene {
        WindowGroup {
                ContentView()
                .environmentObject(bilateralPartSidePickerVM)
            

                .environmentObject(objectPickerVM)
                .environmentObject(partPickerVM)

                .environmentObject(dimensionPickerViewModel)
                .environmentObject(dimensionStepperViewModel)
                .environmentObject(originPickerViewModel)
                .environmentObject(originStepperViewModel)
                .environmentObject(bilateralPartPresenceViewModel)
                .environmentObject( unilateralPartPresenceViewModel)
                .environmentObject(propertyAngleViewModel)
            
            
//                .environmentObject(movementOriginStepperViewModel)
                .environmentObject(objectAndRulerVM)
                .environmentObject(movementPickVM)
                .environmentObject(movementAngleStepperVM)
                .environmentObject(movementOriginStepperVM)
                .environmentObject(movementEditScreenVM)
                .environmentObject(movementAnglePickerVM)

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



