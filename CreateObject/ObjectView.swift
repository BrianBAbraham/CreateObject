//
//  ObjectView.swift
//  CreateObject
//
//  Created by Brian Abraham on 10/04/2023.
//

import SwiftUI

struct ObjectView: View {
    @GestureState private var startLocation: CGPoint? = nil
    @GestureState private var fingerLocation: CGPoint? = nil
    @State private var location = CGPoint (x: 300, y: 300)
    
    @State var currentZoom: CGFloat = 0.0
    @State var lastCurrentZoom: CGFloat = 0.0
    private var  minimumZoom: Double {
        0.1
    }
    private var maximimumZoom = 3.0
    var zoom: CGFloat {
        limitZoom( 0.6 + currentZoom + lastCurrentZoom)
    }
    func limitZoom (_ zoom: CGFloat) -> CGFloat {
       return max(min(zoom, maximimumZoom),minimumZoom)
    }
    
    var objectDrag: some Gesture {
        DragGesture()
            .onChanged { value in
                var newLocation = startLocation ?? location // 3
                newLocation.x += value.translation.width
                newLocation.y += value.translation.height
                self.location = newLocation
            }.updating($startLocation) { (value, startLocation, transaction) in
                startLocation = startLocation ?? location // 2
            }
    }
    
    @EnvironmentObject var vm: ObjectPickViewModel
    @State var defaultDictionaryAsList = [""]
    let sizeToEnsureObjectRemainsOnScreen = Screen.smallestDimension
    
    var uniquePartNames: [String] {
        vm.getUniquePartNamesFromObjectDictionary()
    }
    
//        var addDefaultDictionaryButtonView: some View {
//                Button(action: {
//                    defaultDictionaryAsList =
//                    vm.getList()
//                }, label: {
//                    Text("add")
//                        .foregroundColor(.blue)
//                } )
//        }
    
    var body: some View {

            ZStack {
                ForEach(uniquePartNames, id: \.self) { name in
                    PartView(uniquePartName: name)
                }
            //OriginView(originDictionary:  vm.getAllPartFromPrimaryOriginDictionary())
            //MyCircle(fillColor: .red, strokeColor: .black, 40, CGPoint(x: 0, y:0))
            }
            .frame(width: sizeToEnsureObjectRemainsOnScreen , height: sizeToEnsureObjectRemainsOnScreen )
            .background(Color.white.opacity(0.0001) )
 
            .position(location)
            .gesture(
                objectDrag
            )
            .scaleEffect(zoom)
            .gesture(MagnificationGesture()
                .onChanged { value in
                    currentZoom = value - 1
                }
                .onEnded { value in
                    lastCurrentZoom += currentZoom
                    currentZoom = 0.0
                }
             )



    }
}

struct ObjectView_Previews: PreviewProvider {
    static var previews: some View {
        ObjectView()
    }
}
