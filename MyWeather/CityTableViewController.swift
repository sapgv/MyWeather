//  Created by Гриша on 20.08.17.
//  Copyright © 2017 sapgv. All rights reserved.
//

import UIKit
import CoreData

class CityTableViewController: UITableViewController, UINavigationBarDelegate {

    private let reuseIdentifier = "Cell"

    let fetchRequest: NSFetchRequest<City> = City.fetchRequest()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(Done(_:)))
        let rightItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(AddCity(_:)))
        navigationItem.leftBarButtonItem = leftItem
        navigationItem.rightBarButtonItem = rightItem
        
        navigationItem.title = "Cities"

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.reloadData()
    }
    
    func Done(_ sender: UIBarButtonItem) {
        
        let pageViewController = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.present(pageViewController, animated: true, completion: nil)
        
    }
    
    func AddCity(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Add new city", message: "", preferredStyle: .alert)

        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in

            let firstTextField = alertController.textFields![0] as UITextField

            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.managedObjectContext

            let city = NSEntityDescription.insertNewObject(
                forEntityName: "City",
                into: managedContext) as! City
            city.name = firstTextField.text

            do {
                try managedContext.save()
                CitiesService.shared.updateCities()
                self.tableView.reloadData()
            }
            catch let error as NSError {
                print("Save error: \(error), description: \(error.userInfo)")
            }
            
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in

        })

        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter City Name"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)

    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return CitiesService.shared.cities.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = CitiesService.shared.cities[indexPath.row].name
        return cell
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            //1
            let city = CitiesService.shared.cities[indexPath.row]
            
            
            //2
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.managedObjectContext
            
            //3
            managedContext.delete(city)
            do {
                try managedContext.save()
                //4
                CitiesService.shared.cities.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } catch let error as NSError {
                print("Saving error: \(error), description:  (error.userInfo)")
            }
        }
    }


    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
