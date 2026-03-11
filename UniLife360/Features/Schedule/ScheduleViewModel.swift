import Foundation

@Observable
final class ScheduleViewModel {
    var events: [CalendarEvent] = []
    var selectedDate = Date()
    var selectedWeekStart = Date()
    var isLoading = false
    var errorMessage: String?
    var showNewEvent = false

    private let repository = CalendarRepository()

    var weekDays: [Date] {
        let calendar = Calendar.current
        let start = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: selectedWeekStart))!
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: start) }
    }

    var eventsForSelectedDate: [CalendarEvent] {
        let calendar = Calendar.current
        return events.filter { calendar.isDate($0.startTime, inSameDayAs: selectedDate) }
            .sorted { $0.startTime < $1.startTime }
    }

    var timeSlots: [Int] { Array(7...21) }

    func loadEvents() async {
        guard let userId = await SupabaseManager.shared.currentUserId else { return }
        isLoading = true

        let calendar = Calendar.current
        let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: selectedWeekStart))!
        let weekEnd = calendar.date(byAdding: .day, value: 7, to: weekStart)!

        do {
            events = try await repository.getEvents(userId: userId, from: weekStart, to: weekEnd)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func previousWeek() {
        selectedWeekStart = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: selectedWeekStart)!
        Task { await loadEvents() }
    }

    func nextWeek() {
        selectedWeekStart = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: selectedWeekStart)!
        Task { await loadEvents() }
    }

    func deleteEvent(_ event: CalendarEvent) async {
        do {
            try await repository.deleteEvent(id: event.id)
            events.removeAll { $0.id == event.id }
            HapticFeedback.success()
        } catch {
            errorMessage = error.localizedDescription
            HapticFeedback.error()
        }
    }
}
