//
//  ObjectPickerView.swift
//  CreateObject
//
//  Created by Brian Abraham on 10/04/2023.
//

import SwiftUI

struct PickObjectView: View {
    @EnvironmentObject var vm: ObjectPickViewModel
    
    var objectNames: [String] {
        BaseObjectTypes.allCases.map{$0.rawValue}
    }
    
    @State private var equipmentType = BaseObjectTypes.fixedWheelRearDrive.rawValue
    
    var currentEqipmentType: String {
        getCurrentEquipmentType()
    }

    func getCurrentEquipmentType() -> String {
        BaseObjectTypes.fixedWheelRearDrive.rawValue
    }
    
    var body: some View {
        let boundEquipmentType = Binding(
            get: {vm.getCurrentObjectType()},
            set: {self.equipmentType = $0}
        )
        
        Picker("Equipment",selection: boundEquipmentType ) {
            ForEach(objectNames, id:  \.self)
                    { equipment in
                Text(equipment)
            }
        }
        .onChange(of: equipmentType) {tag in
            self.equipmentType = tag
//            modifyEquipmentType(tag.rawValue)
            vm.setCurrentObjectType(tag)
        }
        .pickerStyle(.wheel)
        .scaleEffect(0.8)
    }
}

struct ObjectPickerView_Previews: PreviewProvider {
    static var previews: some View {
        PickObjectView()
            .environmentObject(ObjectPickViewModel())
    }
}
