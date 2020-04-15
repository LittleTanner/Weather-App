//
//  WeatherPageViewController.swift
//  Weather-App
//
//  Created by Kevin Tanner on 4/6/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

import UIKit

class WeatherPageViewController: UIPageViewController {

//    var controllers = [UIViewController]()
    var pageControl = UIPageControl()
    
//    var pageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self
        
        WeatherManager.shared.loadFromPersistentStore()
        createViewControllers()
        
        self.setViewControllers([WeatherManager.shared.pageControllers[WeatherManager.shared.pageIndex]], direction: .forward, animated: false)
        configurePageControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    func createViewControllers() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        WeatherManager.shared.pageControllers = []
        
        for num in 0 ..< WeatherManager.shared.cities.count {
            guard let vc = storyboard.instantiateViewController(identifier: "WeatherForCitySID") as? ViewController else { return }
            vc.city = WeatherManager.shared.cities[num]
            vc.cityLabelText = WeatherManager.shared.cities[num].cityName
            
            WeatherManager.shared.pageControllers.append(vc)
        }
    }
    
    
    func configurePageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 50,width: UIScreen.main.bounds.width,height: 50))
        self.pageControl.numberOfPages = WeatherManager.shared.pageControllers.count
        self.pageControl.currentPage = WeatherManager.shared.pageIndex
        self.pageControl.alpha = 0.5
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.secondaryLabel
        self.pageControl.currentPageIndicatorTintColor = UIColor.systemBlue
        self.view.addSubview(pageControl)
    }
    
}


extension WeatherPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = WeatherManager.shared.pageControllers.firstIndex(of: viewController) {
            if index > 0 {
                return WeatherManager.shared.pageControllers[index - 1]
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = WeatherManager.shared.pageControllers.firstIndex(of: viewController) {
            if index < WeatherManager.shared.pageControllers.count - 1 {
                return WeatherManager.shared.pageControllers[index + 1]
            }
        }
        return nil
    }
    
    // Updates the dots to show the user which screen they are on
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = WeatherManager.shared.pageControllers.firstIndex(of: pageContentViewController)!
    }
}
