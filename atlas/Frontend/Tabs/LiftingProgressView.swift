//
//  LiftingProgressView.swift
//  atlas
//
//  Created by Maddisen Mohnsen on 11/18/25.
//

import SwiftUI

struct LiftData: Identifiable {
    var id: Int
    var liftName: String
    var currentPR: Int
    var previousPR: Int
    var lastTested: String
    var trend: TrendDirection
}

enum TrendDirection {
    case up, down, stable
}

struct LiftingProgressView: View {
    let lifts: [LiftData] = [
        LiftData(id: 1, liftName: "Snatch", currentPR: 110, previousPR: 105, lastTested: "11/19/2025", trend: .up),
        LiftData(id: 2, liftName: "Clean & Jerk", currentPR: 140, previousPR: 135, lastTested: "11/18/2025", trend: .up),
        LiftData(id: 3, liftName: "Back Squat", currentPR: 180, previousPR: 180, lastTested: "11/15/2025", trend: .stable),
        LiftData(id: 4, liftName: "Front Squat", currentPR: 150, previousPR: 155, lastTested: "11/12/2025", trend: .down)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Lifting Progress")
                            .font(.system(size: 34, weight: .bold))

                        Text("Track your personal records")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 8)

                    HStack(spacing: 12) {
                        FilterButton(title: "All Lifts", isSelected: true)
                        FilterButton(title: "Olympic", isSelected: false)
                        FilterButton(title: "Strength", isSelected: false)

                        Spacer()

                        Button(action: {}) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title3)
                                .foregroundColor(.blue)
                        }
                    }

                    VStack(spacing: 16) {
                        ForEach(lifts) { lift in
                            LiftProgressCard(lift: lift)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - Lift Progress Card
struct LiftProgressCard: View {
    let lift: LiftData

    var body: some View {
        VStack(spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(lift.liftName)
                        .font(.title3)
                        .fontWeight(.bold)

                    Text("Last tested: \(lift.lastTested)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                trendIndicator
            }

            Divider()

            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("CURRENT PR")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)

                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(lift.currentPR)")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.blue)
                        Text("kg")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text("PREVIOUS")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)

                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(lift.previousPR)")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                        Text("kg")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }

            if lift.currentPR != lift.previousPR {
                HStack(spacing: 4) {
                    Image(systemName: lift.trend == .up ? "arrow.up.right" : "arrow.down.right")
                        .font(.caption)
                    Text("\(abs(lift.currentPR - lift.previousPR)) kg \(lift.trend == .up ? "increase" : "decrease")")
                        .font(.subheadline)
                }
                .foregroundColor(lift.trend == .up ? .green : .orange)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(20)
        .background(Color(.systemGray6))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
    }

    private var trendIndicator: some View {
        Group {
            switch lift.trend {
            case .up:
                Image(systemName: "arrow.up.circle.fill")
                    .font(.title2)
                    .foregroundColor(.green)
            case .down:
                Image(systemName: "arrow.down.circle.fill")
                    .font(.title2)
                    .foregroundColor(.orange)
            case .stable:
                Image(systemName: "minus.circle.fill")
                    .font(.title2)
                    .foregroundColor(.gray)
            }
        }
    }
}

// MARK: - Filter Button
struct LiftFilterButton: View {
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
    LiftingProgressView()
}
