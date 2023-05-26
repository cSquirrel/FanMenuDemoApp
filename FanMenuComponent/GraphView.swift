import SwiftUI
import Charts

struct MockData: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
    
    init(year: Int, month: Int, day: Int, value: Double) {
        self.date = Calendar.current.date(from: .init(year: year, month: month, day: day)) ?? Date()
        self.value = value
    }
}

let mockData = [ MockData(year: 2021, month: 7, day: 1, value: 100.0),
                          MockData(year: 2021, month: 8, day: 1, value: 98.0),
                          MockData(year: 2021, month: 9, day: 1, value: 78.0),
                          MockData(year: 2021, month: 10, day: 1, value: 87.0),
                          MockData(year: 2021, month: 11, day: 1, value: 99.0),
                          MockData(year: 2021, month: 12, day: 1, value: 100.0),
                          MockData(year: 2022, month: 1, day: 1, value: 87.0),
                          MockData(year: 2022, month: 2, day: 1, value: 77.0),
                          MockData(year: 2022, month: 3, day: 1, value: 95.0)
]
struct SimpleLineChartView: View {
    
    var body: some View {
        let curColor = Color.gray
        let curGradient = LinearGradient(
            gradient: Gradient (
                colors: [
                    curColor.opacity(0.5),
                    curColor.opacity(0.2),
                    curColor.opacity(0.05),
                ]
            ),
            startPoint: .top,
            endPoint: .bottom
        )
        
        VStack {
            Chart {
                ForEach(mockData) { item in
                    AreaMark(
                        x: .value("Date", item.date),
                        y: .value("Value", item.value)
                    )
                    .interpolationMethod(.linear)
                    .foregroundStyle(curGradient)
                }
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
        }
    }
}

struct GraphView: View {
    
    let timeRanges = ["1H","24H","7D","30D","60D","90D","1Y", "ALL"]
    let selectedTimeRange = "1H"
    
    var body: some View {
        VStack {
            HStack {
                ForEach(timeRanges, id: \.self) {
                    let isSelected = $0 == selectedTimeRange
                    Text($0)
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(isSelected ? .MELDRed1 : .tileLightGrayTitle)
                }
            }
            SimpleLineChartView()
        }
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            GraphView()
        }
    }
}
