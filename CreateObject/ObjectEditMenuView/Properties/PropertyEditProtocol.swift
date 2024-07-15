//
//  PropertyEditProtocol.swift
//  CreateObject
//
//  Created by Brian Abraham on 13/07/2024.
//

import Foundation
import Combine

protocol  SharedObectTypeAndUserEditedDictionaries: AnyObject {
    var cancellables: Set<AnyCancellable> { get set }
    
    var userEditedSharedDics: UserEditedDictionaries {get set}
    
    var objectType: ObjectTypes {get set}
}
extension SharedObectTypeAndUserEditedDictionaries {
    func subscribeToServices() {
        UserEditedDictionariesService.shared.$userEditedSharedDics
            .receive(on: DispatchQueue.main)
            .assign(to: \.userEditedSharedDics,on: self)
            .store(in: &cancellables)
        
        ObjectDataService.shared.$objectType
            .receive(on: DispatchQueue.main)
            .assign(to: \.objectType,on: self)
            .store(in: &cancellables)
    }
}



protocol SharedChoiceAnbScopeOfEditForSide: AnyObject{
    var cancellables: Set<AnyCancellable> { get set }
}



protocol SharedModifyObjectByCreatingFromNameFuncOnly: AnyObject {
    var cancellables: Set<AnyCancellable> { get set }
    
    var userEditedSharedDics: UserEditedDictionaries {get set}
    
    var objectType: ObjectTypes {get set}
    
}
extension SharedModifyObjectByCreatingFromNameFuncOnly{
    

    
    func modifyObjectByCreatingFromName(){
        let objectImageData = ObjectImageData(
            objectType,
            userEditedSharedDics
        )
        
        ObjectImageService.shared.setObjectImage(
            objectImageData
        )
    }
}



protocol SharedInitialSliderValueFuncOnly: AnyObject {
    var partDataDic: [Part: PartData]  {get}
    
    var userEditedSharedDics: UserEditedDictionaries {get}
    
    var choiceOfEditForSide: SidesAffected {get}
}
extension SharedInitialSliderValueFuncOnly {
    func getInitialSliderValue(
        _ partToEdit: Part,
        _ propertyToEdit: PartTag,
        _ sidesAffected: SidesAffected? = nil
    ) -> Double {
        //sometimes the UI selection is adjusted by another part eg footlength for footplate
        let part = PartsRequiringLinkedPartUse(partToEdit).partForDimensionEdit
        let propertyToEdit = propertyToEdit
        var value: Double? = nil
        if let partData = partDataDic[part] {//parts edited out do not exist
            let idForLeftOrRight = choiceOfEditForSide == .right ? PartTag.id1: PartTag.id0
        
            var id: PartTag
            if let sideAsId = sidesAffected?.getOneId() {
                id = sideAsId
            } else {
                id =  partData.id.one ?? idForLeftOrRight//two sources for id
            }
           
            switch propertyToEdit {
            case .height:
                let dimension = partData.dimension.returnValue(id)
                
                value = dimension.height
            case .width:
                let dimension = partData.dimension.returnValue(id)
                value = dimension.width
            case.length:
                let dimension = partData.dimension.returnValue(id)
                value = dimension.length
            case .xOrigin, .yOrigin:
                let name = CreateNameFromIdAndPart(id, part).name
                let offsetToOrigin = userEditedSharedDics.originOffsetUserEditedDic[name] ?? ZeroValue.iosLocation

                value = propertyToEdit == .xOrigin ?
                offsetToOrigin.x: offsetToOrigin.y
                
            case .angle:
                value =
                    partData.angles.returnValue(id).x.converted(to: .degrees).value
            
            default:
                break
            }
        }
            let whenPartHasBeenRemovedAndValueNotUsed = 0.0
          
            return value ?? whenPartHasBeenRemovedAndValueNotUsed
    }
}






protocol SharedOriginPropertyToEdit: AnyObject {
    var cancellables: Set<AnyCancellable> { get set }
    
    var originPropertyToEdit: PartTag { get set }
       
