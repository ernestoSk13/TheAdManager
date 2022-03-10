//
//  CampaingPost.swift
//  TheAdManager
//
//  Created by Ernesto Sánchez Kuri on 07/03/22.
//

import Foundation

public struct CampaignPost: Hashable, Codable, Identifiable {
    public let id: String
    public let image: String
    public let postTitle: String
    public let budget: Double
    public let startedDate: String
    public let endingDate: String
    public let impressions: Int
    public let adIdentifier: String
    
    public init(id: String,
                  image: String,
                  postTitle: String,
                  budget: Double,
                  startedDate: String,
                  endingDate: String,
                  impressions: Int,
                  adIdentifier: String) {
        self.id = id
        self.image = image
        self.postTitle = postTitle
        self.budget = budget
        self.startedDate = startedDate
        self.endingDate = endingDate
        self.impressions = impressions
        self.adIdentifier = adIdentifier
    }
    
    var starting: Date {
        return Date.dateFrom(string: startedDate, withFormat: "dd-MM-yyyy")
    }
    
    var ending: Date {
        return Date.dateFrom(string: endingDate, withFormat: "dd-MM-yyyy")
    }
    
    var remainingDays: Int {
        return Calendar.current.numberOfDaysBetween(Date(), and: ending)
    }
    
    var isCurrentlyRunning: Bool {
        return Calendar.current.numberOfDaysBetween(Date(), and: starting) <= 0 && isValid
    }
    
    var daysToStart: Int {
        return Calendar.current.numberOfDaysBetween(Date(), and: starting)
    }
    
    var isValid: Bool {
        return remainingDays > 0
    }
    
}
