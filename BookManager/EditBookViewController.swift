//
//  EditBookViewController.swift
//  BookManager
//
//  Created by Inaldo Ramos Ribeiro on 12/12/2020.
//

import UIKit

class EditBookViewController: UIViewController {
    
    @IBOutlet weak var titletxtField: UITextField!
    @IBOutlet weak var priceTxtField: UITextField!
    @IBOutlet weak var authorTxtField: UITextField!
    
    var bookTitle: Book?
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        bookTitle?.title = titletxtField.text
//        bookTitle?.price = txtPriceFloat
//        bookTitle?.authorName = authorTxtField.text
        
        let formatter = NumberFormatter()
        //formatter.numberStyle = .curren
        
        titletxtField.text = bookTitle?.title
        priceTxtField.text = formatter.string(from: NSNumber(value: bookTitle?.price ?? 0.0))
        authorTxtField.text = bookTitle?.authorName

//        do {
//            self.items = try Book.getAll()
//            print("Books fetched.")
//        } catch {
//            print("Error fetchet books.")
//        }

        // Do any additional setup after loading the view.
    }
    
    func editItem() {
        
        guard let context = self.context else { return }
        
        //guard let book = self.items else { return }
        
        guard let txtPriceFloat = NumberFormatter().number(from: priceTxtField.text ?? "")?.floatValue else {
            print("Failed to parse price.")
            return
        }
        
//        for x in book {
//
//            if x.title == bookTitle {
//
//                x.title = titletxtField.text
//                x.price = txtPriceFloat
//                x.authorName = authorTxtField.text
//            }
//        }
//
        
        bookTitle?.title = titletxtField.text
        bookTitle?.price = txtPriceFloat
        bookTitle?.authorName = authorTxtField.text
        
        do {
            try context.save()
            print("Book edited")
            self.dismiss(animated: true, completion: nil)
        } catch  {
            print("Failed to edit object.")
            return
        }
    }
    
    @IBAction func editAction(_ sender: UIButton) {
        
        editItem()
        
    }
}
