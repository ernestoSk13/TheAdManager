//
//  Int+Extensions.swift
//  TheAdManager
//
//  Created by Ernesto Sánchez Kuri on 07/03/22.
//

import Foundation

extension Int {
    var roundedWithAbbreviations: String {
            let number = Double(self)
            let thousand = number / 1000
            let million = number / 1000000
            if million >= 1.0 {
                return "\(round(million*10)/10)M"
            }
            else if thousand >= 1.0 {
                return "\(round(thousand*10)/10)K"
            }
            else {
                return "\(self)"
            }
        }
    
    var formattedWithCommas: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.groupingSeparator = ","
        let formattedNumber = numberFormatter.string(from: NSNumber(value: self))
        return formattedNumber ?? "\(self)"
    }
}
