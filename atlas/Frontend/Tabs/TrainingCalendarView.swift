//
//  TrainingCalendarView.swift
//  atlas
//
//  Created by Maddisen Mohnsen on 11/18/25.
//

import SwiftUI

struct ExerciseSet: Identifiable {
    var id: Int
    var sets: String
    var reps: String
    var percent: String
    var notes: String?
}

struct Exercise: Identifiable {
    var id: Int
    var name: String
    var sets: [ExerciseSet]
}

struct TrainingDay: Identifiable {
    var id: Int
    var date: Date
    var dayOfWeek: String
    var dayNumber: Int
    var programName: String
    var workoutType: String
    var exercises: [Exercise]
    var duration: String
    var isCompleted: Bool
}

struct TrainingCalendarView: View {
    @State private var currentDayIndex: Int = 0
    @State private var showMonthView: Bool = false

    let trainingDays: [TrainingDay] = [
        TrainingDay(
            id: 1,
            date: Date(),
            dayOfWeek: "M",
            dayNumber: 18,
            programName: "4-Day Template",
            workoutType: "Day 1 - Snatch",
            exercises: [
                Exercise(id: 1, name: "Snatch", sets: [
                    ExerciseSet(id: 1, sets: "3", reps: "3", percent: "70%", notes: nil),
                    ExerciseSet(id: 2, sets: "2", reps: "2", percent: "80%", notes: nil),
                    ExerciseSet(id: 3, sets: "2", reps: "1", percent: "85%", notes: "Focus on speed")
                ]),
                Exercise(id: 2, name: "Snatch Pull", sets: [
                    ExerciseSet(id: 4, sets: "3", reps: "5", percent: "95%", notes: nil)
                ]),
                Exercise(id: 3, name: "Back Squat", sets: [
                    ExerciseSet(id: 5, sets: "5", reps: "5", percent: "75%", notes: nil)
                ]),
                Exercise(id: 4, name: "Core Work", sets: [
                    ExerciseSet(id: 6, sets: "3", reps: "12", percent: "BW", notes: "Weighted Sit-ups")
                ])
            ],
            duration: "90 min",
            isCompleted: true
        ),
        TrainingDay(
            id: 2,
            date: Date().addingTimeInterval(86400),
            dayOfWeek: "T",
            dayNumber: 19,
            programName: "4-Day Template",
            workoutType: "Day 2 - Clean",
            exercises: [
                Exercise(id: 5, name: "Clean", sets: [
                    ExerciseSet(id: 7, sets: "4", reps: "3", percent: "75%", notes: nil),
                    ExerciseSet(id: 8, sets: "2", reps: "2", percent: "85%", notes: nil)
                ]),
                Exercise(id: 6, name: "Front Squat", sets: [
                    ExerciseSet(id: 9, sets: "4", reps: "4", percent: "80%", notes: nil)
                ])
            ],
            duration: "85 min",
            isCompleted: false
        ),
        TrainingDay(
            id: 3,
            date: Date().addingTimeInterval(86400 * 2),
            dayOfWeek: "W",
            dayNumber: 20,
            programName: "4-Day Template",
            workoutType: "Rest Day",
            exercises: [],
            duration: "30 min",
            isCompleted: false
        ),
        TrainingDay(
            id: 4,
            date: Date().addingTimeInterval(86400 * 3),
            dayOfWeek: "T",
            dayNumber: 21,
            programName: "4-Day Template",
            workoutType: "Day 3 - Jerk",
            exercises: [
                Exercise(id: 7, name: "Jerk", sets: [
                    ExerciseSet(id: 10, sets: "3", reps: "3", percent: "75%", notes: nil),
                    ExerciseSet(id: 11, sets: "2", reps: "2", percent: "85%", notes: nil)
                ]),
                Exercise(id: 8, name: "Push Press", sets: [
                    ExerciseSet(id: 12, sets: "3", reps: "5", percent: "80%", notes: nil)
                ])
            ],
            duration: "80 min",
            isCompleted: false
        ),
        TrainingDay(
            id: 5,
            date: Date().addingTimeInterval(86400 * 4),
            dayOfWeek: "F",
            dayNumber: 22,
            programName: "4-Day Template",
            workoutType: "Day 4 - Total",
            exercises: [
                Exercise(id: 9, name: "Snatch", sets: [
                    ExerciseSet(id: 13, sets: "5", reps: "1", percent: "85%", notes: nil)
                ]),
                Exercise(id: 10, name: "Clean & Jerk", sets: [
                    ExerciseSet(id: 14, sets: "5", reps: "1", percent: "85%", notes: nil)
                ])
            ],
            duration: "95 min",
            isCompleted: false
        ),
        TrainingDay(
            id: 6,
            date: Date().addingTimeInterval(86400 * 5),
            dayOfWeek: "S",
            dayNumber: 23,
            programName: "4-Day Template",
            workoutType: "Rest Day",
            exercises: [],
            duration: "0 min",
            isCompleted: false
        ),
        TrainingDay(
            id: 7,
            date: Date().addingTimeInterval(86400 * 6),
            dayOfWeek: "S",
            dayNumber: 24,
            programName: "4-Day Template",
            workoutType: "Rest Day",
            exercises: [],
            duration: "0 min",
            isCompleted: false
        )
    ]

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                TabView(selection: $currentDayIndex) {
                    ForEach(Array(trainingDays.enumerated()), id: \.element.id) { index, day in
                        DayDetailView(day: day)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            
            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    ForEach(Array(trainingDays.enumerated()), id: \.element.id) { index, day in
                        DayButton(
                            day: day,
                            isSelected: currentDayIndex == index,
                            action: { currentDayIndex = index }
                        )
                    }
                }
                
                Capsule()
                    .frame(width: 40, height: 6)
                    .foregroundColor(Color(.systemGray3))
                    .padding(.vertical, 2)
            }
            .padding(.horizontal)
            .padding(.top, 40)
            .glassEffect(in: .rect(cornerRadius: 32))
        }
        .ignoresSafeArea()
        .preferredColorScheme(.dark)
    }
}

