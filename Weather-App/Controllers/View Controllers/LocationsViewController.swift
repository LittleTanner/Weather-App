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
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationsTableView.reloadData()
    }
    
    @IBAction func backToWeatherButtonTapped(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: Constants.mainStoryboard, bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: Constants.weatherPageViewControllerID) as? WeatherPageViewController else { return }
        vc.modalPresentationStyle = .fullScreen
        presentVCFromLeft(vc)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        locationsTableView.isEditing = false
        doneButton.title = ""
    }
    
    func setupUI() {
        locationsTableView.delegate = self
        locationsTableView.dataSource = self
        
        configureLongPressTapGesture()
        registerTableViewCells()
    }
    
    func registerTableViewCells() {
        let locationNib = UINib(nibName: Constants.locationTableViewCell, bundle: nil)
        locationsTableView.register(locationNib, forCellReuseIdentifier: Constants.locationCellIdentifier)
    }
    
    func configureLongPressTapGesture() {
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        view.addGestureRecognizer(tap)
    }
    
    @objc func longPress() {
        locationsTableView.isEditing = true
        doneButton.title = "Done"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segueToSearchForLocation {
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
                cell.weatherIconImageView.image = WeatherObject.getWeatherIcon(with: weatherObject.icon)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.isEditing == false {
            let storyboard = UIStoryboard(name: Constants.mainStoryboard, bundle: nil)
            guard let vc = storyboard.instantiateViewController(identifier: Constants.weatherPageViewControllerID) as? WeatherPageViewController else { return }
            WeatherManager.shared.pageIndex = indexPath.row
            vc.modalPresentationStyle = .fullScreen
            presentVCFromLeft(vc)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let cityToRemove = WeatherManager.shared.cities[indexPath.row]
            WeatherManager.shared.removeCity(with: cityToRemove)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            // If the user came to the locations page from the last city in the cities array and deletes that city then update the page index to zero to prevent an index out of range error for the WeatherPageViewController
            if WeatherManager.shared.cities.count == indexPath.row {
                WeatherManager.shared.pageIndex = 0
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath.row != 0 && destinationIndexPath.row != 0 {
            let itemToMove = WeatherManager.shared.cities[sourceIndexPath.row]
            WeatherManager.shared.cities.remove(at: sourceIndexPath.row)
            WeatherManager.shared.cities.insert(itemToMove, at: destinationIndexPath.row)
            WeatherManager.shared.saveToPersistentStore()
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
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension LocationsViewController: WeatherManagerDelegate {
    func reloadTableView() {
        locationsTableView.reloadData()
    }
}
