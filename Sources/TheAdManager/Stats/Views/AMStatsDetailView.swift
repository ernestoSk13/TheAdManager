//
//  AMStatsDetailView.swift
//  TheAdManager
//
//  Created by Ernesto Sánchez Kuri on 07/03/22.
//

import SwiftUI

enum StatsSegment: String, CaseIterable {
    case impressions = "Impressions"
    case likes = "Likes"
    case reblogs = "Reblogs"
}

struct AMStatsDetailView: View {
    let campaignInsights: CampaignInsights
    let segments: [StatsSegment] = StatsSegment.allCases
    @State var selectedSegment: StatsSegment = .impressions
    var post: CampaignPost! {
        return Bundle.main.decode(CampaignResponse.self,
                                  from: "Posts.json").posts.filter {
            $0.id == campaignInsights.id
        }.first
    }
    
    var body: some View {
            VStack(alignment: .leading) {
                if campaignInsights.stats.count > 0 {
                    Picker("", selection: $selectedSegment) {
                        ForEach(segments, id: \.self) { segment in
                            Text(segment.rawValue)
                        }
                    }.pickerStyle(.segmented)
                    selectedSegmentTitle()
                    BarGraphView(campaign: campaignInsights,
                                 selectedSegment: $selectedSegment,
                                 height: 200)
                        .frame(height: 200)
                        .padding()
                    Text("Stats by day")
                        .bold()
                        .padding(.horizontal)
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading) {
                            ForEach(0 ..< campaignInsights.stats.count) { idx in
                                selectedSegmentView(forIndex: idx)
                                Divider()
                            }
                            Spacer()
                        }
                    }
                } else {
                    Text("There are not stats yet for this campaign, try again once the campaign has started.")
                }
            }
            .padding()
            .navigationBarTitle(Text(post.postTitle),
                                displayMode: .inline)
    }
    
    
    var totalLikes: Int {
        let likes: [Int] = campaignInsights.stats.map {
            $0.likes
        }
        
        return likes.reduce(0, +)
    }
    
    var totalReblogs: Int {
        let reblogs: [Int] = campaignInsights.stats.map {
            $0.reblogs
        }
        
        return reblogs.reduce(0, +)
    }
    
    @ViewBuilder
    func selectedSegmentTitle() -> some View {
        switch selectedSegment {
        case .impressions:
            StatsDetailTitleView(title: "Total impressions", value: "\(post.impressions.formattedWithCommas)")
        case .likes:
            StatsDetailTitleView(title: "Total likes", value: "\(totalLikes.formattedWithCommas)")
        case .reblogs:
            StatsDetailTitleView(title: "Total reblogs", value: "\(totalReblogs.formattedWithCommas)")
        }
    }
    
    @ViewBuilder
    func selectedSegmentView(forIndex idx: Int) -> some View {
        switch selectedSegment {
        case .impressions:
            DayInsightRowView(title: campaignInsights.stats[idx].dateValue.stringValueWith(format: "MMMM dd"),
                              value: "\(campaignInsights.stats[idx].totalImpressions.formattedWithCommas)",
                              ascending: idx == 0 ? true : campaignInsights.stats[idx].totalImpressions > campaignInsights.stats[idx - 1].totalImpressions)
                .padding()
        case .likes:
            DayInsightRowView(title: campaignInsights.stats[idx].dateValue.stringValueWith(format: "MMMM dd"),
                              value: "\(campaignInsights.stats[idx].likes.formattedWithCommas)",
                              ascending: idx == 0 ? true : campaignInsights.stats[idx].likes > campaignInsights.stats[idx - 1].likes)
                .padding()
        case .reblogs:
            DayInsightRowView(title: campaignInsights.stats[idx].dateValue.stringValueWith(format: "MMMM dd"),
                              value: "\(campaignInsights.stats[idx].reblogs.formattedWithCommas)",
                              ascending: idx == 0 ? true : campaignInsights.stats[idx].reblogs > campaignInsights.stats[idx - 1].reblogs)
                .padding()
        }
    }
}

struct StatsDetailTitleView: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title).bold()
            Text(value)
        }.padding()
    }
}

struct DayInsightRowView: View {
    let title: String
    let value: String
    let ascending: Bool
    let ascendingIcon = "arrowtriangle.up.fill"
    let descendingIcon = "arrowtriangle.down.fill"
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
            Image(systemName: ascending ? ascendingIcon : descendingIcon)
                .foregroundColor(ascending ? .green : .red)
        }
    }
}


struct AMStatsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AMStatsDetailView(campaignInsights: CampaignInsights.insights[0])
            DayInsightRowView(title: "January 21",
                              value: "12,000",
                              ascending: false)
                .previewLayout(.sizeThatFits)
                .padding()
        }
    }
}
