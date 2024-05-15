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

//sitOnBackFootTiltJoint


///objects are an array  Part
///where each Part is the terminal element in an array of Part
///labelled as chainLabel and chain respectively
///the chain are all the Part which connect the object primary origin
///to the terminal Part
///each Part has a dimension  and an origin and an id 
///
///which are an array of parts
///in order of physical  fixing from the object origin
///how should the decision to include a node be made??
///
///some nodes have more than one form eg caster or fixed wheel nodes
///
///wheelJoint and sitOn parent is the object origin so the wheel object type
///affects origins: front wheels have a different y origin if it is a front drive
///
///some nodes are optional on the object: head rest
///
///some nodes have variable set up: tilt in space
///
///is it better to have if object == throughout/pass dictionary and have if dic[]
///OR
///if object == func A else func B
///
///WHERE ARE CONDITIONS APPLIED
///the choiice is
///call different functtions conidtionally which attribute nodes
///OR
///call one function which attributes conditionally
///OR
///a mixtures
///
///HOW ARE CONDITIONS APPLIED
///the choice
/// enums or dictionary conidtions?
///
/// TiltGroupsFor  provide nodes for tilting
///
/// PartGroup is the node group
///
/// How does the option dic interact
///option dic should be the means for the UI to provide control of options
///
/// BaseObjectGroups are a feature list for objects
