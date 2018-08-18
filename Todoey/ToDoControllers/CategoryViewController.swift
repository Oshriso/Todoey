//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Dev2 on 8/16/18.
//  Copyright © 2018 Dev2. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    var categories : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
   
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {//add new categories
        
        var textFiled = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "" , preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            //what will happen when user clicks the add item Button!
            if textFiled.text != ""
            {
                let newCategory = Category()
                newCategory.name = textFiled.text!
                
                self.SaveData(category: newCategory)
            }
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textFiled = alertTextField //save refernce to the alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView Datasource methods:
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        // set the text from the data model
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added yet"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    

    //MARK: - Data manipulation methods:
    func SaveData(category: Category) {
        
        do{
            try realm.write {
                realm.add(category)
            }
        }
        catch{
            print("Error in save data!")
        }
        tableView.reloadData()
    }
    
    func loadItems() {
        
        categories = realm.objects(Category.self)
    }
    
    //MARK: - TableView delegate methods:
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let index = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[index.row]
        }
    }
    
}
