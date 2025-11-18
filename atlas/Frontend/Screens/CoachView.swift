//
//  HomeView().swift
//  atlas
//
//  Created by Maddisen Mohnsen on 11/18/25.
//

import SwiftUI
import Combine
import ConvexMobile

struct CoachView: View {
    @State private var athleteList: [String] = []
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
                List {
                    ForEach(athleteList, id: \.self) { athlete in
                        NavigationLink("\(athlete.capitalized)", destination: AthleteProgramList(athleteName: athlete))
                    }
                }
                .navigationTitle("Athletes")
                .task {
                    do {
                        let athletes = try await convex.subscribe(to: "athletes:getUniqueAthletes", yielding: [String].self)

                        for try await athleteNames in athletes.values {
                            self.athleteList = athleteNames
                            self.errorMessage = nil
                        }
                    } catch {
                        self.errorMessage = error.localizedDescription
                        print("Convex subscription error: \(error)")
                    }
            }
        }
    }
}

#Preview {
    CoachView()
}
