//
//  ViewController.swift
//  Todoey
//
//  Created by Dev2 on 8/15/18.
//  Copyright © 2018 Dev2. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    let defualts = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Find mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem.title = "buy"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem.title = "save"
        itemArray.append(newItem3)
        
        if let items = defualts.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        }
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
              let newItem = Item()
              newItem.title = textFiled.text!
              self.itemArray.append(newItem)
              self.defualts.set(self.itemArray, forKey: "TodoListArray")
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
    
}

