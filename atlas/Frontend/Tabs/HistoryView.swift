//
//  HistoryView.swift
//  atlas
//
//  Created by Maddisen Mohnsen on 11/18/25.
//

import SwiftUI

struct WorkoutHistory: Identifiable {
    var id: Int
    var date: String
    var weekNumber: Int
    var dayNumber: Int
    var exercise: String
    var topWeight: Int
}

struct HistoryView: View {
    let workoutHistory: [WorkoutHistory] = [
        WorkoutHistory(id: 1, date: "11/19/2025", weekNumber: 1, dayNumber: 4, exercise: "Snatch", topWeight: 110),
        WorkoutHistory(id: 2, date: "11/18/2025", weekNumber: 1, dayNumber: 3, exercise: "Jerk", topWeight: 130),
        WorkoutHistory(id: 3, date: "11/17/2025", weekNumber: 1, dayNumber: 2, exercise: "Clean", topWeight: 130),
        WorkoutHistory(id: 4, date: "11/16/2025", weekNumber: 1, dayNumber: 1, exercise: "Snatch", topWeight: 100)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Training History")
                            .font(.system(size: 34, weight: .bold))

                        Text("\(workoutHistory.count) workouts completed")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 8)

                    HStack(spacing: 12) {
                        FilterButton(title: "All", isSelected: true)
                        FilterButton(title: "This Week", isSelected: false)
                        FilterButton(title: "This Month", isSelected: false)

                        Spacer()

                        Button(action: {}) {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .font(.title3)
                                .foregroundColor(.blue)
                        }
                    }

                    VStack(spacing: 12) {
                        ForEach(workoutHistory) { workout in
                            WorkoutHistoryCard(workout: workout)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct WorkoutHistoryCard: View {
    let workout: WorkoutHistory

    var body: some View {
        HStack(spacing: 16) {
            VStack(spacing: 4) {
                Text(getDayNumber(from: workout.date))
                    .font(.system(size: 24, weight: .bold))
                Text(getMonthAbbreviation(from: workout.date))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(width: 60, height: 60)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(12)

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("Week \(workout.weekNumber) • Day \(workout.dayNumber)")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Text(workout.exercise)
                    .font(.headline)

                HStack(spacing: 4) {
                    Image(systemName: "figure.strengthtraining.traditional")
                        .font(.caption)
                    Text("Top Set: \(workout.topWeight) kg")
                        .font(.subheadline)
                }
                .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }

    private func getDayNumber(from dateString: String) -> String {
        let components = dateString.split(separator: "/")
        return components.count > 1 ? String(components[1]) : "00"
    }

    private func getMonthAbbreviation(from dateString: String) -> String {
        let components = dateString.split(separator: "/")
        guard components.count > 0,
              let month = Int(components[0]) else {
            return "JAN"
        }

        let months: [String] = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]
        return months[month - 1]
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool

    var body: some View {
        Text(title)
            .font(.subheadline)
            .fontWeight(isSelected ? .semibold : .regular)
            .foregroundColor(isSelected ? .white : .primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? Color.blue : Color(.systemGray6))
            .cornerRadius(20)
    }
}

#Preview {
    HistoryView()
}