    func subscribeToService()
}
extension SharedOriginPropertyToEdit {
   func subscribeToService() {
       ObjectEditService.shared.$originPropertyToEdit
           .receive(on: DispatchQueue.main)
           .assign(to: \.originPropertyToEdit,on: self)
           .store(in: &cancellables)
   }
}



protocol SharedDimensionPropertyToEdit: AnyObject {
    var cancellables: Set<AnyCancellable> { get set }
    
    var dimensionPropertyToEdit: PartTag { get set }
    
    func subscribeToDimensionPropertyToEditDataService()
    
}
extension SharedDimensionPropertyToEdit {
   func subscribeToDimensionPropertyToEditDataService() {
       ObjectEditService.shared.$dimensionPropertyToEdit
           .receive(on: DispatchQueue.main)
           .assign(to: \.dimensionPropertyToEdit,on: self)
           .store(in: &cancellables)
   }
}



protocol SharedEditableOrignExistFuncOnly: AnyObject {
    var editableOriginExist: Bool {get set}
    var editableOrigin: [PartTag] {get set}
    var partToEdit: Part {get}
    var objectType: ObjectTypes {get}
    
}
extension SharedEditableOrignExistFuncOnly {
    func getPropertiesForOriginPicker(_ part: Part) -> [PartTag] {
        if  let displayPart = PartToDisplayInMenu.dictionary[part] {
            switch displayPart {
            case .seat:
                if objectType == .showerTray {
                    return []
                } else {
                    return [.xOrigin, .yOrigin]
                }
                
            case .propeller, .footLever, .headrest:
                return [.xOrigin]
                
            case .casterForkAtFront, .casterForkAtMid, .casterForkAtRear:
                return [.yOrigin]
                
            case .backrest:
               return []
                
            default:
                return [.xOrigin, .yOrigin]
                }
        } else {
            return [.xOrigin, .yOrigin]
        }
    }
    
    
    func getIfAnyEditableOrigin(){
       editableOrigin = getPropertiesForOriginPicker(partToEdit)
        editableOriginExist =
            editableOrigin == [] ? false: true
    }
}



protocol SharedSetValueForBilateralPartFuncOnly: AnyObject {
    var choiceOfEditForSide: SidesAffected {get}
    
    var partDataDic: [Part: PartData]  {get}
    
    var userEditedSharedDics: UserEditedDictionaries {get}
}
extension SharedSetValueForBilateralPartFuncOnly {
    
