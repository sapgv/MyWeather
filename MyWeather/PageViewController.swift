//  Created by Гриша on 20.08.17.
//  Copyright © 2017 sapgv. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dataSource = self

    }

    override func viewWillAppear(_ animated: Bool) {
        
        viewControllerList = [WeatherViewController]()

        let localCityViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
        localCityViewController.isLocal = true
        
        viewControllerList.append(localCityViewController)
        
        
        
        let cities = CitiesService.shared.cities
        
        for city in cities {
            
            let weatherViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
            
            weatherViewController.city = city
            viewControllerList.append(weatherViewController)
            
        }
        
        self.setViewControllers([localCityViewController], direction: .forward, animated: true, completion: nil)
        
    }
    
    lazy var viewControllerList: [WeatherViewController] = [WeatherViewController]()
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.index(of: viewController as! WeatherViewController) else {return nil}
        
        let previousIndex = vcIndex - 1
        
        guard previousIndex >= 0 else {return nil}
        
        guard viewControllerList.count > previousIndex else {return nil}
        
        return viewControllerList[previousIndex]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.index(of: viewController as! WeatherViewController) else {return nil}
        
        let nextIndex = vcIndex + 1
        
        guard viewControllerList.count != nextIndex else { return nil}
        
        guard  viewControllerList.count > nextIndex else { return nil }
        
        return viewControllerList[nextIndex]
        
    }
    
    

}
