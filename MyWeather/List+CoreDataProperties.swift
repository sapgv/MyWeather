//
//  List+CoreDataProperties.swift
//  MyWeather
//
//  Created by Гриша on 21.08.17.
//  Copyright © 2017 sapgv. All rights reserved.
//

import Foundation
import CoreData


extension List {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<List> {
        return NSFetchRequest<List>(entityName: "List")
    }
    
    @nonobjc public class func fetchRequestCity(name: String) -> NSFetchRequest<List> {
        
        let predicate = NSPredicate(format: "name = %@", name)
        let request = NSFetchRequest<List>(entityName: "List")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        request.predicate = predicate
        
        return request
        
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var temp: String?

}
