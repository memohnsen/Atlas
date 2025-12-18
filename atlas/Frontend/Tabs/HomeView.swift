//
//  HomeView.swift
//  atlas
//
//  Created by Maddisen Mohnsen on 11/18/25.
//

import SwiftUI
import Supabase

struct HomeView: View {
    @StateObject var viewModel = ProgramDaysModel()
    @State private var snatchGoal: Int? = 120
    @State private var cjGoal: Int? = 150
    @State private var completedSessions: Int = 19
    @State private var totalSessions: Int = 40

    var athleteName: [String] { viewModel.athleteName }
    var programName: [String] { viewModel.programName }
    
    var remainingSessions: Int {
        return totalSessions - completedSessions
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                TitleSection(programName: programName, athleteName: athleteName)
            }
            
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("NEXT COMPETITION")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                        
                        Text("AO Finals")
                            .font(.system(size: 32, weight: .bold))
                    }
                        
                    Spacer()
                }
                
                HStack(spacing: 24) {
                    GoalCard(title: "Snatch", value: snatchGoal ?? 0)
                    GoalCard(title: "C&J", value: cjGoal ?? 0)
                    GoalCard(title: "Total", value: (snatchGoal ?? 0) + (cjGoal ?? 0))
                }
            }
            .padding(20)
            .background(Color(.systemGray6))
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
            .padding(.bottom)
                
            VStack {
                HStack(spacing: 4) {
                    Rectangle()
                        .fill(.white)
                        .frame(width: 40, height: 3)

                    Text("Time Remaining")
                        .font(.title3)
                        .fontWeight(.semibold)

                    Rectangle()
                        .fill(.white)
                        .frame(width: 40, height: 3)
                }
                
                HStack(spacing: 20) {
                    VStack(spacing: 8) {
                        Text("29")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.orange)
                        
                        Text("Days Away")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 6)
                    .padding(.bottom)
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    
                    VStack(spacing: 8) {
                        Text(String(remainingSessions))
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.blue)
                        
                        Text("Sessions Left")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 6)
                    .padding(.bottom)
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                }

                SessionGrid(
                    completedSessions: completedSessions,
                    totalSessions: totalSessions
                )
            }
            .padding(20)
            .background(Color(.systemGray6))
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        }
        .padding(.horizontal)
        .task {
            await viewModel.fetchAthleteName()
            await viewModel.fetchProgramName(athlete: athleteName.first ?? "")
        }
    }

    private func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: Date())
    }
}

struct TitleSection: View {
    var programName: [String]
    var athleteName: [String]
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(programName.first ?? "None Assigned")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            Spacer()
            
            Circle()
                .fill(Color.blue.opacity(0.3))
                .frame(width: 50, height: 50)
                .overlay(
                    Text(athleteName.first?.prefix(1).uppercased() ?? "A")
                        .font(.title3)
                        .fontWeight(.semibold)
                )
        }
        .padding(.top, 8)
    }
}

struct GoalCard: View {
    let title: String
    let value: Int
    
    var body: some View {
        VStack(spacing: 8) {
            Text("\(value)")
                .font(.system(size: 42, weight: .bold, design: .rounded))
                .foregroundStyle(.blue)
            
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 6)
    }
}

struct SessionGrid: View {
    let completedSessions: Int
    let totalSessions: Int

    private let columns = 7

    var body: some View {
        let rows = Int(ceil(Double(totalSessions) / Double(columns)))

        VStack(spacing: 12) {
            ForEach(0..<rows, id: \.self) { row in
                HStack(spacing: 12) {
                    ForEach(0..<columns, id: \.self) { col in
                        let index = row * columns + col
                        if index < totalSessions {
                            SessionDot(
                                isCompleted: index < completedSessions,
                                index: index
                            )
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 8)
    }
}

struct SessionDot: View {
    let isCompleted: Bool
    let index: Int

    var body: some View {
        Circle()
            .fill(isCompleted ? .blue : Color.gray.opacity(0.2))
            .frame(width: 32, height: 32)
            .overlay(
                Circle()
                    .stroke(isCompleted ? .blue.opacity(0.3) : Color.gray.opacity(0.3), lineWidth: 2)
            )
            .scaleEffect(isCompleted ? 1.0 : 0.85)
            .animation(.spring(response: 0.3, dampingFraction: 0.6).delay(Double(index) * 0.02), value: isCompleted)
    }
}

#Preview {
    HomeView()
}
