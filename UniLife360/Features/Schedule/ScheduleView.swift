import SwiftUI

struct ScheduleView: View {
    @State private var viewModel = ScheduleViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ModuleHeader(
                    title: "Planning",
                    subtitle: "Votre semaine",
                    icon: "calendar",
                    color: ModuleColors.schedule
                )

                // Week navigation
                weekNavigator

                // Day selector
                daySelector

                // Events for selected day
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, minHeight: 200)
                } else if viewModel.eventsForSelectedDate.isEmpty {
                    EmptyStateView(
                        icon: "calendar.badge.plus",
                        title: "Aucun événement",
                        message: "Pas d'événements prévus pour ce jour",
                        buttonTitle: "Ajouter",
                        buttonColor: ModuleColors.schedule,
                        action: { viewModel.showNewEvent = true }
                    )
                } else {
                    dayTimeline
                }
            }
            .padding(.bottom, 32)
        }
        .background(Theme.background.ignoresSafeArea())
        .task { await viewModel.loadEvents() }
        .sheet(isPresented: $viewModel.showNewEvent) {
            NewEventView(selectedDate: viewModel.selectedDate, onSave: {
                Task { await viewModel.loadEvents() }
            })
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { viewModel.showNewEvent = true }) {
                    Image(systemName: "plus")
                        .fontWeight(.bold)
                }
            }
        }
    }

    private var weekNavigator: some View {
        HStack {
            Button(action: { viewModel.previousWeek() }) {
                Image(systemName: "chevron.left")
                    .fontWeight(.bold)
                    .frame(width: 36, height: 36)
                    .background(Color.white)
                    .brutalistBorder(cornerRadius: 10)
                    .shadow(color: .black.opacity(0.85), radius: 0, x: 2, y: 2)
            }

            Spacer()

            Text(weekRangeString)
                .font(.headline)

            Spacer()

            Button(action: { viewModel.nextWeek() }) {
                Image(systemName: "chevron.right")
                    .fontWeight(.bold)
                    .frame(width: 36, height: 36)
                    .background(Color.white)
                    .brutalistBorder(cornerRadius: 10)
                    .shadow(color: .black.opacity(0.85), radius: 0, x: 2, y: 2)
            }
        }
        .padding(.horizontal)
    }

    private var weekRangeString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = "d MMM"
        let days = viewModel.weekDays
        guard let first = days.first, let last = days.last else { return "" }
        return "\(formatter.string(from: first)) - \(formatter.string(from: last))"
    }

    private var daySelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(viewModel.weekDays, id: \.self) { day in
                    let isSelected = Calendar.current.isDate(day, inSameDayAs: viewModel.selectedDate)
                    let isToday = Calendar.current.isDateInToday(day)

                    Button(action: {
                        withAnimation(.spring(response: 0.3)) {
                            viewModel.selectedDate = day
                        }
                        HapticFeedback.selection()
                    }) {
                        VStack(spacing: 4) {
                            Text(dayName(day))
                                .font(.caption2)
                                .fontWeight(.medium)
                            Text("\(Calendar.current.component(.day, from: day))")
                                .font(.title3)
                                .fontWeight(isSelected ? .bold : .regular)
                        }
                        .frame(width: 48, height: 64)
                        .background(isSelected ? ModuleColors.schedule : (isToday ? ModuleColors.scheduleLight : Color.white))
                        .brutalistBorder(cornerRadius: 12, color: isSelected ? Theme.border : Theme.border.opacity(0.5))
                        .shadow(color: .black.opacity(isSelected ? 0.85 : 0.3), radius: 0, x: isSelected ? 3 : 1, y: isSelected ? 3 : 1)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
    }

    private func dayName(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = "EEE"
        return formatter.string(from: date).prefix(3).uppercased()
    }

    private var dayTimeline: some View {
        VStack(spacing: 8) {
            ForEach(viewModel.eventsForSelectedDate) { event in
                eventCard(event)
            }
        }
        .padding(.horizontal)
    }

    private func eventCard(_ event: CalendarEvent) -> some View {
        HStack(spacing: 12) {
            // Time
            VStack(spacing: 2) {
                Text(timeString(event.startTime))
                    .font(.caption)
                    .fontWeight(.bold)
                Text(timeString(event.endTime))
                    .font(.caption2)
                    .foregroundColor(Theme.textSecondary)
            }
            .frame(width: 48)

            // Color bar
            RoundedRectangle(cornerRadius: 2)
                .fill(event.type.color)
                .frame(width: 4)

            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)

                if let location = event.location {
                    HStack(spacing: 4) {
                        Image(systemName: "mappin")
                            .font(.caption2)
                        Text(location)
                            .font(.caption)
                    }
                    .foregroundColor(Theme.textSecondary)
                }
            }

            Spacer()

            // Type badge
            Text(event.type.label)
                .font(.caption2)
                .fontWeight(.medium)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(event.type.color.opacity(0.2))
                .clipShape(Capsule())
        }
        .brutalistCard(backgroundColor: .white)
    }

    private func timeString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
