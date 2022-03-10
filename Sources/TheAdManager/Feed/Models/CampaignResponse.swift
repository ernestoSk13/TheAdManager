//
//  CampaignResponse.swift
//  TheAdManager
//
//  Created by Ernesto Sánchez Kuri on 07/03/22.
//

import Foundation
import QuartzCore


struct CampaignResponse: Hashable, Codable {
    var id = UUID().uuidString
    let posts: [CampaignPost]
    
    static var mockedResponse: CampaignResponse {
        return Bundle.main.decode(CampaignResponse.self,
                                  from: "Posts.json")
    }
}
