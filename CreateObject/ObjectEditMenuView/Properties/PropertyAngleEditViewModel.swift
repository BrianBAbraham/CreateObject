//
//  PropertyAngleViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 29/06/2024.
//

import Foundation
import Combine
import SwiftUI


struct PropertyAngleEditView: View {
    @EnvironmentObject var vm: PropertyAngleEditViewModel
    var body: some View {
        ZStack{
            HStack{
                Text("angle")
                    .colorScheme(.light)

                Slider(value: vm.sliderValueBinding, in: vm.min...vm.max, step: 1.0)

                Text(" deg: \( Int(vm.max - vm.sliderValueBinding.wrappedValue))")
                    .colorScheme(.light)

            }
        }
        .opacity(vm.showMenu ? 1 : 0)
    }
}

class PropertyAngleEditViewModel: ObservableObject,
    SharedPartDataDic,
    SharedPartToEditFunc,
    SharedInitialSliderValueFuncOnly,
    SharedDimensionPropertyToEdit,
    SharedModifyObjectByCreatingFromNameFuncOnly,
    SharedObjectType,
      SharedUserEditedDictionaries {
//        
//    @Published var angleMinMaxDic = ObjectDataService.shared.angleMinMaxDic
    
    @Published var partToEdit = ObjectEditService.shared.partToEdit
    
   @Published var showMenu = false
    
   @Published var objectType = ObjectDataService.shared.objectType
    
    @Published  var partDataDic: [Part : PartData] = ObjectDataService.shared.partDataDic
    
    var choiceOfEditForSide: SidesAffected = ObjectEditService.shared.choiceOfEditForSide
    
    @Published var userEditedSharedDics: UserEditedDictionaries = UserEditedDictionariesService.shared.userEditedSharedDics
        
    @Published var dimensionPropertyToEdit = ObjectEditService.shared.dimensionPropertyToEdit
    
    @Published var min: Double = 0.0
    
    @Published var max: Double = 0.0
    
    internal var cancellables: Set<AnyCancellable> = []
    
    
    var sliderValueBinding: Binding<Double> {
        Binding<Double>(
            get: {let new =
                self.max -
                self.getInitialSliderValue(
                    self.partToEdit,
                    PartTag.angle)
                print("Getter: \(new)")
                    return new
            
            },
            set: { newValue in
                print("Setter newValue: \(newValue) \(self.max)")
                    self.setCurrentRotation(
                        self.max - newValue,
                        self.partToEdit
                    )
                self.modifyObjectByCreatingFromName()
                print("Updated rotation with: \(self.max - newValue)")
            }
        )
    }

    init() {
    
        let angleMinMax = getAngleMinMaxDic(getTiltMenuPart(partToEdit) ?? partToEdit)
        max = angleMinMax.max.value
        min = angleMinMax.min.value
        
        //print(max)

        let _ = ObjectDataMediator.shared
        
        (self as SharedObjectType).subscribeToService()
        
        (self as SharedPartDataDic).subScribeToService()
        
        (self as SharedPartToEditFunc).subscribeToService()
        
        (self as SharedDimensionPropertyToEdit).subscribeToService()
        
        (self as SharedUserEditedDictionaries).subscribeToService()
        
//        ObjectDataService.shared.$angleMinMaxDic
//            .sink { [weak self] newData in
//                self?.angleMinMaxDic = newData
//            }
//            .store(in: &self.cancellables)
    }
    

    
    
    func getAngleMinMaxDic(_ part: Part)
    -> AngleMinMax {
        let partName =
            CreateNameFromIdAndPart(.id0, part)
        print(partName)
//print(angleMinMaxDic[partName])
        let tiltMenuPart = getTiltMenuPart(part) ?? part
        
        return
        partDataDic[tiltMenuPart]?.minMaxAngle.returnValue(.id0) ?? ZeroValue.angleMinMax
    }
    
    
    
    func handlePartToEditChange(_ newData: Part) {
        if let tilter = TiltingAbility(newData, objectType).tilter {
            showMenu = true
           partToEdit = tilter
        } else {
            showMenu = false
        }
        
    }
    
    
    func setCurrentRotation(
        _ maxMinusSliderValue: Double,
        _ part: Part
    ) {
        
        print("Setting current rotation to: \(maxMinusSliderValue) for part: \(part)")
        var partName: String {
            CreateNameFromIdAndPart(.id0, part).name
        }
        let angleUserEditedDicEntry =
        [partName:
            (
                x:Measurement(
                    value: maxMinusSliderValue,
                    unit: UnitAngle.degrees
                ),
                y: ZeroValue.angle,
                z: ZeroValue.angle
            )]
        
        UserEditedDictionariesService.shared.angleUserEditedDicModifier(
            angleUserEditedDicEntry
        )
    }
    
        
    func getTiltMenuPart(_ part: Part) -> Part? {
        TiltingAbility(part, objectType).tilter
    }
}






class TiltEditViewModel: ObservableObject {
    @Published var angleMinMaxDic = ObjectDataService.shared.angleMinMaxDic
    private var cancellables: Set<AnyCancellable> = []
    

    init() {

        let _ = ObjectDataMediator.shared
        
        ObjectDataService.shared.$angleMinMaxDic
            .sink { [weak self] newData in
                self?.angleMinMaxDic = newData
            }
            .store(in: &self.cancellables)
        
        
        
    }
    
    func getAngleMinMaxDic(_ part: Part)
    -> AngleMinMax {
        print("DETECT")
        let partName =
            CreateNameFromIdAndPart(.id0, part).name
print(angleMinMaxDic[partName])
        return
            angleMinMaxDic[partName] ?? ZeroValue.angleMinMax
    }
    
}
