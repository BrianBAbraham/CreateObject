//
//  PropertyBaseViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 08/07/2024.
//

import Foundation
import Combine



class PropertyEditBase: ObservableObject {
    @Published var disabled = true
  
    @Published var partToEdit = ObjectEditService.shared.partToEdit
    
    var objectType = ObjectDataService.shared.objectType
    
    var choiceOfEditForSide: SidesAffected = ObjectEditService.shared.choiceOfEditForSide
    
    //var userEditedSharedDics = UserEditedDictionariesService.shared.userEditedSharedDics
    
    var partDataDic = ObjectDataService.shared.partDataDic
    

    
    private var cancellables: Set<AnyCancellable> = []

    init() {
        ObjectEditService.shared.$scopeOfEditForSide
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newData in
                self?.disabled = self?.getPartNotPresent() ?? true
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
        
//        UserEditedDictionariesService.shared.$userEditedSharedDics
//            .receive(on: DispatchQueue.main)
//            .assign(to: \.userEditedSharedDics,on: self)
//            .store(in: &cancellables)
        
        ObjectDataService.shared.$partDataDic
            .receive(on: DispatchQueue.main)
            .assign(to: \.partDataDic,on: self)
            .store(in: &cancellables)
        
        
        ObjectEditService.shared.$partToEdit
            .sink { [weak self] newData in
                self?.partToEdit = newData
                self?.handlePartToEditChange(newData)
            }
            .store(in: &self.cancellables)
    }

    
    func handlePartToEditChange(_ newData: Part) {
    //children execute their unique code here
    }
    
    
//    func modifyObjectByCreatingFromName(){
//        let objectImageData = ObjectImageData(
//            objectType,
//            userEditedSharedDics
//        )
//        
//        ObjectImageService.shared.setObjectImage(
//            objectImageData
//        )
//    }
    

