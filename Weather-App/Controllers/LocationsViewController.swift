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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationsTableView.reloadData()
    }
    
    @IBAction func backToWeatherButtonTapped(_ sender: UIBarButtonItem) {
//        dismiss(animated: true)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        
        cell.textLabel?.text = WeatherPageManager.shared.cities[indexPath.row].cityName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let cityToRemove = WeatherPageManager.shared.cities[indexPath.row]
            WeatherPageManager.shared.removeCity(with: cityToRemove)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }t
    
    
}

extension LocationsViewController: WeatherPageManagerDelegate {
    func reloadTableView() {
        locationsTableView.reloadData()
    }
}
