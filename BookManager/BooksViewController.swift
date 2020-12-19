//
//  BooksViewController.swift
//  BookManager
//
//  Created by CTW00517 on 01/11/2020.
//

import UIKit
import CoreData

class BooksViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    
    var items: [Book]?
    var authors: [Author]?
    
    var bookTitle: Book?
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.refreshControl.addTarget(self, action: #selector(reloadBooks), for: .valueChanged)
        tableView.refreshControl = self.refreshControl
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reloadBooks()
        
        for x in authors! {
            
            print(x.books)
            
        }
    }
    
    @objc fileprivate func reloadBooks() {
        if !refreshControl.isRefreshing {
            refreshControl.beginRefreshing()
        }
        
        do {
            self.items = try Book.getAll()
            print("Books fetched.")
            self.authors = try Author.getAll()
            print("Authors fetched.")
        } catch {
            print("Error fetchet books or authors.")
        }
        
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }
}

extension BooksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let author = self.authors?[section] else { return 0 }
        
        return author.books?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let authors = self.authors else { return 0 }
    
        return authors.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let author = self.authors?[section] else { return "" }
        
        return author.name
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        //guard let book = self.items?[indexPath.row] else { return cell }
        
        guard let author = self.authors?[indexPath.section] else { return cell }
        
        //author.books?.allObjects
        
        guard let book = author.books?.allObjects[indexPath.row] as? Book else { return cell }
        
        cell.textLabel?.text = book.title //book.title
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
        
        bookTitle = book
        
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
