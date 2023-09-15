//
//  CreateObjectApp.swift
//  CreateObject
//
//  Created by Brian Abraham on 09/01/2023.
//


/*
CREATE CORNER DICTIONARY

 INPUTS from UI/load
  dimensionIn / preTiltOriginIn/ /angleIn:  dictionary for parts
  BaseObjectTypes
  twinSitOnOptions
  baseOptions
 
 DICTIONARY OUTPUTS:
 defaultDimension (for editing)
 angle (for editing)
 preTiltOrigin (for editing)
 postTiltOrigin (for editing)
 postTiltCorner for top view (for display)
 postTiltCorner for side view (for display)
  
  
 ZERO LEVEL
 defaultDimension(BaseObjectTypes): BaseObject3DimensionDictionary ?? general value
 defaultOrigin(BaseObjectTypes): OriginDictionary ?? general value
 defaultAngle(BaseObjectTypes): BaseObjectAngleDictionary ?? general value
 'ForOccupantBack'
 'ForOccupantBody'
 'ForOccupantSide'
 'ForOccupantFoot'
 note: bilateral parts have common default dimension edited parts may differ
 
 
 ONE LEVEL
 'ForBase.DistanceBetweenWheels'
 determines distance between wheel-joint from
     'Stability'
     OccupantBodySupportDefaultDimension parameter
     OccupantFootSupportDefaultDimension parameter
 
 
 TWO LEVEL
 'DimensionOriginCornerDictionaries'
     determines origin-id-nodes
     PreTiltOccupantBodySupportOrigin
     determines sitOn origins from interactions of
         DistanceBetweenWheels
         Stability
         OccupantBodySupportDefaultDimension
         OccupantSideSupportDefaultDimension
         OccupantFootSupportDefaultDimension
     
     THREE LEVEL
     determines origin-id-nodes
     PreTiltOccupantSupportOrigin
     determines Foot/Back/Side from
         PreTiltOccupantFootSupportDefaultOrigin
         PreTiltOccupantBackSupportDefaultOrigin
         PreTiltOccupantSideSupportDefaultOrigin
     
     PreTiltWheelOrigin
     determines origin-id-nodes from
         PreTiltOccupantBodySupportOrigin
         WheelAndCasterVerticalJointOrigin
     
     FOUR LEVEL
     ORIGINS PRETILT
     parentToPartOrigins -> objectToPartOrigins
 
 
 
 PostTilt
 'OriginPostTilt'
     (each combination of tilt has a func)
     'forSitOnWithFootTilt'
     'forSitOnWithoutFootTilt'
     'forBackRecline'
 
 'PartToCornersPostTilt'
 
 'ObjectToCornersPostTilt'
 
 
 
 
 
 
 corners are derived from
     origin for parts (angle dependent)
     dimension for parts
     angle for parts
 
     use INPUT dimensionIn/ preTiltOriginIn/ angleIn:  dictionary for parts
     ??
     use OUTPUT pretTiltOrigins/ defaultDimensions/ angle dictionary
 
 
 corners = tilted(origin) + tilted(dimensions)
 corners remove intermediate colinear and internal to maximal volume on plane of choice
 

 
     ORIGINS POST-TILT
     parentToPartOrigins -> objectToPartOrigins
 
 
 
 DimensionOriginCornerDictionaries
 
 

 
     

     
     

 
 


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
