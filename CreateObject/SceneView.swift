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
    var dictionary: PositionDictionary{
        objectPickVM.getCurrentObjectDictionary()
    }
    
    var body: some View {
            Button(action: {
                sceneVM.addObject(dictionary)

            }, label: {
                Text("add to scene")
                    .foregroundColor(.blue)
            } )
    }
    
    
}

struct SceneView: View {
    @EnvironmentObject var sceneVM: SceneViewModel
    var allObjects: [SceneModel.Object]  {sceneVM.getAllObjects()}

    var body: some View {
        
        //let numberOfObjects = objects.count
        ZStack {
            ForEach(allObjects) { objectAndId in
                ObjectView(GetUniqueNames(objectAndId.object).forPart)
            }
            .scaleEffect(0.5)
        }

        //.position(x: 200, y: 200)

    }
}

struct SceneView_Previews: PreviewProvider {
    static var previews: some View {
        SceneView()
    }
}
