//
//  ContentView.swift
//  atlas
//
//  Created by Maddisen Mohnsen on 11/18/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var search = ""
    @AppStorage("selectedTab") var selectedTab: String = "Home"

    var body: some View {
        TabView(selection: $selectedTab){
            Tab("Progress", systemImage: "chart.bar", value: "Progress") {
                LiftingProgressView()
            }
            Tab("History", systemImage: "clock.arrow.trianglehead.counterclockwise.rotate.90", value: "History") {
                HistoryView()
            }
            Tab("Home", systemImage: "house.fill", value: "Home") {
                HomeView()
            }
            Tab("Calendar", systemImage: "calendar", value: "Calendar") {
                TrainingCalendarView()
            }
            
            Tab("Profile", systemImage: "person", value: "Profile") {
                ProfileView()
            }
        }
    }

}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
