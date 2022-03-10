//
//  CampaignInsights.swift
//  TheAdManager
//
//  Created by Ernesto Sánchez Kuri on 07/03/22.
//

import Foundation


enum AdFormat: String, Codable, Hashable {
    case image
    case video
    case singleCarousel
    case multipleCarousel
    case gif
    case takeover
}

enum PlatformType: String, Codable, Hashable, CaseIterable {
    case ios
    case android
    case web
}

struct CampaignInsights: Hashable, Codable, Identifiable {
    var id: String
    let stats: [InsightDay]
    static var insights: [CampaignInsights] {
        return Bundle.main.decode([CampaignInsights].self,
                                  from: "Stats.json")
    }
}

struct InsightDay: Hashable, Codable, Identifiable {
    var id: String {
        return UUID().uuidString
    }
    let date: String
    let totalImpressions: Int
    let clicks: Int
    let likes: Int
    let reblogs: Int
    let replies: Int
    let follows: Int
    let shares: Int
    
    var dateValue: Date {
        Date.from(string: date, withFormat: "dd-MM-yyyy") ?? Date()
    }
}


