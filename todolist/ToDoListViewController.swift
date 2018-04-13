//
//  ViewController.swift
//  todolist
//
//  Created by Elchin Mustafayev on 06/04/2018.
//  Copyright © 2018 Elchin Mustafayev. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    
    
    
    let dataFilepath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
  
      
        
        print (String(describing: dataFilepath))
        
        loadData()
        
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
            cell.textLabel?.text = item.itemTitle
       
        cell.accessoryType = item.done ? .checkmark : .none

            return cell
    }
    
    //MARK - check/uncheck the item
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print ("\(itemArray[indexPath.row].itemTitle)")
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
            let newItem = Item()
            newItem.itemTitle = textField.text!
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
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilepath!)
            print ("Data Saved")
        }
        catch {
            print ("The data could not be encoded \(error)")
        }
        self.tableView.reloadData()

    }
    //MARK - Decode the data
    
    func loadData() {
        
        if let data = try? Data(contentsOf: dataFilepath!){
        
        let decoder = PropertyListDecoder()
        
        do {
          itemArray = try  decoder.decode([Item].self, from: data)
          print ("The Todo list has successfully been loaded")
        }
        catch {
            print ("Could nor decode the data \(error)")

            }
        }
    }
        
    
}

