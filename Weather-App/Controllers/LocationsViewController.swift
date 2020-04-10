//
//  LocationsViewController.swift
//  Weather-App
//
//  Created by Kevin Tanner on 4/6/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

import UIKit



class LocationsViewController: UIViewController {

    @IBOutlet weak var locationsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationsTableView.delegate = self
        locationsTableView.dataSource = self
        
        let locationNib = UINib(nibName: Constants.locationTableViewCell, bundle: nil)
        locationsTableView.register(locationNib, forCellReuseIdentifier: Constants.locationCellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationsTableView.reloadData()
    }
    
    @IBAction func backToWeatherButtonTapped(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: "WeatherPageViewControllerSID") as? WeatherPageViewController else { return }
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSearchByAddress" {
            guard let destinationVC = segue.destination as? SearchByAddressViewController else { return }
            destinationVC.weatherPageManagerDelegate = self
        }
    }
}

extension LocationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeatherPageManager.shared.cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.locationCellIdentifier, for: indexPath) as? LocationTableViewCell else { return UITableViewCell() }
        
        let city = WeatherPageManager.shared.cities[indexPath.row]
        
        cell.cityNameLabel.text = city.cityName
        if let dailySummary = city.weatherObjects.first?.dailySummary, let currentTemp = city.weatherObjects.first?.currentTemp {
            
            cell.temperatureLabel.text = "\(currentTemp)°"
            cell.dailySummaryLabel.text = dailySummary
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = WeatherPageManager.shared.cities[indexPath.row]
        guard let index = WeatherPageManager.shared.cities.firstIndex(of: city) else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: "WeatherPageViewControllerSID") as? WeatherPageViewController else { return }
        vc.pageIndex = index
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let cityToRemove = WeatherPageManager.shared.cities[indexPath.row]
            WeatherPageManager.shared.removeCity(with: cityToRemove)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension LocationsViewController: WeatherPageManagerDelegate {
    func reloadTableView() {
        locationsTableView.reloadData()
    }
}
