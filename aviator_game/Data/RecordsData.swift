//
//  RecordsData.swift
//  aviator_game
//
//  Created by Anton on 20/4/24.
//

import SwiftUI

class RecordsData: ObservableObject {
    
    @Published var recordsList: [String] = []
    @Published var records: [String: Int] = [:]
    @Published var recordsDates: [String: Double] = [:]
    
    init() {
        for level in 1...12 {
            records["level_\(level)"] = UserDefaults.standard.integer(forKey: "record_level_\(level)")
            recordsDates["level_\(level)"] = UserDefaults.standard.double(forKey: "record_date_level_\(level)")
            recordsList.append("level_\(level)")
        }
    }
    
    func insertRecord(level: String, time: Int) {
        let defaults = UserDefaults.standard
        if defaults.integer(forKey: "record_\(level)") > 0 {
            if time < defaults.integer(forKey: "record_\(level)") {
                defaults.set(time, forKey: "record_\(level)")
                defaults.set(Date().timeIntervalSince1970, forKey: "record_date_\(level)")
            }
        } else {
            defaults.set(time, forKey: "record_\(level)")
            defaults.set(Date().timeIntervalSince1970, forKey: "record_date_\(level)")
        }
    }
    
}
