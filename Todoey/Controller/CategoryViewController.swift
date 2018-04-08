//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Arpit Garg on 04/04/18.
//  Copyright © 2018 Arpit Garg. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    var categories : Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
        
    }

    //MARK: - TableView Dataource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "NO categories added yet"
        
        return cell
    }
    
    //MARK: -Data Manipulation Methods
    func save(category : Category){
        
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("error with saving data \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategory()  {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todoey category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            
            self.save(category: newCategory)
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    //MARK: - TableView Delegate Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinatioVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinatioVC.selectedCategory = categories?[indexPath.row]
        }
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    
}
