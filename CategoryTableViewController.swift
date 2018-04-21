//
//  CategoryTableViewController.swift
//  todolist
//
//  Created by Elchin Mustafayev on 16/04/2018.
//  Copyright © 2018 Elchin Mustafayev. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()

    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return categoryArray.count
    }
    
    
    // MARK: - dequeue / read table cells
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category", for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.categoryName
        
        return cell
    }
   
    // MARK: - Add a new category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add a new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add categoty", style: .default) { (action) in
         
            
            let newCategory = Category(context: self.context)
            newCategory.categoryName = textField.text!
            self.categoryArray.append(newCategory)
            self.saveData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item"
            textField = alertTextField
            
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK : - Save the date here
    
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
    // MARK :- Load the data
    
    func loadData(with request : NSFetchRequest<Category> = Category.fetchRequest()) {

        do {
            categoryArray = try  context.fetch(request)}
        catch {
            print ("The data could not be loaded \(error)")
        }
        tableView.reloadData()
        
    }
    
    // MARK: TableViewMethods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "showItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if  segue.identifier == "showItems" {
            let destinationVC = segue.destination as! ToDoListViewController
            if let indexPath = tableView.indexPathForSelectedRow {
             destinationVC.selectedCategory = categoryArray[indexPath.row]
                print("\(categoryArray[indexPath.row])")
            }
        }
  }
    
    
    
    

}
