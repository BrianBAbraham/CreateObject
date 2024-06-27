//
//  SceneVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 02/05/2023.
//

import Foundation

//struct SceneModel {
//    var objects: [(id: UUID, object: PositionDictionary) ]
//
//
//}

struct SceneModel {
    private (set) var objects: [Object]
  
    
    mutating func add(_ dictionary: PositionDictionary, _ name: String ) {
//print("adding")
//print(objects.count)
//print("")
        objects.append(Object( id: UUID().uuidString, object: dictionary, name: name))
    }
    
    struct Object: Identifiable {
        var id: String
        var object: PositionDictionary
        var name: String
    }
}

class SceneViewModel: ObservableObject {
    @Published private var sceneModel: SceneModel
    init() {
print("scene view intialised")
        sceneModel = SceneModel(objects: [] )}

}


extension SceneViewModel {
    
    func addObject(_ dictionary: PositionDictionary, _ name: String ) {
        sceneModel.add(dictionary, name)
    }
    
    func getAllObjects()
    -> [SceneModel.Object] {
        sceneModel.objects
    }
}
