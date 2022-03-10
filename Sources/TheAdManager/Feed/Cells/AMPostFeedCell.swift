//
//  AMPostFeedCell.swift
//  TheAdManager
//
//  Created by Ernesto Sánchez Kuri on 07/03/22.
//

import SwiftUI

struct AMPostFeedCell: View {
    let campaignPost: CampaignPost
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Image(campaignPost.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                VStack(alignment: .leading) {
                    Text(campaignPost.postTitle).bold()
                    Text("Budget: $\(campaignPost.budget.formatPoints())")
                    if campaignPost.isValid {
                        if campaignPost.isCurrentlyRunning {
                            Text("Remaining Time: \(campaignPost.remainingDays) days")
                        } else {
                            Text("Starts in: \(campaignPost.daysToStart) days")
                        }
                        
                    } else {
                        Text("Remaining Time: Expired")
                    }
                    
                    Text("Impressions: \(campaignPost.impressions.roundedWithAbbreviations)")
                    Text("Ad Identifier: \(campaignPost.adIdentifier)")
                }.padding(10).font(.callout)
                Spacer()
                VStack {
                    if !campaignPost.isValid {
                        Button {
                            
                        } label: {
                            Text("Renew")
                        }
                    }
                    Spacer()
                    Button {
                        
                    } label: {
                        Image(systemName: "info.circle")
                    }
                }.padding(10)
            }
        }.frame(height: 143)
    }
}



struct AMPostFeedCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AMPostFeedCell(campaignPost: CampaignResponse.mockedResponse.posts[0])
                .previewLayout(.sizeThatFits)
            AMPostFeedCell(campaignPost: CampaignResponse.mockedResponse.posts[3])
                .previewLayout(.sizeThatFits)
            AMPostFeedCell(campaignPost: CampaignResponse.mockedResponse.posts[1])
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
    }
}
