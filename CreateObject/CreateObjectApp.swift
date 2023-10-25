//
//  CreateObjectApp.swift
//  CreateObject
//
//  Created by Brian Abraham on 09/01/2023.
//


/*
 PickInitialObjectView: Default equipment
 -> DictionaryProvider -> currentDictionary
 
 
 DictionaryProvider

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
 preTiltFourCornerPerKeyDic for top view (for display zIndex)
 postTiltFourCornerPerKeyDic for top view (for display)

  
  
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
 id may be 'unilateral' or 'bilateral'
 
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
 
 

 
 DictionaryProvider DICTIONARY NAMES
 IN
 ...DicIn: empty or populated, edited in UI and passed in
 dimensionDicIn: provides a 3d dimension for each specific part, sides can be different
 
 preTilt...all angle at zero
 preTiltParentToPartOriginDicIn: origin from parent
 preTiltObjectToPartOriginDicIn: aorigin from object origin
 
 angleDicIn: all angles for part or part collections which angle
 
 
 DEFAULT
 angleDic: all angles for part or part collections which angle
 dimensionDic: the default dimensions
 
 preTiltParentToPartOriginDic: default origin from parent
 preTiltObjectToPartOriginDic: default origin from object origin
     
 preTiltObjectToCornerDic: default object origin to corner0...corner3 with unique key for each corner, used for determining dimensions
 pretTiltObjectToPartFourCornerPerKeyDic: default default object origin to corner0...corner3 with common key for all corner,
 
 postTiltObjectToCornerDic:
 postTiltObjectToPartFourCornerPerKey: used by UI

 
 UI
 ObjectView
    objectPickVM.getObjectDictionaryForScreen()
 
 ObjectPicViewModel
 objectPickModel.fourCornerPerKeyDic
    getCurrentObjectAsOneCornerPerKey
 
 getFourCornerPerKeyDic()
 
 
 
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
