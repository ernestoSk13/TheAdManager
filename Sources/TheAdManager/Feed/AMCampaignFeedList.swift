//
//  AMCampaignFeedList.swift
//  TheAdManager
//
//  Created by Ernesto Sánchez Kuri on 07/03/22.
//

import SwiftUI
import Combine

class AMCampaignFeedListViewModel: ObservableObject {
    @Published var posts: [CampaignPost] = []
    
    
    init() {
        downloadPosts()
    }
    
    func downloadPosts() {
        let profile = Bundle.main.decode(CampaignResponse.self,
                                         from: "Posts.json")
        let posts = profile.posts.sorted { p1, p2 in
            p1.ending > p2.ending
        }
        
        self.posts = posts
    }
}

public struct AMCampaignFeedList: View {
    private let viewModel = AMCampaignFeedListViewModel()
    let posts: [CampaignPost]
    private var listLayout = Array(repeating: GridItem(.flexible(), spacing: 10), count: 1)
    
    public init(posts: [CampaignPost]) {
        self.posts = posts
    }
    
    public var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: listLayout, alignment: .leading) {
                    Text("Currently Running").padding(.horizontal)
                    ForEach(viewModel.posts.filter { $0.isValid && $0.isCurrentlyRunning }) { post in
                        NavigationLink.init(destination: AMStatsDetailView(campaignInsights: CampaignInsights.insights.filter { $0.id == post.id }.first!)) {
                            AMPostFeedCell(campaignPost: post).foregroundColor(Color.primary)
                        }
                        Divider()
                    }
                    Text("Upcoming").padding(.horizontal)
                    ForEach(viewModel.posts.filter { $0.isValid && !$0.isCurrentlyRunning }) { post in
                        NavigationLink.init(destination: AMStatsDetailView(campaignInsights: CampaignInsights.insights.filter { $0.id == post.id }.first!)) {
                            AMPostFeedCell(campaignPost: post).foregroundColor(Color.primary)
                        }
                        Divider()
                    }
                    Text("Past Ignited Posts").padding(.horizontal)
                    ForEach(viewModel.posts.filter { !$0.isValid }) { post in
                        NavigationLink.init(destination: AMStatsDetailView(campaignInsights: CampaignInsights.insights.filter { $0.id == post.id }.first!)) {
                            AMPostFeedCell(campaignPost: post).foregroundColor(Color.primary)
                        }
                        Divider()
                    }
                }
            }
            .navigationTitle("My Ignited Posts")
        }
    }
}

struct AMCampaignFeedList_Previews: PreviewProvider {
    static var previews: some View {
        AMCampaignFeedList(posts: Bundle.main.decode(CampaignResponse.self,
                                                     from: "Posts.json").posts)
    }
}
