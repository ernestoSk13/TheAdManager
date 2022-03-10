//
//  BarGraphView.swift
//  TheAdManager
//
//  Created by Ernesto Sánchez Kuri on 08/03/22.
//

import SwiftUI

struct BarGraphView: View {
    let campaign: CampaignInsights
    @Binding var selectedSegment: StatsSegment
    var height: CGFloat = 200
    @State var shouldAnimate = false
    @State var currentBar = ""
    @State private var currentValue = -1
    @State private var touchLocation: CGFloat = -1
    
    var days: [String] {
        return campaign.stats.map {
            $0.dateValue.stringValueWith(format: "MM/dd")
        }
    }
    
    var max: Int {
        switch selectedSegment {
        case .impressions:
            let impressions: [Int] = campaign.stats.map { $0.totalImpressions }
            return impressions.sorted().last ?? 0
        case .likes:
            let likes: [Int] = campaign.stats.map { $0.likes }
            return likes.sorted().last ?? 0
        case .reblogs:
            let reblogs: [Int] = campaign.stats.map { $0.reblogs }
            return reblogs.sorted().last ?? 0
        }
    }
    
    func calculateBarHeight(value: Int) -> CGFloat {
        let canvasHeight = height - 20 - 20
        let barHeight = CGFloat(value) / CGFloat(max) * CGFloat(canvasHeight)
        return barHeight
    }
    
    
    func barIsTouched(index: Int) -> Bool {
        touchLocation > CGFloat(index)/CGFloat(campaign.stats.count)
        && touchLocation < CGFloat(index + 1) / CGFloat(campaign.stats.count)
    }
    
    func updateCurrentBar() {
        let index = Int(touchLocation * CGFloat(campaign.stats.count))
        guard index < campaign.stats.count && index >= 0 else {
            currentBar = ""
            return
        }
        switch selectedSegment {
        case .impressions:
            currentValue = campaign.stats[index].totalImpressions
        case .likes:
            currentValue = campaign.stats[index].likes
        case .reblogs:
            currentValue = campaign.stats[index].reblogs
        }
        
        currentBar = campaign.stats[index].dateValue.stringValueWith(format: "MM/dd")
    }
    
    func resetBars() {
        touchLocation = -1
        currentBar = ""
        currentValue = -1
    }
    
    func labelOffset(inWidth width: CGFloat) -> CGFloat {
        let index = Int(touchLocation * CGFloat(campaign.stats.count))
        guard index < campaign.stats.count && index >= 0 else {
            return 0
        }
        let cellWidth = width / CGFloat(campaign.stats.count)
        let actualWidth = width - cellWidth
        let position = cellWidth * CGFloat(index) - actualWidth / 2
        return position
    }
        
    var body: some View {
        //ScrollView(.horizontal, showsIndicators: false) {
        ZStack {
            VStack {
                GeometryReader { reader in
                    VStack {
                        Spacer()
                        HStack(alignment: .bottom) {
                            ForEach(0 ..< campaign.stats.count) { day in
                                barForIndex(idx: day)
                                    .opacity(barIsTouched(index: day) ? 1 : 0.7)
                                    .padding(.top)
                            }
                        }
                        .frame(height: height - 50)
                        .gesture(DragGesture(minimumDistance: 0)
                                    .onChanged({ position in
                            let touchPosition = position.location.x / reader.frame(in: .local).width
                            touchLocation = touchPosition
                            updateCurrentBar()
                        })
                                    .onEnded({ position in
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation(.easeOut(duration: 0.5)) {
                                    resetBars()
                                }
                            }
                        })
                        )
                        
                        if !currentBar.isEmpty {
                            Text(currentBar)
                                .bold()
                                .padding(5)
                                .background(RoundedRectangle(cornerRadius: 3)
                                                .fill(Color.backgroundColor)
                                                .shadow(radius: 3))
                                .offset(x: labelOffset(inWidth: reader.frame(in: .local).width))
                        } else {
                            Text(selectedSegment.rawValue)
                                .bold()
                                .padding(5)
                                .background(RoundedRectangle(cornerRadius: 3)
                                                .fill(Color.backgroundColor)
                                                .shadow(radius: 3))
                        }
                    }.padding(.horizontal)
                }
            }
            VStack {
                if currentValue >= 0 {
                    HStack {
                        Text("Current Value: \(currentValue)")
                            .padding(5)
                            .background(RoundedRectangle(cornerRadius: 3)
                                            .fill(Color.backgroundColor)
                                            .shadow(radius: 3))
                        Spacer()
                    }
                }
                Spacer()
            }.padding()
        } .frame(height: height)
            .background(Color.backgroundColor)
            .clipped()
            .cornerRadius(7)
        .shadow(radius: 7)
        .onAppear {
            DispatchQueue.main.async {
                withAnimation(.easeInOut(duration: 0.3)) {
                    shouldAnimate = true
                }
            }
        }
    }
    
    @ViewBuilder
    func barForIndex(idx: Int) -> some View {
        switch selectedSegment {
        case .impressions:
            BarView(height: calculateBarHeight(value: campaign.stats[idx].totalImpressions), idx: idx)
                .scaleEffect(CGSize(width: 1, height: shouldAnimate ? calculateBarHeight(value: campaign.stats[idx].totalImpressions) / (height - 20 - 20) : 0), anchor: .bottom)
        case .likes:
            BarView()
                .scaleEffect(CGSize(width: 1, height: shouldAnimate ? calculateBarHeight(value: campaign.stats[idx].likes) / (height - 20 - 20) : 0), anchor: .bottom)
        case .reblogs:
            BarView()
                .scaleEffect(CGSize(width: 1, height: shouldAnimate ? calculateBarHeight(value: campaign.stats[idx].reblogs) / (height - 20 - 20) : 0), anchor: .bottom)
        }
    }
}

struct BarView: View {
    let color: Color = Color.blue
    var height: CGFloat = 20
    var idx: Int = 0
    @State var animate = false
    
    var delayedTime: TimeInterval {
        let time = Double(idx) * 0.1 + 0.3
        return time
    }
    
    var body: some View {
        Rectangle()
            .fill(color)
            
            
    }
}

struct BarGraphView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BarGraphView(campaign: CampaignInsights.insights[0], selectedSegment: .constant(.impressions))
                .previewLayout(.sizeThatFits)
            BarGraphView(campaign: CampaignInsights.insights[0], selectedSegment: .constant(.impressions))
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
    }
}
