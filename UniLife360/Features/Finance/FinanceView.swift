import SwiftUI

struct FinanceView: View {
    @State private var viewModel = FinanceViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // MARK: - Header
                ModuleHeader(
                    title: "Finance",
                    subtitle: "Ton tableau de bord financier intelligent",
                    icon: "banknote.fill",
                    color: Color(hex: "#86efac")
                )

                // MARK: - Action Buttons
                HStack(spacing: 10) {
                    Button {
                        HapticFeedback.tap()
                        // Scanner receipt
                    } label: {
                        Label("Scanner", systemImage: "camera.fill")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(Color(hex: "#0a0a0a"))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(hex: "#0a0a0a"), lineWidth: 2))
                            .shadow(color: .black, radius: 0, x: 2, y: 2)
                    }

                    Spacer()

                    Button {
                        HapticFeedback.tap()
                        viewModel.showNewTransaction = true
                    } label: {
                        Label("Ajouter", systemImage: "plus")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(Color(hex: "#0a0a0a"))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color(hex: "#86efac"))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(hex: "#0a0a0a"), lineWidth: 2))
                            .shadow(color: .black, radius: 0, x: 2, y: 2)
                    }
                }

                // MARK: - Budget Overview Card
                budgetCard

                // MARK: - Revenue / Expenses Summary
                HStack(spacing: 12) {
                    statCard(title: "Revenus du mois", amount: viewModel.totalIncome, icon: "arrow.up.right", color: "#86efac", isPositive: true)
                    statCard(title: "Dépenses totales", amount: viewModel.totalExpenses, icon: "arrow.down.right", color: "#fca5a5", isPositive: false)
                }

                // MARK: - Category Breakdown
                if !viewModel.expensesByCategory.isEmpty {
                    categoryBreakdown
                }

                // MARK: - Transactions List
                transactionsList
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 100)
        }
        .background(Color(hex: "#fefce8"))
        .task {
            await viewModel.loadData()
        }
        .sheet(isPresented: $viewModel.showNewTransaction) {
            NewTransactionView(viewModel: viewModel)
        }
    }

    // MARK: - Budget Card
    private var budgetCard: some View {
        VStack(spacing: 16) {
            HStack {
                ProgressRing(
                    progress: Double(viewModel.budgetUsedPercent) / 100.0,
                    lineWidth: 12,
                    size: 140,
                    color: Color(hex: "#4ade80")
                ) {
                    VStack(spacing: 2) {
                        Text("Dépensé")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(.secondary)
                        Text("\(viewModel.budgetUsedPercent)%")
                            .font(.system(size: 28, weight: .heavy))
                        Text(viewModel.totalExpenses.formatted(.currency(code: "EUR")))
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 8) {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Budget")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(.secondary)
                        Text("\(viewModel.monthlyBudget.formatted(.currency(code: "EUR")))/mois")
                            .font(.system(size: 16, weight: .heavy))
                    }

                    VStack(alignment: .trailing, spacing: 2) {
                        Text(viewModel.remainingBudget >= 0 ? "Restants" : "Dépassement")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(.secondary)
                        Text(viewModel.remainingBudget.formatted(.currency(code: "EUR")))
                            .font(.system(size: 18, weight: .heavy))
                            .foregroundStyle(viewModel.remainingBudget >= 0 ? Color(hex: "#16a34a") : .red)
                    }
                }
            }
        }
        .padding(20)
        .background(Color(hex: "#86efac").opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(hex: "#0a0a0a"), lineWidth: 2))
        .shadow(color: .black, radius: 0, x: 4, y: 4)
    }

    // MARK: - Stat Card
    private func statCard(title: String, amount: Decimal, icon: String, color: String, isPositive: Bool) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(.secondary)
                Spacer()
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundStyle(isPositive ? Color(hex: "#16a34a") : .red)
            }

            Text(amount.formatted(.currency(code: "EUR")))
                .font(.system(size: 22, weight: .heavy))
                .foregroundStyle(isPositive ? Color(hex: "#16a34a") : .red)
        }
        .padding(16)
        .background(Color(hex: color).opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(hex: "#0a0a0a"), lineWidth: 2))
        .shadow(color: .black, radius: 0, x: 3, y: 3)
    }

    // MARK: - Category Breakdown
    private var categoryBreakdown: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Par catégorie")
                .font(.system(size: 16, weight: .heavy))

            ForEach(viewModel.expensesByCategory.prefix(5), id: \.category) { item in
                HStack(spacing: 12) {
                    Image(systemName: item.category.icon)
                        .font(.system(size: 14))
                        .frame(width: 36, height: 36)
                        .background(Color(hex: "#86efac").opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.category.label)
                            .font(.system(size: 13, weight: .bold))
                        GeometryReader { geo in
                            let width = viewModel.totalExpenses > 0
                                ? CGFloat(NSDecimalNumber(decimal: item.total / viewModel.totalExpenses).doubleValue) * geo.size.width
                                : 0
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color(hex: "#86efac"))
                                .frame(width: max(4, width), height: 6)
                        }
                        .frame(height: 6)
                    }

                    Spacer()

                    Text(item.total.formatted(.currency(code: "EUR")))
                        .font(.system(size: 13, weight: .heavy))
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(hex: "#0a0a0a"), lineWidth: 2))
        .shadow(color: .black, radius: 0, x: 4, y: 4)
    }

    // MARK: - Transactions List
    private var transactionsList: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Transactions")
                    .font(.system(size: 16, weight: .heavy))
                Spacer()
                Text("\(viewModel.filteredExpenses.count)")
                    .font(.system(size: 12, weight: .bold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(hex: "#0a0a0a"))
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
            }

            if viewModel.filteredExpenses.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "tray")
                        .font(.system(size: 32))
                        .foregroundStyle(.secondary)
                    Text("Aucune transaction")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.secondary)
                    Text("Ajoute ta première dépense")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 32)
            } else {
                ForEach(viewModel.filteredExpenses) { expense in
                    TransactionRow(expense: expense) {
                        Task { await viewModel.deleteTransaction(id: expense.id) }
                    }
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(hex: "#0a0a0a"), lineWidth: 2))
        .shadow(color: .black, radius: 0, x: 4, y: 4)
    }
}

#Preview {
    FinanceView()
}
