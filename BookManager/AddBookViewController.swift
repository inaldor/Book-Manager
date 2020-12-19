//
//  AddBookViewController.swift
//  BookManager
//
//  Created by CTW00517 on 01/11/2020.
//

import UIKit
import CoreData

class AddBookViewController: UIViewController {
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtAuthor: UITextField!
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    var items: [Book]?
    
    
    var result: [Any]?
    
    //let authorFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Author")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            self.items = try Book.getAll()
            print("Books fetched.")
        } catch {
            print("Error fetchet books.")
        }
        
    }
    
    @IBAction func deleteButton(_ sender: UIButton) {
                
        guard let book = self.items else { return }
        
        guard let context = self.context else { return }
        
        for x in book {
            
            if x.authorName == "Paulo Coelho" {
                
                context.delete(x)
                
            }
        }
        
        do {
            try context.save()
            print("Book saved")
        } catch  {
            print("Failed to save object.")
            return
        }
    }
    
    
    @IBAction func cancelButtonTap(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func saveButtonTap(_ sender: UIBarButtonItem) {
        guard let context = self.context else { return }
        
        guard let txtPriceFloat = NumberFormatter().number(from: txtPrice.text ?? "")?.floatValue else {
            print("Failed to parse price.")
            return
        }
        
//        guard let authorName = author.name else { return [] }
//
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Author")
//        let predicate = NSPredicate(format: "name MATCHES %@", authorName)
//        fetchRequest.predicate = predicate
        
        let book = Book(context: context)
        let author = Author(context: context)
        
        guard let authorName = txtAuthor.text else { return }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Author")
        let predicate = NSPredicate(format: "name MATCHES %@", authorName)
        fetchRequest.predicate = predicate

        do {

            let resultRequest = try context.fetch(fetchRequest) as! [Author]
            
            if resultRequest.isEmpty {
                
                book.title = txtTitle.text
                book.price = txtPriceFloat
                author.name = txtAuthor.text
                
                author.addToBooks(book)
                
            } else {
                
                if authorName == resultRequest.first?.name {
                    
                    book.title = txtTitle.text
                    book.price = txtPriceFloat
                    
                    print(resultRequest)
                    
                    resultRequest.first?.addToBooks(book)
                    
                    //resultRequest.first?.books?.adding(book)
                    
                    //author.addToBooks(book)
                    
                    //authors.first.books.add(book)
                    
                }
                
//                for x in author.name! {
//
//                    if x == resultRequest.first?.name {
//                         print("already exist")
//                         //mainManagedObjectContext.deleteObject(x)
//                    }
//                }
//
                
//                for x in resultsArr {
//                   if x.id == id {
//                         print("already exist")
//                         mainManagedObjectContext.deleteObject(x)
//                       }
//                     }
                
//                book.title = txtTitle.text
//                book.price = txtPriceFloat
//
//                resultRequest
//
//                author.addToBooks(book)
            }
            
        } catch {
            print("not working")
        }
        
        
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Card")
//                var resultsArr:[Card] = []
//                do {
//                    resultsArr = try (mainManagedObjectContext!.fetch(fetchRequest) as! [Card])
//                } catch {
//                    let fetchError = error as NSError
//                    print(fetchError)
//                }
//
//         if resultsArr.count > 0 {
//          for x in resultsArr {
//            if x.id == id {
//                  print("already exist")
//                  mainManagedObjectContext.deleteObject(x)
//                }
//              }
//           }
        
        do {
            try context.save()
            print("Book and Author saved")
        } catch  {
            print("Failed to save object.")
            return
        }
        
        self.dismiss(animated: true)
    }
}
