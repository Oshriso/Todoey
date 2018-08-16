//
//  ViewController.swift
//  Todoey
//
//  Created by Dev2 on 8/15/18.
//  Copyright © 2018 Dev2. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    var itemArray = [Item]()
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    //TableView data source methods:
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        // set the text from the data model
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //TableView delgete method:
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        SaveData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //Add new Item:
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textFiled = UITextField()
        
        let alert = UIAlertController(title: "Add new item", message: "" , preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            //what will happen when user clicks the add item Button!
            if textFiled.text != ""
            {
              let newItem = Item(context: self.context)
              newItem.title = textFiled.text!
              newItem.done = false
              newItem.parentCategory = self.selectedCategory
              self.itemArray.append(newItem)
              
              self.SaveData()
            }
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textFiled = alertTextField //save refernce to the alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func SaveData() {
        
        do {
         
            try context.save()
        }
        catch{
            print(error)
        }
    
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {

        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates:[categoryPredicate,addtionalPredicate])
        }
        else {
                  request.predicate = categoryPredicate
        }
        
        do{
           itemArray =  try context.fetch(request)
        }
        catch{
            print("Error fetching data from context")
        }
        tableView.reloadData()
    }
}

//MARK: Search bar methods:
extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //find the data:
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 { //delete
            loadItems()
            
            DispatchQueue.main.async { //do that the operation inside is doing by the main thread
                searchBar.resignFirstResponder() //remove the keyBorad from the screen
            }
        }
    }
    
    

    
}

