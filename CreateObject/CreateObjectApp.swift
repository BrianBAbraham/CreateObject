//
//  CreateObjectApp.swift
//  CreateObject
//
//  Created by Brian Abraham on 09/01/2023.
//


/*
CREATE CORNER DICTIONARY

 INPUTS from UI/load
 dimensionIn / preTiltOriginIn/ /angleIn dictionary for parts
  BASEOBJECTTYPE
  twinSitOnOptions
  baseOptions
 
 OUTPUTS dictionaries
 defaultDimension (for editing)
 preTiltOrigin (for editing)
 angle (for editing)
 postTiltOrigin (for editing)
 postTiltCorner for top view (for display)
 postTiltCorner for side view (for display)
  

 
 corners are derived from
     origin for parts (angle dependent)
     dimension for parts
     angle for parts
 
     use INPUT preTiltOrigin/ dimension /angle dictionary for parts
     ??
     use OUTPUT pretTiltOrigins/ defaultDimensions/ angle dictionary
 
 
 corners = origin(tilted) + dimensions(tilted)
 corners remove intermediate colinear and internal to maximal volume on plane of choice
 
     ORIGINS PRETILT
     parentToPartOrigins -> objectToPartOrigins
 
     ORIGINS PROST-TILT
     parentToPartOrigins -> objectToPartOrigins
 
 
 
 DimensionOriginCornerDictionaries
 
 
    PreTiltWheelOrigin
    determines origin-id-nodes from
        PreTiltOccupantBodySupportOrigin
        WheelAndCasterVerticalJointOrigin
 
     
    PreTiltOccupantSupportOrigin
    determines Foot/Back/Side from
        PreTiltOccupantFootSupportDefaultOrigin
        PreTiltOccupantBackSupportDefaultOrigin
        PreTiltOccupantSideSupportDefaultOrigin
     
     
    PreTiltOccupantBodySupportOrigin
    determines sitOn origins from interactions of
        DistanceBetweenWheels
        Stability
        OccupantBodySupportDefaultDimension
        OccupantSideSupportDefaultDimension
        OccupantFootSupportDefaultDimension
 
 
            DistanceBetweenWheels
            determines distance between wheel-joint from
                Stability
                OccupantBodySupportDefaultDimension parameter
                OccupantFootSupportDefaultDimension parameter

 */



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
