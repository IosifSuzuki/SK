//
//  Record+CoreDataProperties.swift
//  SK
//
//  Created by admin on 23.11.2020.
//  Copyright © 2020 admin. All rights reserved.
//
//

import Foundation
import CoreData


extension Record {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Record> {
        return NSFetchRequest<Record>(entityName: "Record")
    }

    @NSManaged public var score: Int64

}
