import SwiftUI

@Observable
final class AppRouter {
    var path = NavigationPath()
    var selectedTab: AppTab = .home
    var showNewTransaction = false
    var showNewEvent = false

    func navigate(to destination: AppDestination) {
        path.append(destination)
    }

    func goBack() {
        if !path.isEmpty {
            path.removeLast()
        }
    }

    func goToRoot() {
        path = NavigationPath()
    }

    func switchTab(_ tab: AppTab) {
        if selectedTab == tab {
            goToRoot()
        } else {
            selectedTab = tab
        }
    }
}

enum AppTab: Int, CaseIterable {
    case home, finance, studies, friends, schedule

    var title: String {
        switch self {
        case .home: "Accueil"
        case .finance: "Finance"
        case .studies: "Études"
        case .friends: "Amis"
        case .schedule: "Planning"
        }
    }

    var icon: String {
        switch self {
        case .home: "house.fill"
        case .finance: "banknote.fill"
        case .studies: "book.fill"
        case .friends: "person.2.fill"
        case .schedule: "calendar"
        }
    }

    var color: Color {
        switch self {
        case .home: Color(hex: "#86efac")
        case .finance: Color(hex: "#86efac")
        case .studies: Color(hex: "#d8b4fe")
        case .friends: Color(hex: "#f9a8d4")
        case .schedule: Color(hex: "#93c5fd")
        }
    }
}