    func getEditedOrDefaultOriginOffset(
        _ name: String
    )
        -> PositionAsIosAxes {

        return
            userEditedSharedDics.parentToPartOriginOffsetUserEditedDic[name] ?? ZeroValue.iosLocation
    }
    
    
    func dimensionWithModifiedProperty(
        _ value: Double,
        _ dimension: Dimension3d,
        _ property: PartTag
    ) -> Dimension3d {
        switch property {
        case .height:
            return
                (
                    width: dimension.width,
                    length: dimension.length,
                    height: value
                )
        case .length:
            return
                (
                    width: dimension.width,
                    length: value,
                    height:dimension.height
                )
        case.width:
            return
                (
                    width: value,
                    length: dimension.length,
                    height:dimension.height
                )
        default: return dimension
        }
    }
    
    
    func getEditedOrDefaultDimension(
        _ name: String,
        _ part: Part,
        _ id: PartTag)
        -> Dimension3d {

            guard let partData = partDataDic[part] else {
                fatalError()
            }
        return
            partData.dimension.returnValue(id)
    }
    
    
    ///the value may be for origin or dimension
    ///origin may be x or y
    ///dimension may be width or length
    func setValueForBilateralPartInUserEditedDic(
        _ partToEdit: Part,
        _ propertyToEdit: PartTag,
        _ value: Double,
        _ sidesAffected: SidesAffected? = nil) {
    
            //sometimes the UI part is not the part that is edtied
        let part = PartsRequiringLinkedPartUse(partToEdit).partForDimensionEdit
        var partOrLinkedPart: Part = .notFound
        let allDimensionProperties: [PartTag] = [.width, .length, .height]
        if value == 0.0 && allDimensionProperties.contains(propertyToEdit) {
           //do not let dimensions cross zer0
        } else {
            
            transformToStabiliserForDriveWheelModForOriginY ()

            var sidesToEdit: SidesAffected
            
            if let unwrapped = sidesAffected {
               sidesToEdit = unwrapped
            } else {
                sidesToEdit = choiceOfEditForSide
            }
            switch sidesToEdit {
            case .both:
                process(.id0)
                process(.id1)
            case.left:
                process(.id0)
            case.right:
                process(.id1)
            default:
                break
            }
        }

     
        func process(
            _ id: PartTag
        ) {
            let name = CreateNameFromIdAndPart(
                id,
                partOrLinkedPart
            ).name
            switch propertyToEdit {
            case .length, .width, .height:
                let currentDimension =
                getEditedOrDefaultDimension(
                    name,
                    partOrLinkedPart,
                    id
                )
                let newDimension =
                dimensionWithModifiedProperty(
                    value,
                    currentDimension,
                    propertyToEdit
                )
                UserEditedDictionariesService.shared.dimensionUserEditedDicModifier(
                    [name: newDimension]
                )
            case .xOrigin, .yOrigin:
                let currentOrigin = getEditedOrDefaultOriginOffset(
                    name
                )
                let newOriginOffset = propertyToEdit == .xOrigin ? xOriginModified(
                    currentOrigin,
                    id
                ) : yOriginModified(
                    currentOrigin,
                    id
                )
                UserEditedDictionariesService.shared.originOffsetUserEdtiedDicModifier(
                    [name: newOriginOffset]
                )
            default: break
            }
        }
            
        func transformToStabiliserForDriveWheelModForOriginY () {
            ///the static point is on the  common turn axis of the fixed wheels
            ///increasing the stability of the main support by increasing the distance
            ///between the main support and the drive wheels for a rear drive  wheelchair
            ///therefore is an increase in stability rather than solely a motion of the drive wheels
            ///however, it is cleaner to include y origin control of the drive wheelchair position
            ///in the rear wheel menu rather than create a new stability menu
            ///the code to do that is also conistant with the mid and front drive
            let dic: [Part: Part] = [
                .fixedWheelAtRear: .stabiliser,
                .fixedWheelAtFront: .stabiliser,
                .fixedWheelAtMid: .stabiliser,
            ]
            if let unwrapped = dic[part],  propertyToEdit == .yOrigin {
                partOrLinkedPart = unwrapped
        
            } else {
                partOrLinkedPart = part
            }
        }
            
            
        func xOriginModified(_ origin: PositionAsIosAxes, _ id: PartTag) -> PositionAsIosAxes {
            var mod: Double//eg armRest xMove '-' brings closer, but headRest moves left
            
            if getNoModRequiredX(part) {
                mod = 1.0
            } else {
                mod = makeLeftAndRightMoveCloserWithNegAndApartWithPos()
            }
            let newOrigin =
                (x: origin.x + value * mod,
                 y: origin.y,
                 z: 0.0)
            return newOrigin
            
            func makeLeftAndRightMoveCloserWithNegAndApartWithPos() -> Double {
                var reverseDirection = 1.0
                if choiceOfEditForSide == .both {
                    reverseDirection = id == .id1 ? 1.00: -1.00
                }
                return reverseDirection
            }
        }
            
            
        func getNoModRequiredX(_ part: Part) -> Bool{
            let exclusionsForAlwaysUniPart: [Part] = [
                .mainSupport,
                .backSupport,
                .backSupportHeadSupport
            ]
            return
                exclusionsForAlwaysUniPart.contains(part) ? true: false
        }
        
        
        func yOriginModified(_ origin: PositionAsIosAxes, _ id: PartTag) -> PositionAsIosAxes {
            return
                (x: origin.x,
                y: origin.y + value,
                z: 0.0)
        }
    }
}