    func getPartNotPresent() -> Bool {
        let partOrAssociatedPart = PartsRequiringLinkedPartUse(ObjectEditService.shared.partToEdit).partForEditableOrigin
        let first = getSidesPresentGivenPossibleUserEdit(partOrAssociatedPart)[0]
        return first == .none
    }

    
    func getSidesPresentGivenPossibleUserEdit(_ partOrAssociatedPart: Part) -> [SidesAffected] {
        guard let chainLabels = UserEditedDictionariesService.shared.userEditedSharedDics.objectChainLabelsUserEditDic[ObjectDataService.shared.objectType] ?? ObjectDataService.shared.objectChainLabelsDefaultDic[ObjectDataService.shared.objectType] else {
            fatalError()
        }

        var sidesPresent: [SidesAffected] = []
        if chainLabels.contains(partOrAssociatedPart) {
            let oneOrTwoId: OneOrTwo<PartTag> = UserEditedDictionariesService.shared.userEditedSharedDics.partIdsUserEditedDic[partOrAssociatedPart] ?? OneOrTwoId(ObjectDataService.shared.objectType, partOrAssociatedPart).forPart
            sidesPresent = oneOrTwoId.mapOneOrTwoToSide()
        } else {
            sidesPresent = [.none]
        }

        return sidesPresent
    }
    
//    
//    func getEditedOrDefaultDimensionX(
//        _ name: String,
//        _ part: Part,
//        _ id: PartTag)
//        -> Dimension3d {
//
//            guard let partData = partDataDic[part] else {
//                fatalError()
//            }
//        return
//            partData.dimension.returnValue(id)
//    }
    
    
//    
//    func getEditedOrDefaultOriginOffsetX(
//        _ name: String
//    )
//        -> PositionAsIosAxes {
//
//        return
//            userEditedSharedDics.parentToPartOriginOffsetUserEditedDic[name] ?? ZeroValue.iosLocation
//    }
//    
//    
//    func dimensionWithModifiedPropertyX(
//        _ value: Double,
//        _ dimension: Dimension3d,
//        _ property: PartTag
//    ) -> Dimension3d {
//        switch property {
//        case .height:
//            return
//                (
//                    width: dimension.width,
//                    length: dimension.length,
//                    height: value
//                )
//        case .length:
//            return
//                (
//                    width: dimension.width,
//                    length: value,
//                    height:dimension.height
//                )
//        case.width:
//            return
//                (
//                    width: value,
//                    length: dimension.length,
//                    height:dimension.height
//                )
//        default: return dimension
//        }
//    }
    
    
//    ///the value may be for origin or dimension
//    ///origin may be x or y
//    ///dimension may be width or length
//    func setValueForBilateralPartInUserEditedDicX(
//        _ partToEdit: Part,
//        _ propertyToEdit: PartTag,
//        _ value: Double,
//        _ sidesAffected: SidesAffected? = nil) {
//    
//            //sometimes the UI part is not the part that is edtied
//        let part = PartsRequiringLinkedPartUse(partToEdit).partForDimensionEdit
//        var partOrLinkedPart: Part = .notFound
//        let allDimensionProperties: [PartTag] = [.width, .length, .height]
//        if value == 0.0 && allDimensionProperties.contains(propertyToEdit) {
//           //do not let dimensions cross zer0
//        } else {
//            
//            transformToStabiliserForDriveWheelModForOriginY ()
//
//            var sidesToEdit: SidesAffected
//            
//            if let unwrapped = sidesAffected {
//               sidesToEdit = unwrapped
//            } else {
//                sidesToEdit = choiceOfEditForSide
//            }
//            switch sidesToEdit {
//            case .both:
//                process(.id0)
//                process(.id1)
//            case.left:
//                process(.id0)
//            case.right:
//                process(.id1)
//            default:
//                break
//            }
//        }
//
//     
//        func process(
//            _ id: PartTag
//        ) {
//            let name = CreateNameFromIdAndPart(
//                id,
//                partOrLinkedPart
//            ).name
//            switch propertyToEdit {
//            case .length, .width, .height:
//                let currentDimension =
//                getEditedOrDefaultDimension(
//                    name,
//                    partOrLinkedPart,
//                    id
//                )
//                let newDimension =
//                dimensionWithModifiedProperty(
//                    value,
//                    currentDimension,
//                    propertyToEdit
//                )
//                UserEditedDictionariesService.shared.dimensionUserEditedDicModifier(
//                    [name: newDimension]
//                )
//            case .xOrigin, .yOrigin:
//                let currentOrigin = getEditedOrDefaultOriginOffset(
//                    name
//                )
//                let newOriginOffset = propertyToEdit == .xOrigin ? xOriginModified(
//                    currentOrigin,
//                    id
//                ) : yOriginModified(
//                    currentOrigin,
//                    id
//                )
//                UserEditedDictionariesService.shared.originOffsetUserEdtiedDicModifier(
//                    [name: newOriginOffset]
//                )
//            default: break
//            }
//        }
//            
//        func transformToStabiliserForDriveWheelModForOriginY () {
//            ///the static point is on the  common turn axis of the fixed wheels
//            ///increasing the stability of the main support by increasing the distance
//            ///between the main support and the drive wheels for a rear drive  wheelchair
//            ///therefore is an increase in stability rather than solely a motion of the drive wheels
//            ///however, it is cleaner to include y origin control of the drive wheelchair position
//            ///in the rear wheel menu rather than create a new stability menu
//            ///the code to do that is also conistant with the mid and front drive
//            let dic: [Part: Part] = [
//                .fixedWheelAtRear: .stabiliser,
//                .fixedWheelAtFront: .stabiliser,
//                .fixedWheelAtMid: .stabiliser,
//            ]
//            if let unwrapped = dic[part],  propertyToEdit == .yOrigin {
//                partOrLinkedPart = unwrapped
//        
//            } else {
//                partOrLinkedPart = part
//            }
//        }
//            
//            
//        func xOriginModified(_ origin: PositionAsIosAxes, _ id: PartTag) -> PositionAsIosAxes {
//            var mod: Double//eg armRest xMove '-' brings closer, but headRest moves left
//            
//            if getNoModRequiredX(part) {
//                mod = 1.0
//            } else {
//                mod = makeLeftAndRightMoveCloserWithNegAndApartWithPos()
//            }
//            let newOrigin =
//                (x: origin.x + value * mod,
//                 y: origin.y,
//                 z: 0.0)
//            return newOrigin
//            
//            func makeLeftAndRightMoveCloserWithNegAndApartWithPos() -> Double {
//                var reverseDirection = 1.0
//                if choiceOfEditForSide == .both {
//                    reverseDirection = id == .id1 ? 1.00: -1.00
//                }
//                return reverseDirection
//            }
//        }
//            
//            
//        func getNoModRequiredX(_ part: Part) -> Bool{
//            let exclusionsForAlwaysUniPart: [Part] = [
//                .mainSupport,
//                .backSupport,
//                .backSupportHeadSupport
//            ]
//            return
//                exclusionsForAlwaysUniPart.contains(part) ? true: false
//        }
//        
//        
//        func yOriginModified(_ origin: PositionAsIosAxes, _ id: PartTag) -> PositionAsIosAxes {
//            return
//                (x: origin.x,
//                y: origin.y + value,
//                z: 0.0)
//        }
//    }
}
