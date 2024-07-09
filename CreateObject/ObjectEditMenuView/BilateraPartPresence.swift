//
//  SwiftUIView.swift
//  CreateObject
//
//  Created by Brian Abraham on 11/03/2024.
//

import SwiftUI


struct ConditionalBilateralPartPresence: View {
    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var partOriginAndDimensionEditViewModel: PartOriginAndDimensionEditViewModel
//    var part: Part {
//        objectEditVM.getPartToEdit()
//    }
    
    var body: some View {
        let part = partOriginAndDimensionEditViewModel.partToEdit
        let showMenuStatus = objectShowMenuVM.getBilateralPresenceMenuStatus(part)
        if  showMenuStatus {
            BilateralPartPresenceView(
            )
        } else {
            EmptyView()
        }
    }
}



struct BilateralPartPresenceView: View {

    @EnvironmentObject var bilateralPartPresenceVM: BilateralPartPresenceViewModel

    var body: some View {
        
        HStack {
            Toggle("", isOn: bilateralPartPresenceVM.leftBinding)

            Text("L")
         
            Toggle("", isOn: bilateralPartPresenceVM.rightBinding)

            Text("R")
        }
    }
}


//import Combine
//
//struct MyStruct {
//    static let shared = MyStruct()
//    var firstProperty: Int = 0
//    var secondProperty: Int = 0
//}
//
//class MyStructService {
//    @Published var myStruct: MyStruct = MyStruct.shared
//    @Published var myStruct.first
//
//    static let shared = MyStructService()
//    
//    func setFirstProperty(_ value: Int){
//        myStruct.firstProperty = value
//    }
//    
//    func setSecondProperty(_ value: Int) {
//        myStruct.secondProperty = value
//    }
//}
//
//class MyStructViewModel {
//    var firstProperty: Int = MyStructService.shared.myStruct.firstProperty
//    var secondProperty: Int =
//        MyStructService.shared.myStruct.secondProperty
//    private var cancellables: Set<AnyCancellable> = []
//    
//    init() {
//        MyStructService.shared.$firstProperty
//            .receive(on: DispatchQueue.main)
//            .assign(to: \.firstProperty,on: self)
//            .store(in: &cancellables)
//        
//    }
//}

class MyDictionaryService: ObservableObject {
    @Published var userEditedSharedDics: UserEditedDictionaries = UserEditedDictionaries.shared
    
    
    
    static let shared = DictionaryService()
    
    func partIdsUserEditedDicModifier(_ entry: [Part: OneOrTwo<PartTag>]) {
        userEditedSharedDics.partIdsUserEditedDic += entry

    }
}
