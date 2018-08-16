//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Dev2 on 8/16/18.
//  Copyright © 2018 Dev2. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
                let newCategory = Category(context: self.context)
                newCategory.name = textFiled.text!
                self.categoryArray.append(newCategory)
                
                self.SaveData()
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
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    

    //MARK: - Data manipulation methods:
    func SaveData() {
        
        do{
            try context.save()
        }
        catch{
            print("Error in save data!")
        }
        tableView.reloadData()
    }
    
    func loadItems() {
        
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do{
            try categoryArray = context.fetch(request)
        }
        catch{
            print("Error on load data!")
        }
    }
    
    //MARK: - TableView delegate methods:
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let index = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[index.row]
        }
    }
    
}
