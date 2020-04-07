//
//  SearchByAddressViewController.swift
//  Weather-App
//
//  Created by Kevin Tanner on 3/27/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

import UIKit
import CoreLocation

class SearchByAddressViewController: UIViewController {
    
    @IBOutlet weak var searchByAddressSearchBar: UISearchBar!
    @IBOutlet weak var addressesTableView: UITableView!
    
    var searchBarText: String?
    var lat: Double?
    var lon: Double?

    var locationInfo: String?
    
    
    var cities: [City]?
    var city: City?
    
    var weatherPageManagerDelegate: WeatherPageManagerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchByAddressSearchBar.delegate = self
        addressesTableView.delegate = self
        addressesTableView.dataSource = self
    }
    
    func getCoordinate(addressString: String, completionHandler: @escaping((info: String, coordinates: CLLocationCoordinate2D), NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    
                    var outputString = ""
                    
                    if let city = placemark.locality,
                        let state = placemark.administrativeArea,
                        let country = placemark.country {
                        outputString = "\(city), \(state), \(country)"
                    }
                    
                    completionHandler((outputString, location.coordinate), nil)
                    return
                }
            }
            
            completionHandler(("Location not found", kCLLocationCoordinate2DInvalid), error as NSError?)
        }
    }
}

extension SearchByAddressViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.addressCellIdentifier, for: indexPath)
        
        if let locationInfo = locationInfo {
            cell.textLabel?.text = locationInfo
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let city = city else { return }
        WeatherPageManager.shared.addCity(with: city)
        print("Added city: \(city)")
        print("Cities: \(WeatherPageManager.shared.cities)")
        weatherPageManagerDelegate?.reloadTableView()
        dismiss(animated: true, completion: nil)
    }
}

extension SearchByAddressViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            self.searchBarText = searchText
            getCoordinate(addressString: searchText) { (location, error) in
                self.lat = location.coordinates.latitude
                self.lon = location.coordinates.longitude
                self.locationInfo = location.info
                
                self.city = City(cityName: location.info, latitude: location.coordinates.latitude, longitude: location.coordinates.longitude)
                
                self.addressesTableView.reloadData()
            }
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        getCoordinate(addressString: searchText) { (location, error) in
            self.lat = location.coordinates.latitude
            self.lon = location.coordinates.longitude
            self.locationInfo = location.info
            
            self.city = City(cityName: location.info, latitude: location.coordinates.latitude, longitude: location.coordinates.longitude)
            
            self.addressesTableView.reloadData()
        }
    }
}
