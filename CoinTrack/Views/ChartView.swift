//
//  ChartView.swift
//  CoinTrack
//
//  Created by Sandip Rudani on 2022-10-11.
//

import SwiftUI
import Charts

struct ChartView: View {
    private let maxY: Double
    private let minY: Double
    private let lineColor: Color
    private let startingDate: Date
    private let endingDate: Date
    
    @State var data: [ChartModel]
    @State var selectedData: ChartModel?
        
    init(coin: CoinModel) {
        _data = State(initialValue: coin.chartModel)
       
        let dataValues = coin.chartModel.map { $0.price }
        maxY = dataValues.max() ?? 0
        minY = dataValues.min() ?? 0

        let priceChange = (dataValues.last ?? 0) - (dataValues.first ?? 0)
        lineColor = priceChange > 0 ? Color.green : Color.red
        endingDate = Date(stringValue: coin.lastUpdated ?? "")
        startingDate = endingDate.addingTimeInterval(-7*24*60*60)
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 10) {
                coinPriceChart()
                    .frame(height: 250)
                
                chartDateLabels
                    .padding(.horizontal, 4)
            }
            .font(.caption)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(.white.shadow(.drop(radius: 2)))
            }
        }
        .padding()
    }
    
    @ViewBuilder
    func coinPriceChart() -> some View {
        let temp = maxY/(Double(data.count))
        let minYScale = max(minY - temp , 0)
        let maxYScale = maxY + temp
        
        Chart {
            ForEach(data) { item in
                LineMark(
                    x: .value("", item.xIndex),
                    y: .value("", item.shouldAnimate ? item.price : minYScale)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(lineColor.gradient)

                AreaMark(
                    x: .value("", item.xIndex),
                    yStart: .value("", minYScale),
                    yEnd: .value("", item.shouldAnimate ? item.price : minYScale)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(lineColor.opacity(0.1).gradient)
                
                if let selectedData,
                   selectedData.id == item.id {
                   showRuleMark(for: selectedData)
                }
            }
        }
        .chartYScale(domain: minYScale...maxYScale)
        .chartXAxis(.hidden)
        .chartOverlay(content: { proxy in
            chartOverlay(content: proxy)
        })
        .frame(height: 250)
        .onAppear {
            animateChart()
        }
    }
    
   
    
    func showRuleMark(for selectedItem: ChartModel) -> some ChartContent  {
        RuleMark(x: .value("", selectedItem.xIndex))
            .lineStyle(.init(lineWidth: 2, miterLimit: 2, dash: [2], dashPhase: 5))
            .foregroundStyle(Color.gray.opacity(0.5))
            .annotation(position: .top) {
                ruleMarkView(for: selectedItem)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background {
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .fill(.white.shadow(.drop(radius: 2)))
                }
            }
    }
    
    func ruleMarkView(for selectedItem: ChartModel) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Price:")
                .foregroundColor(.gray)
                .font(.caption)
            
            Text(selectedItem.price.asCurrencyWithNumberOfDecimals(2))
                .font(.title3.bold())
            
        }
    }
    
    func animateChart() {
        for (index, _) in data.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.001, execute: {
                withAnimation(.easeInOut(duration: 0.6)) {
                    data[index].shouldAnimate = true
                }
            })
        }
    }
    
    func chartOverlay(content: ChartProxy) -> some View {
        GeometryReader { innerProxy in
            Rectangle()
                .fill(.clear)
                .contentShape(Rectangle())
                .gesture (
                    DragGesture()
                        .onChanged({ value in
                            updateChartRule(for: value, content: content)
                        })
                        .onEnded({ _ in
                            self.selectedData = nil
                        })
                )
        }
    }
    
    func updateChartRule(for value:  DragGesture.Value, content: ChartProxy) {
        let location = value.location
        if let index: Double = content.value(atX: location.x) {
            let value = Int(index)
            if let item = data.first(where: { data in
                return Int(data.xIndex) == value
            }) {
                self.selectedData = item
            }
        }
    }
}


struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(coin: previewHelper.coin)
    }
}

extension ChartView {
    private var chartDateLabels: some View {
        HStack {
            Text(startingDate.asShortDateString())
            Spacer()
            Text(endingDate.asShortDateString())
        }
    }
}
