//
//  EditObjectMenuView.swift
//  CreateObject
//
//  Created by Brian Abraham on 10/04/2023.
//

import SwiftUI

//struct SliderAccentColor: ViewModifier {
//    @EnvironmentObject var vm: ChairManoeuvreProjectVM
//    var grayOutSlider: Color {
//        vm.getIsAnyChairSelected() ? .blue: .gray
//    }
//    func body(content: Content) -> some View {
//        content
//            .accentColor(grayOutSlider)
//    }
//}

struct EditObjectMenuView: View {
    var dictionary: PositionDictionary = [:]
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var objectEditVM: ObjectMenuShowViewModel
    
    
    init(){
    }
    
    

    
    var body: some View {
        
        let dictionary = objectPickVM.getAngleDic()
    
        if objectPickVM.getCurrentObjectType() ==
            .allCasterTiltInSpaceShowerChair {
//            MyCircle(fillColor: .red, strokeColor: .black, 500.0 ,  CGPoint(x:100.0, y: 100.0))
            
        } else {
            EmptyView()
        }
        if objectPickVM.getCurrentObjectName().contains(ObjectTypes.showerTray.rawValue) {
            //FootSupportWithoutHangerInOnePieceSlider(dictionary)
        } else {
            EmptyView()
        }
  

    }

  
    
}

//struct EditObjectMenuView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditObjectMenuView()
//            .environmentObject(ObjectPickViewModel())
//    }
//        
//}

/// 
