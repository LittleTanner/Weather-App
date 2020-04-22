//
//  SearchForLocationViewController.swift
//  Weather-App
//
//  Created by Kevin Tanner on 3/27/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

import UIKit
import CoreLocation

class SearchForLocationViewController: UIViewController {
    
    @IBOutlet weak var searchByAddressSearchBar: UISearchBar!
    @IBOutlet weak var addressesTableView: UITableView!

    var locationInfo: String?
    var city: KDTLocationObject?
    var cityName: String?
    var locationExists = false
    
    var weatherManagerDelegate: WeatherManagerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchByAddressSearchBar.delegate = self
        addressesTableView.delegate = self
        addressesTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchByAddressSearchBar.becomeFirstResponder()
    }
    
    @IBAction func navigationBackButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

extension SearchForLocationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.addressCellIdentifier, for: indexPath)
        cell.textLabel?.text = locationInfo
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let city = city, let cityName = cityName else { return }
        
        if locationExists {
            
            if !WeatherManager.shared.cities.contains(city) {
                WeatherManager.shared.addCity(with: KDTLocationObject(cityName: cityName, latitude: city.latitude, longitude: city.longitude))
                weatherManagerDelegate?.reloadTableView()
                dismiss(animated: true)
            } else {
                // Show pop up saying you already added this city
                presentAlert(with: "Duplicate", message: "This location was already added to your list. Please add a different location.", actionButtonTitle: "Ok")
            }
        } else {
            // Show pop up saying this location can't be found please try again
            presentAlert(with: "Unknown Location", message: "Sorry this location can't be found at this time. Please try again later or try searching for a different city, zip code or street address.", actionButtonTitle: "Ok")
        }
    }
}

extension SearchForLocationViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            
            WeatherManager.getCoordinates(from: searchText) { (location, error) in
                if let _ = error {
                    self.locationExists = false
                } else {
                    self.locationExists = true
                    self.locationInfo = location.info
                    
                    let cityName = location.info.components(separatedBy: ",")
                    self.cityName = cityName[0]
                    self.city = KDTLocationObject(cityName: cityName[0], latitude: location.coordinates.latitude, longitude: location.coordinates.longitude)
                    self.addressesTableView.reloadData()
                }
            }
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        WeatherManager.getCoordinates(from: searchText) { (location, error) in
            if let _ = error {
                self.locationExists = false
            } else {
                self.locationExists = true
                self.locationInfo = location.info
                
                let cityName = location.info.components(separatedBy: ",")
                self.cityName = cityName[0]
                self.city = KDTLocationObject(cityName: cityName[0], latitude: location.coordinates.latitude, longitude: location.coordinates.longitude)
                self.addressesTableView.reloadData()
            }
        }
    }
}
