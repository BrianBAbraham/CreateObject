//
//  SceneVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 02/05/2023.
//

import Foundation

struct SceneModel {
    var objects: [PositionDictionary]

    
}

class SceneViewModel: ObservableObject {
    static let initialScene: [[String: PositionAsIosAxes]] = []
    
    
    @Published private var sceneModel: SceneModel =
    SceneModel(objects: initialScene)
}


extension SceneViewModel {
    
    func addObject(_ dictionary: PositionDictionary ) {
        sceneModel.objects.append(dictionary)
    }
    
    func getAllObjects()
    -> [PositionDictionary] {
        sceneModel.objects
    }
}
