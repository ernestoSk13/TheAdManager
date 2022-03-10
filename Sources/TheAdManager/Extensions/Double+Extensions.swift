//
//  Double+Extensions.swift
//  TheAdManager
//
//  Created by Ernesto Sánchez Kuri on 07/03/22.
//

import Foundation

extension Double {
    func roundedStringValue(_ value: Double? = nil) -> String {
        let num = value ?? self
        if self > 1000 {
            return String(format: "%0.f", arguments: [num])
        } else {
            return String(format: "%0.2f", arguments: [num])
        }
    }
    
    func formatPoints(value: Double? = nil) ->String {
        let num = value ?? self
        let thousandNum = num/1000
        let millionNum = num/1000000
        if num >= 1000 && num < 1000000{
            if(floor(thousandNum) == thousandNum){
                return("\(Int(thousandNum))k")
            }
            return("\(thousandNum.roundedStringValue())k")
        }
        if num > 1000000{
            if(floor(millionNum) == millionNum){
                return("\(Int(thousandNum))k")
            }
            return ("\(millionNum.roundedStringValue())M")
        }
        else{
            if(floor(num) == num){
                return ("\(Int(num))")
            }
            return ("\(num)")
        }
    }
}
