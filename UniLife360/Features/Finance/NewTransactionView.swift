import SwiftUI

struct NewTransactionView: View {
    @Bindable var viewModel: FinanceViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // MARK: - Type Toggle
                    HStack(spacing: 0) {
                        typeButton(type: .expense, label: "Dépense", icon: "arrow.down.circle.fill")
                        typeButton(type: .income, label: "Revenu", icon: "arrow.up.circle.fill")
                    }
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(hex: "#0a0a0a"), lineWidth: 2)
                    )

                    // MARK: - Amount
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Montant")
                            .font(.system(size: 13, weight: .bold))

                        HStack {
                            TextField("0.00", text: $viewModel.newAmount)
                                .keyboardType(.decimalPad)
                                .font(.system(size: 32, weight: .heavy))
                                .padding(16)

                            Text("€")
                                .font(.system(size: 24, weight: .heavy))
                                .foregroundStyle(.secondary)
                                .padding(.trailing, 16)
                        }
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(hex: "#0a0a0a"), lineWidth: 2)
                        )
                        .shadow(color: .black, radius: 0, x: 3, y: 3)
                    }

                    // MARK: - Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.system(size: 13, weight: .bold))

                        TextField("Ex: Courses au Delhaize", text: $viewModel.newDescription)
                            .padding(14)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(hex: "#0a0a0a"), lineWidth: 2)
                            )
                    }

                    // MARK: - Category
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Catégorie")
                            .font(.system(size: 13, weight: .bold))

                        let categories = viewModel.newType == .expense
                            ? TransactionCategory.allCases.filter { !$0.isIncome }
                            : TransactionCategory.allCases.filter { $0.isIncome }

                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 8)], spacing: 8) {
                            ForEach(categories, id: \.self) { category in
                                Button {
                                    HapticFeedback.tap()
                                    viewModel.newCategory = category
                                } label: {
                                    HStack(spacing: 6) {
                                        Image(systemName: category.icon)
                                            .font(.system(size: 12))
                                        Text(category.label)
                                            .font(.system(size: 11, weight: .bold))
                                            .lineLimit(1)
                                    }
                                    .foregroundStyle(viewModel.newCategory == category ? .white : Color(hex: "#0a0a0a"))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(viewModel.newCategory == category
                                                ? Color(hex: viewModel.newType == .income ? "#86efac" : "#fca5a5")
                                                : Color.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color(hex: "#0a0a0a"), lineWidth: 1.5)
                                    )
                                }
                            }
                        }
                    }

                    // MARK: - Date
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Date")
                            .font(.system(size: 13, weight: .bold))

                        DatePicker("", selection: $viewModel.newDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            .padding(14)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(hex: "#0a0a0a"), lineWidth: 2)
                            )
                    }

                    // MARK: - Save Button
                    Button {
                        HapticFeedback.tap()
                        Task { await viewModel.addTransaction() }
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Enregistrer")
                                .font(.system(size: 16, weight: .heavy))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            !viewModel.newAmount.isEmpty
                                ? Color(hex: "#0a0a0a")
                                : Color(hex: "#0a0a0a").opacity(0.3)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .black.opacity(0.3), radius: 0, x: 3, y: 3)
                    }
                    .disabled(viewModel.newAmount.isEmpty)
                }
                .padding(20)
            }
            .background(Color(hex: "#fefce8"))
            .navigationTitle("Nouvelle transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        dismiss()
                    }
                    .font(.system(size: 14, weight: .bold))
                }
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }

    private func typeButton(type: TransactionType, label: String, icon: String) -> some View {
        Button {
            HapticFeedback.tap()
            withAnimation(.easeInOut(duration: 0.2)) {
                viewModel.newType = type
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: icon)
                Text(label)
                    .font(.system(size: 14, weight: .bold))
            }
            .foregroundStyle(viewModel.newType == type ? .white : Color(hex: "#0a0a0a"))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                viewModel.newType == type
                    ? (type == .expense ? Color(hex: "#fca5a5") : Color(hex: "#86efac"))
                    : Color.clear
            )
        }
    }
}
