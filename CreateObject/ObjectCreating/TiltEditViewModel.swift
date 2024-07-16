//
//  TiltEditViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 29/06/2024.
//

import Foundation
import Combine
import SwiftUI

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
        let partName =
            CreateNameFromIdAndPart(.id0, part).name

        return
            angleMinMaxDic[partName] ?? ZeroValue.angleMinMax
    }
    
}

class PropertyAngleViewModel: ObservableObject,
    SharedPartToEditFunc,
    SharedInitialSliderValueFuncOnly,
    SharedDimensionPropertyToEdit,
    SharedModifyObjectByCreatingFromNameFuncOnly{
    @Published var angleMinMaxDic = ObjectDataService.shared.angleMinMaxDic
    
    @Published var partToEdit = ObjectEditService.shared.partToEdit
    
   
    
    var objectType = ObjectDataService.shared.objectType
    
    var partDataDic: [Part : PartData] = ObjectDataService.shared.partDataDic
    
    var choiceOfEditForSide: SidesAffected = ObjectEditService.shared.choiceOfEditForSide
    
    var userEditedSharedDics: UserEditedDictionaries = UserEditedDictionariesService.shared.userEditedSharedDics
    
    var dimensionPropertyToEdit = ObjectEditService.shared.dimensionPropertyToEdit
    
    @Published var min: Double = 0.0
    
    @Published var max: Double = 0.0
    
    internal var cancellables: Set<AnyCancellable> = []
    
    
    var sliderValueBinding: Binding<Double> {
        Binding<Double>(
            get: {
                self.getInitialSliderValue(
                    self.partToEdit,
                    self.dimensionPropertyToEdit
                )
            },
            set: { newValue in
                    self.setCurrentRotation(
                        self.max - newValue,
                        self.partToEdit
                    )
                self.modifyObjectByCreatingFromName()
                
            }
        )
    }

    init() {
        let angleMinMax = getAngleMinMaxDic(partToEdit)
        max = angleMinMax.max.value
        min = angleMinMax.min.value

        let _ = ObjectDataMediator.shared
        
        (self as SharedPartToEditFunc).subscribeToService()
        
        (self as SharedDimensionPropertyToEdit).subscribeToService()
        
        ObjectDataService.shared.$angleMinMaxDic
            .sink { [weak self] newData in
                self?.angleMinMaxDic = newData
            }
            .store(in: &self.cancellables)
        
        
        
    }
    
    func getAngleMinMaxDic(_ part: Part)
    -> AngleMinMax {
        let partName =
            CreateNameFromIdAndPart(.id0, part).name

        return
            angleMinMaxDic[partName] ?? ZeroValue.angleMinMax
    }
    
    
    
    func handlePartToEditChange(_ newData: Part) {
        
    }
    
    
    func setCurrentRotation(
        _ maxMinusSliderValue: Double,
        _ part: Part
    ) {
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
}
