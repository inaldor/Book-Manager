//
//  BooksViewController.swift
//  BookManager
//
//  Created by CTW00517 on 01/11/2020.
//

import UIKit

class BooksViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    
    var items: [Book]?
    
    var bookTitle = ""
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.refreshControl.addTarget(self, action: #selector(reloadBooks), for: .valueChanged)
        tableView.refreshControl = self.refreshControl
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reloadBooks()
    }
    
    @objc fileprivate func reloadBooks() {
        if !refreshControl.isRefreshing {
            refreshControl.beginRefreshing()
        }
        
        do {
            self.items = try Book.getAll()
            print("Books fetched.")
        } catch {
            print("Error fetchet books.")
        }
        
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
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

extension BooksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = self.items else {
            return 0
        }
        
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        guard let book = self.items?[indexPath.row] else { return cell }
        
        cell.textLabel?.text = book.title
        cell.detailTextLabel?.text = formatter.string(from: NSNumber(value: book.price))
        
        return cell
    }
    
    private func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let context = self.context else { return }
        
        guard let book = self.items?[indexPath.row] else { return }

        if editingStyle == .delete {
            
            tableView.beginUpdates()
            
            // We need to delete from 3 sources
            // First one from Source Array of items
            items?.remove(at: indexPath.row)
            
            // Second from the Table View
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // Third from the CoreData itself
            context.delete(book)
            
            tableView.endUpdates()
            
            do {
                try context.save()
                print("Book deleted")
            } catch  {
                print("Failed to delete object.")
                return
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        guard let book = self.items?[indexPath.row] else { return indexPath }
        
        bookTitle = book.title ?? ""
        
        return indexPath
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "editBook" {
            
            let destinationVC = segue.destination as! EditBookViewController
            destinationVC.bookTitle = bookTitle
        }
    }
}

extension BooksViewController: UITableViewDelegate {
    
}
