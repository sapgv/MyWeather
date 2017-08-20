//
//  City+CoreDataProperties.swift
//  MyWeather
//
//  Created by Гриша on 20.08.17.
//  Copyright © 2017 sapgv. All rights reserved.
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var name: String?

}
