//
//  Save.swift
//  CreateObject
//
//  Created by Brian Abraham on 13/02/2023.
//

import Foundation
import SwiftUI
import CoreData


class CoreDataViewModel: ObservableObject {
    //static let instance = CoreDataViewModel()
    
    let container: NSPersistentContainer
//       var vm: RectangleVM
    
    @Published var savedEntities: [LocationEntity] = []
//
    init() {
        //vm = rectangleVM
        container = NSPersistentContainer(name: "ObjectContainer")
        container.loadPersistentStores { [self] (description, error) in
            if let error = error {
                print("ERROR LOADING CORE CATA \(error)")
            } else {
                print("CORE DATA LOADED")
            }
            fetchNames()
        }

    }
//
    func fetchNames() {
        let request = NSFetchRequest<LocationEntity>(entityName: "LocationEntity")
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("ERROR FETCHING \(error)")
        }
    }
//
    func addObject(names: String, values: String, objectType: String, objectName: String) {
        let new = LocationEntity(context: container.viewContext)
        new.interOriginNames = names
        new.interOriginValues = values
        new.objectType = objectType
        new.objectName = objectName
//objectType
//objectName
        saveData()
    }
    
    func deleteObject(_ indexSet: IndexSet) {
        guard let index = indexSet.first else {return}
        let entity = savedEntities[index]
        container.viewContext.delete(entity)
    }

    func deleteAllObjects() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "LocationEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try container.viewContext.execute(deleteRequest)
        } catch let error as NSError {
            // TODO: handle the error
        }
        
        saveData()
    }
    
    
    //
//    func deleteChair() {
//        let lastIndex = savedChairEntity.count - 1
//        let entity = savedChairEntity[lastIndex]
//        container.viewContext.delete(entity)
//        saveData()
//    }
//
    func saveData() {
        do {
            try container.viewContext.save()
            fetchNames()
        } catch let error {
            print("ERROR SAVING \(error)")
        }
    }
}
