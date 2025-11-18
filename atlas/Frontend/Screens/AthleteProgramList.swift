//
//  AthleteProgramList.swift
//  atlas
//
//  Created by Maddisen Mohnsen on 11/18/25.
//

import SwiftUI
import ConvexMobile
import Combine

struct AthleteProgramList: View {
    @State private var programs: [String] = []
    @State private var errorMessage: String?

    var athleteName: String
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(programs, id: \.self) { program in
                    Text(program.capitalized)
                }
            }
            .navigationTitle("\(athleteName.capitalized)'s Programs")
            .task {
                do {
                    let programs = try await convex.subscribe(
                        to: "programs:getProgramsByAthlete",
                        with: ["athlete_name": athleteName],
                        yielding: [String].self
                    )

                    for try await programList in programs.values {
                        self.programs = programList
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
    AthleteProgramList(athleteName: "beth")
}
