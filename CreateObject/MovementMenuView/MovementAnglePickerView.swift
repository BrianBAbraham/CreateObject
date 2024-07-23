//
//  MovementAnglePickerView.swift
//  CreateObject
//
//  Created by Brian Abraham on 20/07/2024.
//

import SwiftUI
import Combine

struct MovementAnglePickerView: View {

    @EnvironmentObject var movementAnglePickerVM: MovementAnglePickerViewModel
    
    var body: some View {
        HStack {
            ZStack {
                Picker(
                    "",
                    selection: movementAnglePickerVM.binding
                ) {
                    ForEach(
                        movementAnglePickerVM.menuItems,
                        id: \.self
                    ) { item in
                        Text(
                            item
                        )
                    }
                }
                //Start work around: removes grey background from iPhone 13 mini
                //physical device
                .opacityAndScaleToHidePickerLabel()
                
                DuplicatePickerText(name: movementAnglePickerVM.objectAngleName)
            }
            //End work around

            Text("angle")
                .colorScheme(.light)
        }
    }
}


class MovementAnglePickerViewModel: ObservableObject,                           SharedObjectAngleType {
    
    @Published var objectAngleName: String {
        didSet {
            setObjectAngleType()
        }
    }
    var binding: Binding<String> {
        Binding<String> (
            get: {self.objectAngleName},
            set: { newValue in
                self.objectAngleName = newValue
            }
        )
    }
    var objectAngleType: WhichAngle = MovementEditService.shared.objectAngleType
    
    let menuItems: [String] = WhichAngle.allCases.map {
        $0.rawValue
    }


    //EXTRACTIONS FROM DATA LAYER
    //intialise movement data
    //movement are single object data plus transformed object data
    //showing movment or movments
    
    internal var cancellables: Set<AnyCancellable> = []
    
    
    init(){
        objectAngleName = objectAngleType.rawValue

        (self as SharedObjectAngleType).subscribeToService()

    }
}


extension MovementAnglePickerViewModel {

    func setObjectAngleType(){
        objectAngleType = WhichAngle(rawValue: objectAngleName) ?? .end
        MovementEditService.shared.setObjectAngleType(objectAngleType)
    }

}
