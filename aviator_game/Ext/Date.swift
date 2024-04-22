//
//  Date.swift
//  aviator_game
//
//  Created by Anton on 20/4/24.
//

import Foundation

extension Date {
    func formattToPretty() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        return dateFormatter.string(from: self)
    }
}

extension Double {
    func convertToDate() -> Date {
        return Date(timeIntervalSince1970: self)
    }
}
