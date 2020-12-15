//
//  AddBookViewController.swift
//  BookManager
//
//  Created by CTW00517 on 01/11/2020.
//

import UIKit

class AddBookViewController: UIViewController {
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtAuthor: UITextField!
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    var items: [Book]?
    
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
        
        let book = Book(context: context)
        let author = Author(context: context)
        
        book.title = txtTitle.text
        book.price = txtPriceFloat
        author.name = txtAuthor.text
        
        author.addToBooks(book)
        
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
