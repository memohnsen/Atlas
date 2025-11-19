//
//  FetchProgramDays.swift
//  atlas
//
//  Created by Maddisen Mohnsen on 11/19/25.
//

import Supabase
import Combine
import Foundation

struct AthleteNameRow: Decodable {
    var athlete_name: String
}



@MainActor
class ProgramDaysModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published var athleteName: [String] = []
    
    func fetchAthleteName() async {
        isLoading = true
        error = nil
        
        do {
            let response = try await supabase
                .from("program_days")
                .select("athlete_name")
                .execute()
            
            let rows = try JSONDecoder().decode([AthleteNameRow].self, from: response.data)
            let unique = Array(Set(rows.map { $0.athlete_name }))
            let sorted = unique.sorted()
            
            self.athleteName = sorted
        } catch {
            print("Error: \(error)")
            self.error = error
        }
        
        isLoading = false
    }
    
    func fetchProgram() async {
        
    }
}
