//
//  FileManagerExtension.swift
//  IntoTheWild
//
//  Created by Monty Boyer on 7/12/20.
//  Copyright © 2020 Monty Boyer. All rights reserved.
//

import Foundation

extension FileManager {
    
    // provide the url for the app's documents folder
    private static func documentsURL() -> URL {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError()
        }
        
        return url
    }
    
    // provide the url for the json file to store region updates
    static func regionUpdatesDataPath() -> URL {
        return documentsURL().appendingPathComponent("region_updates.json")
    }
}
