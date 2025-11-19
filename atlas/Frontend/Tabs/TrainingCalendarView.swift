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

    let trainingDays: [TrainingDay] = [
        TrainingDay(
            id: 1,
            date: Date(),
            dayOfWeek: "MON",
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
            isCompleted: false
        ),
        TrainingDay(
            id: 2,
            date: Date().addingTimeInterval(86400),
            dayOfWeek: "TUE",
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
            dayOfWeek: "WED",
            dayNumber: 20,
            programName: "Rest Day",
            workoutType: "Active Recovery",
            exercises: [],
            duration: "30 min",
            isCompleted: false
        ),
        TrainingDay(
            id: 4,
            date: Date().addingTimeInterval(86400 * 3),
            dayOfWeek: "THU",
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
            dayOfWeek: "FRI",
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
            dayOfWeek: "SAT",
            dayNumber: 23,
            programName: "Rest Day",
            workoutType: "Recovery",
            exercises: [],
            duration: "0 min",
            isCompleted: false
        ),
        TrainingDay(
            id: 7,
            date: Date().addingTimeInterval(86400 * 6),
            dayOfWeek: "SUN",
            dayNumber: 24,
            programName: "Rest Day",
            workoutType: "Recovery",
            exercises: [],
            duration: "0 min",
            isCompleted: false
        )
    ]

    var body: some View {
        VStack(spacing: 0) {
            headerSection

            TabView(selection: $currentDayIndex) {
                ForEach(Array(trainingDays.enumerated()), id: \.element.id) { index, day in
                    DayDetailView(day: day)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }

    private var headerSection: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(trainingDays[currentDayIndex].workoutType)
                        .font(.title2)
                        .fontWeight(.bold)

                    Text(trainingDays[currentDayIndex].programName)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                if trainingDays[currentDayIndex].isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.green)
                }
            }
            .padding(.horizontal)
            .padding(.top)

            VStack(spacing: 12) {
                HStack {
                    Button(action: {
                        if currentDayIndex > 0 {
                            currentDayIndex -= 1
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .foregroundColor(.blue)
                    }
                    .disabled(currentDayIndex == 0)

                    Spacer()

                    Text("November 18 - 24")
                        .font(.headline)

                    Spacer()

                    Button(action: {
                        if currentDayIndex < trainingDays.count - 1 {
                            currentDayIndex += 1
                        }
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.title3)
                            .foregroundColor(.blue)
                    }
                    .disabled(currentDayIndex == trainingDays.count - 1)
                }

                HStack(spacing: 8) {
                    ForEach(Array(trainingDays.enumerated()), id: \.element.id) { index, day in
                        DayButton(
                            day: day,
                            isSelected: currentDayIndex == index,
                            action: { currentDayIndex = index }
                        )
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(Color(.systemGray6))
            .cornerRadius(16)
            .padding(.horizontal)
        }
        .padding(.bottom, 12)
        .background(Color(.systemBackground))
    }
}

// MARK: - Day Detail View
struct DayDetailView: View {
    let day: TrainingDay

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
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
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.subheadline)
                    Text(day.duration)
                        .font(.subheadline)
                }
                .foregroundColor(.secondary)

                Spacer()

                Text("\(day.exercises.count) exercises")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 4)

            ForEach(day.exercises) { exercise in
                ExerciseCard(exercise: exercise)
            }

            Button(action: {}) {
                HStack(spacing: 8) {
                    Image(systemName: "play.fill")
                        .font(.headline)
                    Text("Start Workout")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(16)
            }
            .padding(.top, 8)
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

            VStack(spacing: 8) {
                HStack {
                    Text("SETS")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .frame(width: 50, alignment: .leading)

                    Text("REPS")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .frame(width: 50, alignment: .leading)

                    Text("WEIGHT")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 12)

                Divider()

                ForEach(exercise.sets) { set in
                    HStack {
                        Text(set.sets)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .frame(width: 50, alignment: .leading)

                        Text(set.reps)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .frame(width: 50, alignment: .leading)

                        HStack(spacing: 4) {
                            Text(set.percent)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)

                            if let notes = set.notes {
                                Text("• \(notes)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
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

// MARK: - Day Button
struct DayButton: View {
    let day: TrainingDay
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Text(day.dayOfWeek)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(isSelected ? .white : .secondary)

                Text("\(day.dayNumber)")
                    .font(.headline)
                    .fontWeight(isSelected ? .bold : .medium)
                    .foregroundColor(isSelected ? .white : .primary)

                if day.isCompleted {
                    Circle()
                        .fill(isSelected ? Color.white : Color.green)
                        .frame(width: 6, height: 6)
                } else if !day.exercises.isEmpty {
                    Circle()
                        .fill(isSelected ? Color.white.opacity(0.5) : Color.blue.opacity(0.3))
                        .frame(width: 6, height: 6)
                } else {
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 6, height: 6)
                }
            }
            .frame(width: 50)
            .padding(.vertical, 12)
            .background(isSelected ? Color.blue : Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}

#Preview {
    TrainingCalendarView()
}
