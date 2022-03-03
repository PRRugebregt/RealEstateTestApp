//
//  CoreDataManager.swift
//  RealEstateDTT
//
//  Created by Patrick Rugebregt on 22/02/2022.
//

import Foundation
import CoreData

protocol HouseSaveableToDisk {
    func saveHouses(_ houses: [House])
    func updateCoreDataHouse(descriptionString: String, isFavorite: Bool)
}

protocol HouseFetchableFromDisk {
    func fetchHouses() -> [House]
}

class CoreDataManager: HouseSaveableToDisk, HouseFetchableFromDisk {
    
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
            let result = try persistentContainer.viewContext.fetch(request)
            var houses = [House]()
            for result in result {
                let house = House(id: Int(bitPattern: result.id),
                                  imageURL: result.imageURL!,
                                  descriptionString: result.descriptionString!,
                                  zip: result.zip!,
                                  city: result.city!,
                                  price: Int(result.price),
                                  bedrooms: Int(result.bedrooms),
                                  bathrooms: Int(result.bathrooms),
                                  size: Int(result.size),
                                  latitude: Double(result.latitude),
                                  longitude: Double(result.longitude),
                                  imageData: result.image,
                                  isFavorite: result.isFavorite)
                houses.append(house)
            }
            print("HOUSES COUNT COREDATA = \(houses.count)")
            return houses
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
            houseCoreData.price = Int64(house.price)
            houseCoreData.size = Int16(house.size)
            houseCoreData.imageURL = house.imageURL
            print("saving house")
        }
        saveContext()
    }
    
    // Update if house is saved as favorite
    func updateCoreDataHouse(descriptionString: String, isFavorite: Bool) {
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "HouseCoreData")
        request.predicate = NSPredicate(format: "descriptionString = '\(descriptionString)'")
        do {
            let result = try context.fetch(request)
            let resultData = result as! [HouseCoreData]
            let object = resultData[0]
            object.setValue(isFavorite, forKey: "isFavorite")
            print(object.isFavorite)
            saveContext()
        } catch {
            print(error)
        }
    }
    
}
