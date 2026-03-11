import SwiftUI

struct SportView: View {
    @State private var workouts: [SportWorkout] = []
    @State private var weeklyStats: (workouts: Int, totalMinutes: Int, totalCalories: Int) = (0, 0, 0)
    @State private var isLoading = false
    @State private var showNewWorkout = false
    private let repository = SportRepository()

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ModuleHeader(
                    title: "Sport",
                    subtitle: "Restez actif",
                    icon: "figure.run",
                    color: ModuleColors.sport
                )

                // Weekly stats
                HStack(spacing: 12) {
                    statCard(value: "\(weeklyStats.workouts)", label: "Séances", icon: "flame.fill", color: ModuleColors.sport)
                    statCard(value: "\(weeklyStats.totalMinutes)m", label: "Minutes", icon: "clock.fill", color: ModuleColors.sportLight)
                    statCard(value: "\(weeklyStats.totalCalories)", label: "Calories", icon: "bolt.fill", color: Color(hex: "#fca5a5"))
                }
                .padding(.horizontal)

                // Progress ring
                VStack(spacing: 12) {
                    Text("Objectif hebdomadaire")
                        .font(.headline)

                    ProgressRing(
                        progress: Double(weeklyStats.workouts) / 4.0,
                        foregroundColor: ModuleColors.sport,
                        showLabel: true
                    )

                    Text("\(weeklyStats.workouts)/4 séances")
                        .font(.subheadline)
                        .foregroundColor(Theme.textSecondary)
                }
                .brutalistCard()
                .padding(.horizontal)

                // Recent workouts
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Entraînements récents")
                            .font(.headline)
                        Spacer()
                        Button(action: { showNewWorkout = true }) {
                            Label("Ajouter", systemImage: "plus")
                                .font(.caption)
                                .fontWeight(.bold)
                        }
                    }

                    if workouts.isEmpty {
                        EmptyStateView(
                            icon: "figure.walk",
                            title: "Aucun entraînement",
                            message: "Commencez à suivre vos séances",
                            buttonTitle: "Ajouter",
                            buttonColor: ModuleColors.sport,
                            action: { showNewWorkout = true }
                        )
                    } else {
                        ForEach(workouts) { workout in
                            workoutCard(workout)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 32)
        }
        .background(Theme.background.ignoresSafeArea())
        .task { await loadData() }
        .sheet(isPresented: $showNewWorkout) {
            NewWorkoutView(onSave: { Task { await loadData() } })
        }
    }

    private func statCard(value: String, label: String, icon: String, color: Color) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.black)
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            Text(label)
                .font(.caption2)
                .foregroundColor(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .brutalistCard(backgroundColor: color.opacity(0.15))
    }

    private func workoutCard(_ workout: SportWorkout) -> some View {
        HStack(spacing: 12) {
            Image(systemName: sportIcon(workout.type))
                .font(.title3)
                .frame(width: 40, height: 40)
                .background(ModuleColors.sportLight)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 2) {
                Text(workout.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text("\(workout.duration)min • \(workout.type)")
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
            }

            Spacer()

            if let calories = workout.caloriesBurned {
                VStack(alignment: .trailing) {
                    Text("\(calories)")
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Text("kcal")
                        .font(.caption2)
                        .foregroundColor(Theme.textSecondary)
                }
            }
        }
        .brutalistCard()
    }

    private func sportIcon(_ type: String) -> String {
        switch type.lowercased() {
        case "course", "running": "figure.run"
        case "musculation", "gym": "dumbbell.fill"
        case "natation", "swimming": "figure.pool.swim"
        case "vélo", "cycling": "bicycle"
        case "yoga": "figure.mind.and.body"
        default: "figure.walk"
        }
    }

    private func loadData() async {
        guard let userId = await SupabaseManager.shared.currentUserId else { return }
        isLoading = true
        workouts = (try? await repository.getWorkouts(userId: userId)) ?? []
        weeklyStats = (try? await repository.getWeeklyStats(userId: userId)) ?? (0, 0, 0)
        isLoading = false
    }
}
