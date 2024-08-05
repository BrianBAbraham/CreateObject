//
//  CreateObjectApp.swift
//  CreateObject
//
//  Created by Brian Abraham on 09/01/2023.
//






import SwiftUI

@main
struct CreateObjectApp: App {
    
    
    //ObjectEditMenuView
        //Properties
    @StateObject var bilateralPartSidePickerVM = BilateralPartSidePickerViewModel()
    @StateObject var bilateralPartPresenceVM = BilateralPartSidePresenceViewModel()
    @StateObject var dimensionPickerVM = DimensionPickerViewModel()
    @StateObject var dimensionStepperVM = DimensionStepperViewModel()
    @StateObject var originPickerVM = OriginPickerViewModel()
    @StateObject var originStepperVM = OriginStepperViewModel()
    @StateObject var propertyAngleEditVM =  PropertyAngleEditViewModel()
    @StateObject var unilateralPartPresenceVM =  UnilateralPartPresenceViewModel()
    
        //Selections
    @StateObject var objectPickerVM = ObjectPickerViewModel()
    @StateObject var partPickerVM = PartPickerViewModel()
    

//MovementMenuView
    @StateObject var movementAnglePickerVM = MovementAnglePickerViewModel()
    @StateObject var movementAngleStepperVM = MovementAngleStepperViewModel()
    @StateObject var movementOriginStepperVM = MovementOriginStepperViewModel()
    @StateObject var movementPickerVM = MovementPickerViewModel()

    
    

    @StateObject var coreDataVM = CoreDataViewModel()

    @StateObject var unitsVM = UnitSystemViewModel()

    @StateObject var objectAndRulerVM = ObjectAndRulerViewModel()



    @StateObject var movementEditScreenVM = EditScreenViewModel()
    @StateObject var movementEditMenuContainerVM = MovementEditMenuContainerViewModel()
  
    @StateObject var allPartWithArcContainerVM = AllPartWithArcContainerViewModel()
    @StateObject var partViewModel = AllPartViewModel()
 
    @StateObject var rulerVM = RightAngleRulerViewModel()
    @StateObject var recenterVM = ObjectRulerRepositionViewModel()
    @StateObject var allArcWithStaticPointVM = AllArcWithStaticPointViewModel()
    
    @StateObject var tiltEditVM = TiltEditViewModel()


    var body: some Scene {
        WindowGroup {
                ContentView()
                .environmentObject(bilateralPartSidePickerVM)
            

                .environmentObject(objectPickerVM)
                .environmentObject(partPickerVM)

                .environmentObject(dimensionPickerVM)
                .environmentObject(dimensionStepperVM)
                .environmentObject(originPickerVM)
                .environmentObject(originStepperVM)
                .environmentObject(bilateralPartPresenceVM)
                .environmentObject( unilateralPartPresenceVM)
                .environmentObject(propertyAngleEditVM)
            
            

                .environmentObject(objectAndRulerVM)
                .environmentObject(movementPickerVM)
                .environmentObject(movementAngleStepperVM)
                .environmentObject(movementOriginStepperVM)
                .environmentObject(movementEditScreenVM)
                .environmentObject(movementEditMenuContainerVM)
                .environmentObject(movementAnglePickerVM)

                .environmentObject(coreDataVM)

                .environmentObject(unitsVM)
                .environmentObject(rulerVM)
                .environmentObject(recenterVM)
               .environmentObject(allArcWithStaticPointVM)
            
               .environmentObject(allPartWithArcContainerVM)
               .environmentObject(partViewModel)
            
               .environmentObject(tiltEditVM)
        }
    }
}



