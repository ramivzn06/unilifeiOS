import SwiftUI

struct DashboardView: View {
    @State private var viewModel = DashboardViewModel()
    @Environment(AppRouter.self) private var router

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // MARK: - Hero Welcome
                heroCard

                // MARK: - Quick Actions
                quickActionsRow

                // MARK: - Bento Grid
                bentoGrid

                // MARK: - AI Tip
                aiTipCard
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 100) // Tab bar clearance
        }
        .background(Color(hex: "#fefce8"))
        .task {
            await viewModel.loadData()
        }
    }

    // MARK: - Hero Card
    private var heroCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(viewModel.formattedDate)
                .font(.system(size: 11, weight: .bold))
                .textCase(.uppercase)
                .tracking(1.5)
                .opacity(0.6)

            Text("\(viewModel.greeting), \(viewModel.userName) 👋")
                .font(.system(size: 28, weight: .heavy, design: .rounded))

            Text("Voici ton tableau de bord. Un aperçu rapide de ta journée et de tes objectifs.")
                .font(.system(size: 14, weight: .medium))
                .opacity(0.7)

            // Stat pills
            FlowLayout(spacing: 8) {
                statPill(icon: "book.fill", label: "3 cours aujourd'hui")
                statPill(icon: "banknote.fill", label: "\(viewModel.remainingBudget.formatted()) € restants")
                statPill(icon: "party.popper.fill", label: "3 événements")
                statPill(icon: "target", label: "75% objectif sport")
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [
                    Color(hex: "#86efac").opacity(0.6),
                    Color(hex: "#d8b4fe").opacity(0.4),
                    Color(hex: "#f9a8d4").opacity(0.3)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(hex: "#0a0a0a"), lineWidth: 2)
        )
        .shadow(color: .black, radius: 0, x: 4, y: 4)
    }

    private func statPill(icon: String, label: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 11))
            Text(label)
                .font(.system(size: 11, weight: .bold))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.white.opacity(0.9))
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(Color(hex: "#0a0a0a").opacity(0.8), lineWidth: 1.5)
        )
    }

    // MARK: - Quick Actions
    private var quickActionsRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                quickAction(icon: "plus", label: "Dépense", color: "#86efac", tab: .finance)
                quickAction(icon: "eye.fill", label: "Mes notes", color: "#d8b4fe", tab: .studies)
                quickAction(icon: "calendar", label: "Planning", color: "#fdba74", tab: .schedule)
                quickAction(icon: "party.popper.fill", label: "Événements", color: "#f9a8d4", tab: .home)
                quickAction(icon: "bolt.fill", label: "Carrière", color: "#d8b4fe", tab: .home)
                quickAction(icon: "flame.fill", label: "Sport", color: "#fdba74", tab: .home)
            }
            .padding(.horizontal, 4)
        }
    }

    private func quickAction(icon: String, label: String, color: String, tab: AppTab) -> some View {
        Button {
            HapticFeedback.tap()
            router.selectedTab = tab
        } label: {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .frame(width: 48, height: 48)
                    .background(Color(hex: color))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color(hex: "#0a0a0a"), lineWidth: 2)
                    )
                    .shadow(color: .black, radius: 0, x: 2, y: 2)

                Text(label)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(Color(hex: "#0a0a0a"))
            }
        }
    }

    // MARK: - Bento Grid
    private var bentoGrid: some View {
        VStack(spacing: 14) {
            // Finance card (large)
            financeBentoCard

            HStack(spacing: 14) {
                scheduleBentoCard
                sportBentoCard
            }

            HStack(spacing: 14) {
                studiesBentoCard
                socialBentoCard
            }
        }
    }

    // MARK: - Finance Bento Card
    private var financeBentoCard: some View {
        Button {
            HapticFeedback.tap()
            router.selectedTab = .finance
        } label: {
            VStack(spacing: 0) {
                // Header
                HStack {
                    HStack(spacing: 10) {
                        Image(systemName: "banknote.fill")
                            .font(.system(size: 16))
                            .frame(width: 36, height: 36)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                            .shadow(color: .black, radius: 0, x: 2, y: 2)

                        VStack(alignment: .leading, spacing: 1) {
                            Text("Finance")
                                .font(.system(size: 16, weight: .heavy))
                            Text("Budget du mois")
                                .font(.system(size: 11, weight: .medium))
                                .opacity(0.6)
                        }
                    }
                    Spacer()
                    Image(systemName: "arrow.right")
                        .font(.system(size: 14, weight: .bold))
                        .opacity(0.4)
                }
                .padding(16)
                .background(Color(hex: "#86efac"))

                // Content
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "arrow.up.right")
                                .foregroundStyle(.green)
                                .font(.system(size: 12))
                            Text("Revenus")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text("+1 097,00 €")
                                .font(.system(size: 12, weight: .heavy))
                                .foregroundStyle(.green)
                        }
                        HStack {
                            Image(systemName: "arrow.down.right")
                                .foregroundStyle(.red)
                                .font(.system(size: 12))
                            Text("Dépenses")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text("-946,28 €")
                                .font(.system(size: 12, weight: .heavy))
                                .foregroundStyle(.red)
                        }

                        Divider()

                        HStack {
                            Text("Reste à vivre")
                                .font(.system(size: 13, weight: .bold))
                            Spacer()
                            Text("253,72 €")
                                .font(.system(size: 18, weight: .heavy))
                                .foregroundStyle(.green)
                        }
                    }
                    .frame(maxWidth: .infinity)

                    // Progress Ring
                    ZStack {
                        ProgressRing(
                            progress: Double(viewModel.budgetUsedPercent) / 100.0,
                            lineWidth: 8,
                            size: 80,
                            foregroundColor: Color(hex: "#4ade80")
                        )
                        VStack(spacing: 1) {
                            Text("\(viewModel.budgetUsedPercent)%")
                                .font(.system(size: 16, weight: .heavy))
                            Text("utilisé")
                                .font(.system(size: 8, weight: .bold))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(16)
                .background(Color.white)
            }
            .foregroundStyle(Color(hex: "#0a0a0a"))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color(hex: "#0a0a0a"), lineWidth: 2)
            )
            .shadow(color: .black, radius: 0, x: 4, y: 4)
        }
    }

    // MARK: - Schedule Bento Card
    private var scheduleBentoCard: some View {
        Button {
            HapticFeedback.tap()
            router.selectedTab = .schedule
        } label: {
            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    Image(systemName: "calendar")
                        .font(.system(size: 14))
                        .frame(width: 30, height: 30)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(.black, lineWidth: 2))
                        .shadow(color: .black, radius: 0, x: 1, y: 1)
                    Text("Planning")
                        .font(.system(size: 14, weight: .heavy))
                    Spacer()
                }
                .padding(12)
                .background(Color(hex: "#fdba74"))

                VStack(alignment: .leading, spacing: 6) {
                    ForEach(Array(viewModel.todayCourses.enumerated()), id: \.offset) { _, course in
                        HStack(spacing: 8) {
                            Circle()
                                .fill(course.isActive ? Color(hex: "#fdba74") : Color.gray.opacity(0.3))
                                .frame(width: 8, height: 8)
                            VStack(alignment: .leading, spacing: 1) {
                                Text(course.time)
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundStyle(.secondary)
                                Text(course.name)
                                    .font(.system(size: 11, weight: course.isActive ? .heavy : .medium))
                                    .opacity(course.isActive ? 1 : 0.5)
                            }
                        }
                    }
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
            }
            .foregroundStyle(Color(hex: "#0a0a0a"))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(hex: "#0a0a0a"), lineWidth: 2))
            .shadow(color: .black, radius: 0, x: 3, y: 3)
        }
    }

    // MARK: - Sport Bento Card
    private var sportBentoCard: some View {
        Button {
            HapticFeedback.tap()
        } label: {
            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    Image(systemName: "dumbbell.fill")
                        .font(.system(size: 14))
                        .frame(width: 30, height: 30)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(.black, lineWidth: 2))
                        .shadow(color: .black, radius: 0, x: 1, y: 1)
                    Text("Sport")
                        .font(.system(size: 14, weight: .heavy))
                    Spacer()
                }
                .padding(12)
                .background(Color(hex: "#fdba74"))

                VStack(spacing: 10) {
                    ZStack {
                        ProgressRing(
                            progress: 0.75,
                            lineWidth: 6,
                            size: 60,
                            foregroundColor: Color(hex: "#fb923c")
                        )
                        VStack(spacing: 0) {
                            Text("3/4")
                                .font(.system(size: 14, weight: .heavy))
                            Text("séances")
                                .font(.system(size: 7, weight: .bold))
                                .foregroundStyle(.secondary)
                        }
                    }

                    Text("75% objectif hebdo")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.secondary)
                }
                .padding(12)
                .frame(maxWidth: .infinity)
                .background(Color.white)
            }
            .foregroundStyle(Color(hex: "#0a0a0a"))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(hex: "#0a0a0a"), lineWidth: 2))
            .shadow(color: .black, radius: 0, x: 3, y: 3)
        }
    }

    // MARK: - Studies Bento Card
    private var studiesBentoCard: some View {
        Button {
            HapticFeedback.tap()
            router.selectedTab = .studies
        } label: {
            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    Image(systemName: "graduationcap.fill")
                        .font(.system(size: 14))
                        .frame(width: 30, height: 30)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(.black, lineWidth: 2))
                        .shadow(color: .black, radius: 0, x: 1, y: 1)
                    Text("Études")
                        .font(.system(size: 14, weight: .heavy))
                    Spacer()
                }
                .padding(12)
                .background(Color(hex: "#d8b4fe"))

                HStack(spacing: 8) {
                    VStack {
                        Text("6").font(.system(size: 20, weight: .heavy))
                        Text("Cours").font(.system(size: 9, weight: .bold)).foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color(hex: "#d8b4fe").opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(hex: "#0a0a0a"), lineWidth: 1.5))

                    VStack {
                        Text("24").font(.system(size: 20, weight: .heavy))
                        Text("Notes").font(.system(size: 9, weight: .bold)).foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color(hex: "#d8b4fe").opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(hex: "#0a0a0a"), lineWidth: 1.5))
                }
                .padding(12)
                .background(Color.white)
            }
            .foregroundStyle(Color(hex: "#0a0a0a"))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(hex: "#0a0a0a"), lineWidth: 2))
            .shadow(color: .black, radius: 0, x: 3, y: 3)
        }
    }

    // MARK: - Social Bento Card
    private var socialBentoCard: some View {
        Button {
            HapticFeedback.tap()
        } label: {
            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    Image(systemName: "person.2.fill")
                        .font(.system(size: 14))
                        .frame(width: 30, height: 30)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(.black, lineWidth: 2))
                        .shadow(color: .black, radius: 0, x: 1, y: 1)
                    Text("Social")
                        .font(.system(size: 14, weight: .heavy))
                    Spacer()
                }
                .padding(12)
                .background(Color(hex: "#f9a8d4"))

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("3").font(.system(size: 20, weight: .heavy))
                            Text("Événements").font(.system(size: 9, weight: .bold)).foregroundStyle(.secondary)
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("4").font(.system(size: 20, weight: .heavy))
                            Text("Cercles").font(.system(size: 9, weight: .bold)).foregroundStyle(.secondary)
                        }
                    }

                    HStack(spacing: -6) {
                        ForEach(0..<5, id: \.self) { i in
                            Circle()
                                .fill(Color(hex: ["#86efac", "#d8b4fe", "#f9a8d4", "#fdba74", "#86efac"][i]))
                                .frame(width: 24, height: 24)
                                .overlay(
                                    Text(String(Character(UnicodeScalar(65 + i)!)))
                                        .font(.system(size: 9, weight: .heavy))
                                )
                                .overlay(Circle().stroke(Color.white, lineWidth: 1.5))
                        }
                        Text("+23")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundStyle(.secondary)
                            .padding(.leading, 8)
                    }
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
            }
            .foregroundStyle(Color(hex: "#0a0a0a"))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(hex: "#0a0a0a"), lineWidth: 2))
            .shadow(color: .black, radius: 0, x: 3, y: 3)
        }
    }

    // MARK: - AI Tip Card
    private var aiTipCard: some View {
        HStack(alignment: .top, spacing: 14) {
            LinearGradient(
                colors: [Color(hex: "#86efac"), Color(hex: "#d8b4fe"), Color(hex: "#f9a8d4")],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(width: 4)
            .clipShape(Capsule())

            Image(systemName: "sparkles")
                .font(.system(size: 18))
                .frame(width: 36, height: 36)
                .background(
                    LinearGradient(
                        colors: [Color(hex: "#86efac"), Color(hex: "#d8b4fe")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(hex: "#0a0a0a"), lineWidth: 1.5)
                )
                .shadow(color: .black, radius: 0, x: 2, y: 2)

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Text("Conseil IA du jour")
                        .font(.system(size: 13, weight: .heavy))
                    Text("IA")
                        .font(.system(size: 8, weight: .bold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color(hex: "#86efac").opacity(0.3))
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(Color(hex: "#0a0a0a"), lineWidth: 1))
                }

                if viewModel.aiLoading {
                    HStack(spacing: 6) {
                        ProgressView()
                            .scaleEffect(0.7)
                        Text("L'IA analyse ta situation...")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.secondary)
                    }
                } else {
                    Text(viewModel.aiSuggestion ?? "")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.secondary)
                        .lineSpacing(3)
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(hex: "#0a0a0a"), lineWidth: 2)
        )
        .shadow(color: .black, radius: 0, x: 4, y: 4)
    }
}

// MARK: - Flow Layout (for stat pills)

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = layout(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = layout(proposal: proposal, subviews: subviews)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x,
                                       y: bounds.minY + result.positions[index].y),
                          proposal: .unspecified)
        }
    }

    private func layout(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
        }

        return (CGSize(width: maxWidth, height: y + rowHeight), positions)
    }
}

#Preview {
    DashboardView()
        .environment(AppRouter())
}