// MARK: - Day Button
struct DayButton: View {
    let day: TrainingDay
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(day.dayOfWeek)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(isSelected ? .blue : .secondary)

                Text("\(day.dayNumber)")
                    .font(.headline)
                    .fontWeight(isSelected ? .bold : .medium)
                    .foregroundColor(isSelected ? .blue : .gray)

                if day.isCompleted {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 6, height: 6)
                } else if !day.exercises.isEmpty {
                    Circle()
                        .fill(isSelected ? Color.blue : Color.white.opacity(0.5))
                        .frame(width: 6, height: 6)
                } else {
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 6, height: 6)
                }
            }
            .frame(width: 45)
            .padding(.top, 32)
            .padding(.bottom)
            .cornerRadius(12)
        }
    }
}

// MARK: - Day Detail View
struct DayDetailView: View {
    let day: TrainingDay

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(day.workoutType)
                            .font(.title2)
                            .fontWeight(.bold)

                        Text(day.programName)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    HStack {
                        Button{
                            
                        } label: {
                            Image(systemName: day.isCompleted ? "trophy.fill" : "play.fill")
                                .foregroundStyle(day.isCompleted ? .yellow : .green)
                                .frame(width: 20, height: 20)
                        }
                        .padding()
                        .glassEffect()
                        
                        Button{
                            
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundStyle(.white)
                                .frame(width: 20, height: 20)
                        }
                        .padding()
                        .glassEffect()
                    }
                }
                .padding(.top, 90)
                .padding(.bottom)

                if day.exercises.isEmpty {
                    restDayView
                } else {
                    workoutView
                }
            }
            .padding()
        }
    }

    private var restDayView: some View {
        VStack(spacing: 20) {
            Image(systemName: "moon.zzz.fill")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
                .padding(.top, 40)

            Text("Rest Day")
                .font(.title)
                .fontWeight(.bold)

            Text("Take time to recover and prepare for your next training session")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 60)
    }

    private var workoutView: some View {
        VStack(spacing: 20) {
            ForEach(day.exercises) { exercise in
                ExerciseCard(exercise: exercise)
            }
        }
    }
}

// MARK: - Exercise Card
struct ExerciseCard: View {
    let exercise: Exercise

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(exercise.name)
                .font(.title3)
                .fontWeight(.bold)

            Divider()
            
            VStack(spacing: 8) {
                ForEach(exercise.sets) { set in
                    HStack {
                        Text(set.sets)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .frame(width: 50, alignment: .leading)
                        
                        Text("x")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .frame(width: 50, alignment: .leading)

                        Text(set.reps)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .frame(width: 50, alignment: .leading)
                        
                        Text("@")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .frame(width: 50, alignment: .leading)

                        Text(set.percent)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                            .frame(width: 50, alignment: .leading)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.5))
        .cornerRadius(16)
    }
}

#Preview {
    TrainingCalendarView()
}
