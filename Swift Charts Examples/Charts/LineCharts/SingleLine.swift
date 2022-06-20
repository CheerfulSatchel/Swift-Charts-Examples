//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct SingleLineOverview: View {

    var data = SalesData.last30Days

    var body: some View {
        Chart(data, id: \.day) {
            LineMark(
                x: .value("Day", $0.day, unit: .day),
                y: .value("Sales", $0.sales)
            )
            .interpolationMethod(.cardinal)
            .foregroundStyle(Color.blue.gradient)
        }
        .accessibilityChartDescriptor(self)
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .frame(height: Constants.previewChartHeight)
    }
}

struct SingleLine: View {
    @State private var lineWidth = 2.0
    @State private var interpolationMethod: ChartInterpolationMethod = .cardinal
    @State private var chartColor: Color = .blue
    @State private var showSymbols = false
    @State private var data: [Sale] = SalesData.last30Days.map { Sale(day: $0.day, sales: 0) }

    var body: some View {
        List {
            Section {
                Chart(data, id: \.day) {
                    LineMark(
                        x: .value("Date", $0.day),
                        y: .value("Sales", $0.sales)
                    )
                    .accessibilityLabel($0.day.formatted())
                    .accessibilityValue("\($0.sales) sold")
                    .lineStyle(StrokeStyle(lineWidth: lineWidth))
                    .foregroundStyle(chartColor.gradient)
                    .interpolationMethod(interpolationMethod.mode)
                    .symbol(Circle().strokeBorder(lineWidth: lineWidth))
                    .symbolSize(showSymbols ? 60 : 0)
                }
                .frame(height: Constants.detailChartHeight)
            }
            
            customisation
        }
        .navigationBarTitle(ChartType.singleLine.title, displayMode: .inline)
        .onAppear {
            for index in data.indices {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.02) {
                    withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                        data[index].sales = SalesData.last30Days[index].sales
                    }
                }
            }
        }
    }
    
    private var customisation: some View {
        Section {
            Stepper(value: $lineWidth, in: 1.0...20.0) {
                HStack {
                    Text("Line Width")
                    Spacer()
                    Text("\(String(format: "%.0f",lineWidth))")
                }
            }
            
            Picker("Interpolation Method", selection: $interpolationMethod) {
                ForEach(ChartInterpolationMethod.allCases) { Text($0.mode.description).tag($0) }
            }
            
            ColorPicker("Color Picker", selection: $chartColor)

            Toggle("Show Symbols", isOn: $showSymbols)
        }
    }
}

struct SingleLine_Previews: PreviewProvider {
    static var previews: some View {
        SingleLineOverview()
        SingleLine()
    }
}
