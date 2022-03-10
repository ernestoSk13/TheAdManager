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
    var backgroundColor: Color = Color(UIColor.systemBackground)
    var foregroundColor: Color = Color.primary
    
    public init(posts: [CampaignPost],
                backgroundColor: Color = Color(UIColor.systemBackground),
                foregroundColor: Color = Color.primary) {
        self.posts = posts
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
    }
    
    public var body: some View {
        VStack {
            if viewModel.posts.isEmpty {
                HStack {
                    Image("ignite_button")
                        .imageScale(.medium)
                        .foregroundColor(foregroundColor)
                    Text("There are no ignited posts yet. Go ahead and make your posts visible to all!")
                        .foregroundColor(foregroundColor)
                }.padding()
            } else {
                ScrollView {
                    LazyVGrid(columns: listLayout, alignment: .leading) {
                        if viewModel.posts.filter { $0.isValid && $0.isCurrentlyRunning }.count > 0 {
                            Text("Currently Running")
                                .foregroundColor(foregroundColor)
                                .padding()
                            ForEach(viewModel.posts.filter { $0.isValid && $0.isCurrentlyRunning }) { post in
                                NavigationLink.init(destination: AMStatsDetailView(campaignInsights: CampaignInsights.insights.filter { $0.id == post.id }.first!)) {
                                    AMPostFeedCell(campaignPost: post)
                                }
                                Divider()
                            }
                        }
                        if viewModel.posts.filter { $0.isValid && !$0.isCurrentlyRunning }.count > 0 {
                            Text("Upcoming")
                                .foregroundColor(foregroundColor)
                                .padding()
                            ForEach(viewModel.posts.filter { $0.isValid && !$0.isCurrentlyRunning }) { post in
                                NavigationLink.init(destination: AMStatsDetailView(campaignInsights: CampaignInsights.insights.filter { $0.id == post.id }.first!)) {
                                    AMPostFeedCell(campaignPost: post)
                                }
                                Divider()
                            }
                        }
                        if viewModel.posts.filter { !$0.isValid }.count > 0 {
                            Text("Past Ignited Posts")
                                .foregroundColor(foregroundColor)
                                .padding()
                            ForEach(viewModel.posts.filter { !$0.isValid }) { post in
                                NavigationLink.init(destination: AMStatsDetailView(campaignInsights: CampaignInsights.insights.filter { $0.id == post.id }.first!)) {
                                    AMPostFeedCell(campaignPost: post)
                                }
                                Divider()
                            }
                        }
                    }.foregroundColor(foregroundColor)
                }
            }
        }.navigationTitle("My Ignited Posts")
        .background(backgroundColor)
    }
}

struct AMCampaignFeedList_Previews: PreviewProvider {
    static var previews: some View {
        AMCampaignFeedList(posts: Bundle.main.decode(CampaignResponse.self,
                                                     from: "Posts.json").posts)
    }
}
