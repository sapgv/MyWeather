//  Created by Гриша on 20.08.17.
//  Copyright © 2017 sapgv. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {

    private let reuseIdentifier = "Cell"

    var list: [List] = [List]()
    var cityName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let leftItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(Done(_:)))
        navigationItem.leftBarButtonItem = leftItem
        
        navigationItem.title = "Weathers"
        let cell = UITableViewCell(style: .value1, reuseIdentifier: reuseIdentifier)
        tableView.register(cell.classForCoder, forCellReuseIdentifier: reuseIdentifier)
        if let name = cityName {
            list = CitiesService.shared.fetchList(cityName: name)
            tableView.reloadData()
        }
        
    }

    func Done(_ sender: UIBarButtonItem) {
        let pageViewController = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.present(pageViewController, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return list.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .value1, reuseIdentifier: reuseIdentifier)

        // Configure the cell...
        let listData = list[indexPath.row]
        
        let date = listData.date
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "HH:mm, dd MMM yyyy"
        dateFormatterPrint.locale = Locale(identifier: "ru_RU")
        
        cell.textLabel?.text = dateFormatterPrint.string(from: date! as Date)
        
        cell.detailTextLabel?.text = String(Int(Double(listData.temp!)!)) + " \u{00B0}C"
        
        return cell
    }
    

   

}
