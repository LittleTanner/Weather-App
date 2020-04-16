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
        guard let vc = storyboard.instantiateViewController(identifier: Constants.weatherPageViewController) as? WeatherPageViewController else { return }
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSearchByAddress" {
            guard let destinationVC = segue.destination as? SearchForLocationViewController else { return }
            destinationVC.weatherManagerDelegate = self
        }
    }
}

extension LocationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeatherManager.shared.cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.locationCellIdentifier, for: indexPath) as? LocationTableViewCell else { return UITableViewCell() }
        
        let city = WeatherManager.shared.cities[indexPath.row]
        cell.cityNameLabel.text = city.cityName
        
        WeatherNetworkManager().getWeather(latitude: city.latitude, longitude: city.longitude) { (weatherObject) in
            guard let weatherObject = weatherObject else { return }
            
            WeatherManager.shared.updateWeatherObject(with: weatherObject, location: city)
            
            DispatchQueue.main.async {
                cell.temperatureLabel.text = "\(weatherObject.currentTemp)°"
                cell.feelsLikeTempLabel.text = "Feels Like: \(weatherObject.currentFeelsLikeTemp)°"
                cell.temperatureHighLowLabel.text = "\(weatherObject.dailyTempHigh)° / \(weatherObject.dailyTempLow)°"
                cell.weatherIconImageView.image = WeatherNetworkManager.getWeatherIcon(with: weatherObject.icon)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: Constants.weatherPageViewController) as? WeatherPageViewController else { return }
        WeatherManager.shared.pageIndex = indexPath.row
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let cityToRemove = WeatherManager.shared.cities[indexPath.row]
            WeatherManager.shared.removeCity(with: cityToRemove)
            print("Delete row at indexpath: \(indexPath.row)")
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            // If the user came to the locations page from the last city in the cities array and deletes that city then update the page index to zero to prevent an index out of range error for the WeatherPageViewController
            if WeatherManager.shared.cities.count == indexPath.row {
                WeatherManager.shared.pageIndex = 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        // If this is the first item in the weather array of locations do not allow it to be deleted.
        let cityToRemove = WeatherManager.shared.cities[indexPath.row]
        if cityToRemove == WeatherManager.shared.cities[0] {
            return .none
        }
        return .delete
    }
}

extension LocationsViewController: WeatherManagerDelegate {
    func reloadTableView() {
        locationsTableView.reloadData()
    }
}
