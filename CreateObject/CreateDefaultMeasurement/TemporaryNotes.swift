//
//  TemporaryNotes.swift
//  CreateObject
//
//  Created by Brian Abraham on 07/09/2023.
//

import Foundation

/*
CREATE CORNER DICTIONARY

 inputs from UI/load
  preTiltOrigin/ dimension /angle dictionary for part
  BASEOBJECTTYPE
  twinSitOnOptions
  baseOptions
 
 output dictionaries
  postTiltCorners for top view (for display)
  postTiltCorners  for side view (for display)
  postTiltOrigins for side view (for display)
  postTiltOrigins for top view (for display)
  preTiltOrigins for side view (for editing)
  pretTiltOrigins for top view (for editing)
  defaultDimensions (for editing)
 
 corners are derived from
 origin for parts (angle dependent)
 dimension for parts
 angle for parts
 
 use input origin/ dimension/ angle dictionary for part
 or if nil
 use default origin/ dimension/ angle dictionary
 
 
 corners = origin(tilted) + dimensions(tilted)
 corners remove intermediate colinear and internal to maximal volume on plane of choice
 
parentToPartOrigins -> objectToPartOrigins
 
ObjectDefaultOrEditedDictionaries
 
 
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
