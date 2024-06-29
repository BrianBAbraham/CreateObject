//
//  TiltEditViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 29/06/2024.
//

import Foundation
import Combine

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
