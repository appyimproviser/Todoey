//
//  ViewController.swift
//  Todoey
//
//  Created by Arpit Garg on 23/03/18.
//  Copyright © 2018 Arpit Garg. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    let realm = try! Realm()
    var todoItems : Results<Item>?
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
//        print(dataFilePath!)
//        let newItem = Item()
//        newItem.title = "Find Mike"
//        todoItems.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "Buy Eggos"
//        todoItems.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Destroy Demogorgon"
//        todoItems.append(newItem3)
        
//        loadItems()
        // Do any additional setup after loading the view, typically from a nib.
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item]{
//            todoItems = items
//        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK- TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }

    
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoitemCell", for: indexPath)
        if let item = todoItems?[indexPath.row]{
        
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        
    }else{
        cell.textLabel?.text = "No Items Added"
    }
    
    return cell
    
    }

    //MARK-TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
         if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                }
            }catch{
                print("error in saving done status \(error)")
            }
        }
        tableView.reloadData()
        // print(todoItems[indexPath.row])
//        if todoItems[indexPath.row].done == false {
//            todoItems[indexPath.row].done = true
//        }else{
//            todoItems[indexPath.row].done = false
//        }
//        todoItems?[indexPath.row].done = !(todoItems?[indexPath.row].done)!
//        context.delete(todoItems[indexPath.row])
//        todoItems.remove(at: indexPath.row)
//                saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK-AddNew items Section
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

        var textField = UITextField()
        let alert = UIAlertController(title: " Add New ToDoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action)in
            //Wat will happen once the user clicks the add item button on UIAlert

//            let newItem = Item(context: self.context)
         if let currentCategory = self.selectedCategory{
            do{
                try self.realm.write{
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                }
               }catch{
                        print("error in savind data \(error)")
            }
          }
            self.tableView.reloadData()
        }
    
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField

     }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK- Model manipulated Methods
//        func saveItems(item : Item){
//
//        do{
//            try realm.write {
//                realm.add(item)
//            }
//        }catch{
//            print("Error saving data:, \(error)")
//        }
//
//        tableView.reloadData()
//    }
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)

        tableView.reloadData()
        }
    
    
}


//MARK- Search Bar Methods
extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()

    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()

            }
        }
    }
}

