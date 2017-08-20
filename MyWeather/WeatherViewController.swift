//  Created by Гриша on 20.08.17.
//  Copyright © 2017 sapgv. All rights reserved.
//

import UIKit
import CoreSpotlight
import MobileCoreServices

//MARK: - UIViewController Properties
class WeatherViewController: UIViewController {

  //MARK: - IBOutlets
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var iconLabel: UILabel!
  @IBOutlet weak var temperatureLabel: UILabel!

    @IBAction func actionAddCity(_ sender: Any) {
        
        let cityTVC = CityTableViewController()
        let navController = UINavigationController(rootViewController: cityTVC)
        
        self.present(navController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func showListData(_ sender: Any) {
        
        let listTVC = ListTableViewController()
        listTVC.cityName = viewModel?.location.value
        let navController = UINavigationController(rootViewController: listTVC)
        
        self.present(navController, animated: true, completion: nil)
    }
    
  let identifier = "WeatherIdentifier"
  var isLocal = false
  var city: City?
    
    //MARK: - Super Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel = WeatherViewModel()
    viewModel?.city = city
    viewModel?.startLocationService()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
  }

  // MARK: ViewModel
  var viewModel: WeatherViewModel? {
    didSet {
     viewModel?.location.observe {
        [unowned self] in
        self.locationLabel.text = $0
        }
    
     viewModel?.iconText.observe {
        [unowned self] in
        self.iconLabel.text = $0
    }
    
     viewModel?.temperature.observe {
        [unowned self] in
        self.temperatureLabel.text = $0
        
        if ($0 != "") {
            let temp = Int(Double($0)!)

            self.temperatureLabel.text = String(temp) + " \u{00B0}C"
            if temp > 0 {
                let fahrenheit = min(max(0, (temp*9)/5 + 32),99)
                let gradientImageName = "gradient\(Int(floor(Double(fahrenheit / 10)))).png"
                self.view.backgroundColor = UIColor(patternImage: UIImage(named: gradientImageName)!)
            }
        }
        

    }
            
        
    }
    }
  }
