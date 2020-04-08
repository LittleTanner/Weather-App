//
//  WeatherPageViewController.swift
//  Weather-App
//
//  Created by Kevin Tanner on 4/6/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

import UIKit

class WeatherPageViewController: UIPageViewController {

    var controllers = [UIViewController]()
    var pageControl = UIPageControl()
    
    var pageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self

        createViewControllers()
        
        self.setViewControllers([controllers[pageIndex]], direction: .forward, animated: false)
        configurePageControl()
    }
    
    
    func createViewControllers() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        for num in 0 ..< WeatherPageManager.shared.cities.count {
            guard let vc = storyboard.instantiateViewController(identifier: "WeatherForCitySID") as? ViewController else { return }
            vc.city = WeatherPageManager.shared.cities[num]
            vc.cityLabelText = WeatherPageManager.shared.cities[num].cityName
            
            controllers.append(vc)
        }
    }
    
    
    func configurePageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 50,width: UIScreen.main.bounds.width,height: 50))
        self.pageControl.numberOfPages = controllers.count
        self.pageControl.currentPage = pageIndex
        self.pageControl.alpha = 0.5
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.secondaryLabel
        self.pageControl.currentPageIndicatorTintColor = UIColor.systemBlue
        self.view.addSubview(pageControl)
    }
    
}


extension WeatherPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = controllers.firstIndex(of: viewController) {
            if index > 0 {
                return controllers[index - 1]
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = controllers.firstIndex(of: viewController) {
            if index < controllers.count - 1 {
                return controllers[index + 1]
            }
        }
        return nil
    }
    
    // Updates the dots to show the user which screen they are on
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = controllers.firstIndex(of: pageContentViewController)!
    }
}
