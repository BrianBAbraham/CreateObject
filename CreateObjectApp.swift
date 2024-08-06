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
    

//MovementEditMenuView
    @StateObject var movementAnglePickerVM = MovementAnglePickerViewModel()
    @StateObject var movementAngleStepperVM = MovementAngleStepperViewModel()
    @StateObject var movementOriginStepperVM = MovementOriginStepperViewModel()
    @StateObject var movementPickerVM = MovementPickerViewModel()
    @StateObject var movementEditMenuContainerVM = MovementEditMenuContainerViewModel()
    
    
//Movement
    @StateObject var movementEditScreenVM = EditScreenViewModel()
    
    

//ObjectView
    @StateObject var partViewModel = AllPartViewModel()
    @StateObject var allArcWithStaticPointVM = AllArcWithStaticPointViewModel()
    @StateObject var allPartWithArcContainerVM = AllPartWithArcContainerViewModel()

 
    @StateObject var rulerVM = RightAngleRulerViewModel()

    @StateObject var objectAndRulerVM = ObjectAndRulerViewModel()
  
    @StateObject var recenterVM = ObjectRulerRepositionViewModel()
    
//Miscellanious
    @StateObject var coreDataVM = CoreDataViewModel()
    @StateObject var unitsVM = UnitSystemViewModel()

    var body: some Scene {
        WindowGroup {
                ContentView()
            //ObjectEditMenuView
                //Properties
                .environmentObject(bilateralPartSidePickerVM)
                .environmentObject(bilateralPartPresenceVM)
                .environmentObject(dimensionPickerVM)
                .environmentObject(dimensionStepperVM)
                .environmentObject(originPickerVM)
                .environmentObject(originStepperVM)
                .environmentObject(propertyAngleEditVM)
                .environmentObject(unilateralPartPresenceVM)
                
                //Selection
                .environmentObject(objectPickerVM)
                .environmentObject(partPickerVM)
            
            
            //MovementEditMenuView
                .environmentObject(movementAnglePickerVM)
                .environmentObject(movementAngleStepperVM)
                .environmentObject(movementOriginStepperVM)
                .environmentObject(movementPickerVM)
                .environmentObject(movementEditMenuContainerVM)


            //Movement
                .environmentObject(movementEditScreenVM)


            //ObjectView
                .environmentObject(partViewModel)
                .environmentObject(allArcWithStaticPointVM)
                .environmentObject(allPartWithArcContainerVM)
            
                .environmentObject(rulerVM)
            
               .environmentObject(objectAndRulerVM)
                
                .environmentObject(recenterVM)
            
            
            //Miscellaneous
            
                .environmentObject(coreDataVM)

                .environmentObject(unitsVM)
  

            
        



        }
    }
}



