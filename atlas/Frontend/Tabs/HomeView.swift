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

    var athleteName: [String] { viewModel.athleteName }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(getCurrentDate())
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

                VStack(alignment: .leading, spacing: 16) {
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Current Program")
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            Text("4-Day Template")
                                .font(.system(size: 28, weight: .bold))
                        }

                        Spacer()

                        Image(systemName: "dumbbell.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.blue.opacity(0.3))
                    }

                    Divider()

                    HStack(alignment: .center, spacing: 12) {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 50, height: 50)
                            .overlay(
                                Image(systemName: "figure.strengthtraining.traditional")
                                    .foregroundColor(.white)
                                    .font(.title3)
                            )

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Up Next")
                                .font(.caption)
                                .foregroundColor(.secondary)

                            Text("Total Day")
                                .font(.headline)

                            Text("Ready to train?")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                }
                .padding(20)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.05)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.08), radius: 15, x: 0, y: 5)

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

                    HStack(spacing: 20) {
                        VStack(spacing: 8) {
                            Text("29")
                                .font(.system(size: 56, weight: .bold))
                                .foregroundColor(.orange)

                            Text("Days Away")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(Color(.systemGray6))
                        .cornerRadius(16)

                        VStack(spacing: 8) {
                            Text("12")
                                .font(.system(size: 56, weight: .bold))
                                .foregroundColor(.blue)

                            Text("Sessions Left")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(Color(.systemGray6))
                        .cornerRadius(16)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Training Progress")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Spacer()
                            Text("67%")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                        }

                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(.systemGray5))
                                    .frame(height: 12)

                                RoundedRectangle(cornerRadius: 8)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [.blue, .purple]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: geometry.size.width * 0.67, height: 12)
                            }
                        }
                        .frame(height: 12)
                    }
                }
                .padding(20)
                .background(Color(.systemGray6))
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
            }
            .padding(.horizontal)
        }
        .task {
            await viewModel.fetchAthleteName()
        }
    }

    private func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: Date())
    }
}

#Preview {
    HomeView()
}
