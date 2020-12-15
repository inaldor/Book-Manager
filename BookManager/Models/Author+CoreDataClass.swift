//
//  Author+CoreDataClass.swift
//  BookManager
//
//  Created by Inaldo Ramos Ribeiro on 13/12/2020.
//
//

import Foundation
import CoreData
import UIKit

@objc(Author)
public class Author: NSManagedObject {

    class public func getAll() throws -> [Author]? {
        let appDelegate: (AppDelegate?) = (UIApplication.shared.delegate as? AppDelegate)
        
        let context = appDelegate?.persistentContainer.viewContext
        
        return try context?.fetch(Author.fetchRequest()) as? [Author]
    }
    
}
