//
//  Book+CoreDataClass.swift
//  BookManager
//
//  Created by CTW00517 on 03/11/2020.
//
//

import Foundation
import CoreData
import UIKit

@objc(Book)
public class Book: NSManagedObject {

    class public func getAll() throws -> [Book]? {
        let appDelegate: (AppDelegate?) = (UIApplication.shared.delegate as? AppDelegate)
        
        let context = appDelegate?.persistentContainer.viewContext
        
        return try context?.fetch(Book.fetchRequest()) as? [Book]
    }
    
}
