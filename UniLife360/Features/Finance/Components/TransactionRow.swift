import SwiftUI

struct TransactionRow: View {
    let expense: Expense
    var onDelete: (() -> Void)?

    var body: some View {
        HStack(spacing: 12) {
            // Category icon
            Image(systemName: expense.category.icon)
                .font(.system(size: 16))
                .frame(width: 40, height: 40)
                .background(
                    expense.transactionType == .income
                        ? Color(hex: "#86efac").opacity(0.2)
                        : Color(hex: "#fca5a5").opacity(0.2)
                )
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(hex: "#0a0a0a"), lineWidth: 1.5)
                )

            // Details
            VStack(alignment: .leading, spacing: 3) {
                Text(expense.description ?? expense.category.label)
                    .font(.system(size: 14, weight: .bold))
                    .lineLimit(1)

                HStack(spacing: 6) {
                    Text(expense.category.label)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(.secondary)

                    if let merchant = expense.merchantName {
                        Text("· \(merchant)")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
            }

            Spacer()

            // Amount + Date
            VStack(alignment: .trailing, spacing: 3) {
                Text(expense.transactionType == .income ? "+\(expense.amount.formatted())" : "-\(expense.amount.formatted())")
                    .font(.system(size: 14, weight: .heavy))
                    .foregroundStyle(expense.transactionType == .income ? Color(hex: "#16a34a") : .red)

                Text(expense.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 8)
        .swipeActions(edge: .trailing) {
            if let onDelete {
                Button(role: .destructive) {
                    onDelete()
                } label: {
                    Label("Supprimer", systemImage: "trash")
                }
            }
        }
    }
}
