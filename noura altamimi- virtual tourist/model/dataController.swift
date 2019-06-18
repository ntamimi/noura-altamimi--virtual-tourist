//
//  dataController.swift
//  noura altamimi- virtual tourist
//
//  Created by noura tamimi on 15/06/2019.
//  Copyright © 2019 noura tamimi. All rights reserved.
//

import Foundation
import CoreData

class DataController{
    static let shared = DataController()
    let container = NSPersistentContainer(name: "virtualTourist")
    var viewContext:NSManagedObjectContext{
        return container.viewContext
    }
    
    func load(){
        self.container.loadPersistentStores{ (storeDescription,error)
            in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
        }
    }
}
