//
//  SceneView.swift
//  CreateObject
//
//  Created by Brian Abraham on 02/05/2023.
//

import SwiftUI

struct AddToSceneView: View {
    @EnvironmentObject var sceneVM: SceneViewModel
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    let dictionary: PositionDictionary
    let name: String
    
    init(
        _ dictionary: PositionDictionary,
        _ name: String) {
            self.dictionary = dictionary
            self.name = name
        }
//    var dictionary: PositionDictionary{
//        objectPickVM.getCurrentObjectDictionary()
//    }
//    var name: String {
//        objectPickVM.getCurrentObjectName()
//    }
    
    var body: some View {
            Button(action: {
                sceneVM.addObject(objectPickVM.getPostTiltOneCornerPerKeyDic(), name)

            }, label: {
                Text("add to scene")
                    .foregroundColor(.blue)
            } )
    }
    
    
}

//struct SceneView: View {
//    @EnvironmentObject var sceneVM: SceneViewModel
//    @EnvironmentObject var objectPickVM: ObjectPickViewModel
//
//    var allObjects: [SceneModel.Object]  {sceneVM.getAllObjects()}
//
//    var body: some View {
//
//        ScrollView (.vertical, showsIndicators: true){
//{
//            VStack {
//                ForEach(allObjects) { objectAndId in
//                    HStack {
//                        ObjectView(
//                            GetUniqueNames(objectAndId.object).forPart,
//
//                            objectAndId.name)
//                        Text(objectAndId.name)
//                    }
//
//                }
//                .scaleEffect(0.5)
//            }
//
//
//        }
//    }
//}

//struct SceneView_Previews: PreviewProvider {
//    static var previews: some View {
//        SceneView()
//    }
//}
