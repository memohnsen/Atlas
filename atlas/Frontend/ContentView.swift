//
//  ContentView.swift
//  atlas
//
//  Created by Maddisen Mohnsen on 11/18/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedTab: String = "Home"

    var body: some View {
        TabView(selection: $selectedTab){
            Tab(value: "Home") {
                HomeView()
            } label: {
                Image(systemName: "house.fill")
            }
            
            Tab(value: "Calendar") {
                TrainingCalendarView()
            } label: {
                Image(systemName: "calendar")
            }
            
            Tab(value: "Progress") {
                LiftingProgressView()
            } label: {
                Image(systemName: "chart.bar")
            }

            Tab(value: "History") {
                HistoryView()
            } label: {
                Image(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90")
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
