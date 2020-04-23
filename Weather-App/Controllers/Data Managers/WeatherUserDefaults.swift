//
//  WeatherUserDefaults.swift
//  Weather-App
//
//  Created by Kevin Tanner on 4/22/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

import Foundation

class WeatherUserDefaults {
    
    static let shared = WeatherUserDefaults()
    
    let defaults = UserDefaults.standard
    
    var isNewUser = true
    
    func updateUser() {
        isNewUser.toggle()
        saveToPersistentStore()
    }
    
    
    // MARK: - Persistence
    // Return to us a URL that we can save data too createFileURLForPersistence
    func createFileURLForPersistence() -> URL {
        // Grab the users document directory
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        // Create the new fileURL on user's phone
        let fileURL = urls[0].appendingPathComponent("WeatherUserDefaults.json")
        
        return fileURL
    }
    
    func saveToPersistentStore() {
        // Create an instance of JSON Encoder
        let jsonEncoder = JSONEncoder()
        // Attempt to convert our isNewUser to JSON
        do {
            let jsonIsNewUser = try jsonEncoder.encode(isNewUser)
            // With the new json, save it to the users device
            try jsonIsNewUser.write(to: createFileURLForPersistence())
        } catch let error {
            // Handle the error, if there is one
            print("\nThere was an error saving data in \(#function)\nError: \(error)\nError.localizedDescription: \(error.localizedDescription)\n")
        }
    }
    
    func loadFromPersistentStore() {
        // The data we want will be JSON, and I want it to be a Bool.
        let jsonDecoder = JSONDecoder()
        //Decode the data
        do {
            let jsonData = try Data(contentsOf: createFileURLForPersistence())
            let decodedIsNewUser = try jsonDecoder.decode(Bool.self, from: jsonData)
            isNewUser = decodedIsNewUser
        } catch let error {
            print("\nThere was an error decoding in \(#function)\nError: \(error)\nError.localizedDescription: \(error.localizedDescription)\n")
        }
    }
}
