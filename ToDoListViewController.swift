//
//  ViewController.swift
//  todolist
//
//  Created by Elchin Mustafayev on 06/04/2018.
//  Copyright © 2018 Elchin Mustafayev. All rights reserved.
//

import UIKit
import CoreData
class  ToDoListViewController: UITableViewController {
    var selectedCategory : Category? {
        didSet {
                loadData()
        }
    }
    var itemArray = [Item]()
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
     //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
      
        
       
        
    
        
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
       
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
            cell.textLabel?.text = item.title
       
            cell.accessoryType = item.done ? .checkmark : .none

            return cell
    }
    
    //MARK - check/uncheck the item
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print ("\(itemArray[indexPath.row].title!)")
        
       // context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveData()

        tableView.deselectRow(at: indexPath, animated: true)

        
    }
    
    
    //MARK - Add new items to the to do list
    
    
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item into the To Do list", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            // Add item
           
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            self.saveData()
            

            }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item"
            textField = alertTextField
         
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK - Save the date
    
    func saveData () {
        
        do {
            try context.save()
            print ("Data Saved")
        }
        catch {
            print ("The data could not be saved \(error)")
        }
        self.tableView.reloadData()

    }
    //MARK - Load the data
    
    func loadData(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {

      let categoryPredicate = NSPredicate(format : "parentCategory.categoryName MATCHES %@", selectedCategory!.categoryName!)
        
        if let additionalPredicate = predicate {
         request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
         print ("\(selectedCategory!.categoryName!)")
        
        do {
            itemArray = try  context.fetch(request)}
        catch {
            print ("The data could not be loaded \(error)")
        }
        tableView.reloadData()
        
    
    }
    

    
    

    
    
}

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format : "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key : "title", ascending : true)]
        loadData(with: request, predicate: predicate)
        }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            self.loadData()
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
            }
            
        }
      
    }
    
}

