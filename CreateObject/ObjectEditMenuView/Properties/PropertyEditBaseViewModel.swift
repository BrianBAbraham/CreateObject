//
//  PropertyBaseViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 08/07/2024.
//

import Foundation
import Combine



class PropertyEditBaseViewModel: ObservableObject {
    @Published var doNotShow = true
  
    var objectType = ObjectDataService.shared.objectType
    
    var choiceOfEditForSide: SidesAffected = ObjectEditService.shared.choiceOfEditForSide
    
    var userEditedSharedDics = DictionaryService.shared.userEditedSharedDics
    
    var partDataDic = ObjectDataService.shared.partDataDic
  
    
    private var cancellables: Set<AnyCancellable> = []

    init() {
        ObjectEditService.shared.$scopeOfEditForSide
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newData in
                self?.doNotShow = self?.getPartNotPresent() ?? true
            }
            .store(in: &self.cancellables)
        
        ObjectEditService.shared.$choiceOfEditForSide
            .receive(on: DispatchQueue.main)
            .assign(to: \.choiceOfEditForSide,on: self)
            .store(in: &cancellables)
        
        ObjectDataService.shared.$objectType
            .receive(on: DispatchQueue.main)
            .assign(to: \.objectType,on: self)
            .store(in: &cancellables)
        
        DictionaryService.shared.$userEditedSharedDics
            .receive(on: DispatchQueue.main)
            .assign(to: \.userEditedSharedDics,on: self)
            .store(in: &cancellables)
        
        ObjectDataService.shared.$partDataDic
            .receive(on: DispatchQueue.main)
            .assign(to: \.partDataDic,on: self)
            .store(in: &cancellables)
    }

    
    func modifyObjectByCreatingFromName(){
        let objectImageData = ObjectImageData(
            objectType,
            userEditedSharedDics
        )
        
        ObjectImageService.shared.setObjectImage(
            objectImageData
        )
    }
    
    
    func getInitialSliderValue(
        _ partToEdit: Part,
        _ dimensionPropertyToEdit: PartTag,
        _ sidesAffected: SidesAffected? = nil
    ) -> Double {
        //sometimes the UI selection is adjusted by another part eg footlength for footplate
        let part = PartsRequiringLinkedPartUse(partToEdit).partForDimensionEdit
        let propertyToEdit = dimensionPropertyToEdit
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
    
    
    func getPartNotPresent() -> Bool {
        let partOrAssociatedPart = PartsRequiringLinkedPartUse(ObjectEditService.shared.partToEdit).partForEditableOrigin
        let first = getSidesPresentGivenPossibleUserEdit(partOrAssociatedPart)[0]
        return first == .none
    }

    
    func getSidesPresentGivenPossibleUserEdit(_ partOrAssociatedPart: Part) -> [SidesAffected] {
        guard let chainLabels = DictionaryService.shared.userEditedSharedDics.objectChainLabelsUserEditDic[ObjectDataService.shared.objectType] ?? ObjectDataService.shared.objectChainLabelsDefaultDic[ObjectDataService.shared.objectType] else {
            fatalError()
        }

        var sidesPresent: [SidesAffected] = []
        if chainLabels.contains(partOrAssociatedPart) {
            let oneOrTwoId: OneOrTwo<PartTag> = DictionaryService.shared.userEditedSharedDics.partIdsUserEditedDic[partOrAssociatedPart] ?? OneOrTwoId(ObjectDataService.shared.objectType, partOrAssociatedPart).forPart
            sidesPresent = oneOrTwoId.mapOneOrTwoToSide()
        } else {
            sidesPresent = [.none]
        }

        return sidesPresent
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
    
    
    ///the value may be for origin or dimension
    ///origin may be x or y
    ///dimension may be width or length
    func setValueForBilateralPartInUserEditedDic(
        _ partToEdit: Part,
        _ propertyToEdit: PartTag,
        _ value: Double,
        _ sidesAffected: SidesAffected? = nil) {
    
       // let propertyToEdit = dimensionPropertyToEdit
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
                DictionaryService.shared.dimensionUserEditedDicModifier(
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
                DictionaryService.shared.originOffsetUserEdtiedDicModifier(
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
