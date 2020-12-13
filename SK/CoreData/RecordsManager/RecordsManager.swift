//
//  RecordsManager.swift
//  SK
//
//  Created by admin on 23.11.2020.
//  Copyright © 2020 admin. All rights reserved.
//

import CoreData
import UIKit

class RecordsManager {
    
    static let shared = RecordsManager()
    
    var appDelegate: AppDelegate?
    var viewContext: NSManagedObjectContext?
    
    init() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            self.appDelegate = appDelegate
            viewContext = appDelegate.persistentContainer.viewContext
        } else {
            self.appDelegate =  nil
            viewContext = nil
        }
    }
    
    //MARK: - Public
    
    func addRecord(score: Int64) -> Bool {
        guard let viewContext = viewContext else { return false }
        let newRecord = Record(context: viewContext)
        newRecord.score = score
        viewContext.insert(newRecord)
        appDelegate?.saveContext()
        return true
    }
    
    func getRecords() -> [Record] {
        guard let viewContext = viewContext else { return [] }
        let fetchRequest: NSFetchRequest<Record> = Record.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "score", ascending: false)]
        fetchRequest.fetchLimit = 5
        var records = [Record]()
        do {
            let fetchedRecords = try viewContext.fetch(fetchRequest)
            records = fetchedRecords
        } catch {
            fatalError("Unresolved error")
        }
        return records
    }
}
