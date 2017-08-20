//  Created by Гриша on 20.08.17.
//  Copyright © 2017 sapgv. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CitiesService: NSObject {

    var cities: [City] = [City]()
    
    static let shared: CitiesService = {
        let instance = CitiesService()
        instance.updateCities()
        return instance
    }()

    func updateCities() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.managedObjectContext
        
        do {
            cities = try managedContext.fetch(City.fetchRequest())
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func fetchList(cityName: String) -> [List] {
    
        var list = [List]()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return list
        }
        let managedContext = appDelegate.managedObjectContext
        
        do {
            list = try managedContext.fetch(List.fetchRequestCity(name: cityName))
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return list
    }
}
