import SwiftUI

struct TabBarView: View {
    @Environment(AppRouter.self) private var router

    var body: some View {
        @Bindable var router = router

        TabView(selection: $router.selectedTab) {
            NavigationStack(path: $router.path) {
                DashboardView()
                    .navigationDestination(for: AppDestination.self) { destination in
                        destinationView(for: destination)
                    }
            }
            .tag(AppTab.home)
            .tabItem {
                Label(AppTab.home.title, systemImage: AppTab.home.icon)
            }

            NavigationStack {
                FinanceView()
                    .navigationDestination(for: AppDestination.self) { destination in
                        destinationView(for: destination)
                    }
            }
            .tag(AppTab.finance)
            .tabItem {
                Label(AppTab.finance.title, systemImage: AppTab.finance.icon)
            }

            NavigationStack {
                AcademicView()
                    .navigationDestination(for: AppDestination.self) { destination in
                        destinationView(for: destination)
                    }
            }
            .tag(AppTab.studies)
            .tabItem {
                Label(AppTab.studies.title, systemImage: AppTab.studies.icon)
            }

            NavigationStack {
                FriendsView()
                    .navigationDestination(for: AppDestination.self) { destination in
                        destinationView(for: destination)
                    }
            }
            .tag(AppTab.friends)
            .tabItem {
                Label(AppTab.friends.title, systemImage: AppTab.friends.icon)
            }

            NavigationStack {
                ScheduleView()
                    .navigationDestination(for: AppDestination.self) { destination in
                        destinationView(for: destination)
                    }
            }
            .tag(AppTab.schedule)
            .tabItem {
                Label(AppTab.schedule.title, systemImage: AppTab.schedule.icon)
            }
        }
        .tint(router.selectedTab.color)
    }

    @ViewBuilder
    private func destinationView(for destination: AppDestination) -> some View {
        switch destination {
        case .financeDetail:
            FinanceView()
        case .newTransaction:
            NewTransactionView()
        case .budgetSettings:
            Text("Budget Settings")
        case .financeAdvisor:
            FinanceAdvisorView()
        case .eventDetail(let event):
            EventDetailView(event: event)
        case .newEvent:
            NewEventView()
        case .courseDetail(let course):
            CourseDetailView(course: course)
        case .noteDetail(let note):
            NoteDetailView(note: note)
        case .aiTutor:
            AITutorView()
        case .examPractice:
            Text("Exam Practice")
        case .socialEventDetail(let event):
            SocialEventDetailView(event: event)
        case .circleDetail(let circle):
            CircleDetailView(circle: circle)
        case .circleDiscover:
            CircleDiscoverView()
        case .friendProfile(let userId):
            FriendProfileView(userId: userId)
        case .chat(let conversation):
            ChatView(conversation: conversation)
        case .friendRequests:
            FriendRequestsView()
        case .jobDetail(let job):
            JobDetailView(job: job)
        case .applicationDetail(let application):
            ApplicationDetailView(application: application)
        case .newApplication(let job):
            NewApplicationView(job: job)
        case .profile:
            ProfileView()
        case .editProfile:
            EditProfileView()
        case .settings:
            SettingsView()
        case .sportDetail:
            SportView()
        case .newWorkout:
            NewWorkoutView()
        }
    }
}
