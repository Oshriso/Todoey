//
//  ViewController.swift
//  Todoey
//
//  Created by Dev2 on 8/15/18.
//  Copyright © 2018 Dev2. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    var realm = try! Realm()
    @IBOutlet weak var searchBar: UISearchBar!
    var items : Results<Item>?
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    //TableView data source methods:
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        // set the text from the data model
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
        
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else {
            cell.textLabel?.text = "No Items added"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    //TableView delgete method:
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = items?[indexPath.row]{
            do{
                try realm.write {//for update the done property
                    item.done = !item.done
                }
            }
            catch {
                print("Error on saving done status")
            }
        }
        
        tableView.reloadData()
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
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {//for add new task!
                            let newItem = Item()
                            newItem.title = textFiled.text!
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                        }
                    }
                    catch{
                        print("Error saving new items")
                    }
                }
                self.tableView.reloadData()
            }
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textFiled = alertTextField //save refernce to the alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    

    
    func loadItems() {

       // print(Realm.Configuration.defaultConfiguration.fileURL)
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}

//MARK: Search bar methods:
extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //find the data:
        items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
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

