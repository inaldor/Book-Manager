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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        
        book.title = txtTitle.text
        book.price = txtPriceFloat
        book.authorName = txtAuthor.text
        
        do {
//            try (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
            try context.save()
            print("Book saved")
        } catch  {
            print("Failed to save object.")
            return
        }
        
        self.dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
