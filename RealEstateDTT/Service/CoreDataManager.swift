//
//  CoreDataManager.swift
//  RealEstateDTT
//
//  Created by Patrick Rugebregt on 22/02/2022.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "RealEstateDTT")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func fetchHouses() -> [House] {
        let request: NSFetchRequest<HouseCoreData> = HouseCoreData.fetchRequest()
        do {
            let result = try persistentContainer.viewContext.fetch(request) as! [House]
            print(result)
            return result
        } catch {
            print(error)
        }
        return []
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveHouses(_ houses: [House]) {
        for house in houses {
            let houseCoreData = HouseCoreData(context: persistentContainer.viewContext)
            houseCoreData.image = house.imageData
            houseCoreData.bedrooms = Int16(house.bedrooms)
            houseCoreData.bathrooms = Int16(house.bathrooms)
            houseCoreData.zip = house.zip
            houseCoreData.city = house.city
            houseCoreData.latitude = Int16(house.latitude)
            houseCoreData.longitude = Int16(house.longitude)
            houseCoreData.descriptionString = house.descriptionString
            houseCoreData.price = Int16(house.price)
            houseCoreData.size = Int16(house.size)
        }
        saveContext()
    }
    
}
