//
//  ContentView.swift
//  CreateObject
//
//  Created by Brian Abraham on 09/01/2023.
//

import SwiftUI
//import UIKit

struct EnterTextView: View {
    @State private var name: String = ""

    var body: some View {
        VStack(alignment: .leading) {
            TextField("", text: $name)
            //Text("Hello, \(name)!")
        }
    }
}



extension Double {
    func roundToNearest(_ increment: Double) -> Double {
        return (self / increment).rounded() * increment
    }
}


struct ListView: View {
    let equipmentName: String
    let list: [String]
    
    init(
        _ equipmentName: String,
        _ list: [String]) {
            self.equipmentName = equipmentName
            self.list = list
        }
    
    var body: some View {
        VStack{
            Text(equipmentName)
            List{
                Section(header: Text("Dictionary")) {
                    ForEach (0..<list.count, id: \.self) { index in
                        Text("\(list[index])")
                    }
                }
            }
        }
    }
}





//Content view mediates data between view models
//All data is requested from view models
//All data is passed to view models to set model
struct ContentView: View {

    init(){
        //make segemented picker buttons brigher green when picked
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.green.withAlphaComponent(0.2)
        
        
        //Control the appearance of the navigation back button view
        let appearance = UINavigationBarAppearance()
       // appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 14)]
        appearance.largeTitleTextAttributes = [.font: UIFont.systemFont(ofSize: 18)]
        appearance.backgroundColor = .green
        appearance.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.2)// Or any other color
        appearance.buttonAppearance.normal.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 12)]
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
  
    var body: some View {
        
        NavigationView {
            VStack {
                
                
                NavigationLink(destination:
                    ObjectEditScreenView()
                )
                {Text("select-edit equipment")
                }
                .padding()
                  
                
                
                NavigationLink(destination:  
                    MovementMenuView() ) {
                    Text("edit movements")
                }
                
                
 
                NavigationLink(destination: 
                    Photo() ) {
                    Text("import plan from photos")}
                    .padding()
                
                Spacer()
                
                UnitSystemSelectionView()
            }
            .navigationBarTitle("main menu", displayMode: .inline)
           
        }
    }
}






struct ObjectEditScreenView: View {
    @EnvironmentObject var recenterVM: RecenterViewModel
   
    var recenterPosition: CGPoint = CGPoint(x:100, y:400)
    @State private var uniqueKey = 0
    

    var body: some View {
        ZStack{
            ObjectAndRulerView(
                ObjectDisplayStyle.edit
            )
            .position(recenterPosition)
            .onChange(of: recenterVM.getRecenterState()) {
                uniqueKey += 1
            }
           
            .id(uniqueKey)//ensures redraw
            
     
            VStack {
                ObjectRulerRecenterView()
                Spacer()
                
                ObjectAndPartEditMenuContainerView()
            }
        }
    }
}



   
