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

struct ProgramNameRow: Decodable {
    var program_name: String
}

@MainActor
class ProgramDaysModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published var athleteName: [String] = []
    @Published var programName: [String] = []
    
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
    
    func fetchProgramName(athlete: String) async {
        isLoading = true
        error = nil
        
        do {
            let response = try await supabase
                .from("program_days")
                .select("program_name")
                .eq("athlete_name", value: athlete)
                .execute()
            
            let rows = try JSONDecoder().decode([ProgramNameRow].self, from: response.data)
            let unique = Array(Set(rows.map { $0.program_name }))
            let sorted = unique.sorted()
            
            self.programName = sorted
        } catch {
            print("Error: \(error)")
            self.error = error
        }
        
        isLoading = false
    }
}
