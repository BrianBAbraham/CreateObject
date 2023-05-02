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
  
    
    mutating func add(_ dictionary: PositionDictionary ) {
//print("adding")
//print(objects.count)
//print("")
        objects.append(Object( id: UUID().uuidString, object: dictionary))
    }
    
    struct Object: Identifiable {
        var id: String
        var object: PositionDictionary

    }
}

class SceneViewModel: ObservableObject {
    //static let initialScene: [HashableDictionaryTouple] = []
    @Published private var sceneModel: SceneModel
    init() {
print("scene view intialised")
        sceneModel = SceneModel(objects: [])    }

}


extension SceneViewModel {
    
    func addObject(_ dictionary: PositionDictionary ) {
        
//        let uuid = UUID()
//
//        let newObject = (id: uuid, object: dictionary)
        
        sceneModel.add(dictionary)
    }
    
    func getAllObjects()
    -> [SceneModel.Object] {
        sceneModel.objects
    }
}
