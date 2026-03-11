import SwiftUI

enum TransactionType: String, Codable, CaseIterable {
    case income, expense
}

enum TransactionCategory: String, Codable, CaseIterable {
    // Income
    case salary, scholarship
    case financialAid = "financial_aid"
    case freelance, gift
    case otherIncome = "other_income"
    // Expense
    case rent, utilities, groceries, restaurants, transport
    case leisure, clothing, health, education, subscriptions
    case phone, insurance, savings
    case otherExpense = "other_expense"

    var label: String {
        switch self {
        case .salary: "Salaire"
        case .scholarship: "Bourse"
        case .financialAid: "Aide financière"
        case .freelance: "Freelance"
        case .gift: "Don/Cadeau"
        case .otherIncome: "Autre revenu"
        case .rent: "Loyer"
        case .utilities: "Charges"
        case .groceries: "Courses"
        case .restaurants: "Restaurants"
        case .transport: "Transport"
        case .leisure: "Loisirs"
        case .clothing: "Vêtements"
        case .health: "Santé"
        case .education: "Éducation"
        case .subscriptions: "Abonnements"
        case .phone: "Téléphone"
        case .insurance: "Assurance"
        case .savings: "Épargne"
        case .otherExpense: "Autre dépense"
        }
    }

    var icon: String {
        switch self {
        case .salary: "banknote.fill"
        case .scholarship: "graduationcap.fill"
        case .financialAid: "hand.raised.fill"
        case .freelance: "laptopcomputer"
        case .gift: "gift.fill"
        case .otherIncome: "plus.circle.fill"
        case .rent: "house.fill"
        case .utilities: "bolt.fill"
        case .groceries: "cart.fill"
        case .restaurants: "fork.knife"
        case .transport: "bus.fill"
        case .leisure: "gamecontroller.fill"
        case .clothing: "tshirt.fill"
        case .health: "heart.fill"
        case .education: "book.fill"
        case .subscriptions: "repeat"
        case .phone: "phone.fill"
        case .insurance: "shield.fill"
        case .savings: "banknote.fill"
        case .otherExpense: "ellipsis.circle.fill"
        }
    }

    var isIncome: Bool {
        switch self {
        case .salary, .scholarship, .financialAid, .freelance, .gift, .otherIncome: true
        default: false
        }
    }
}

enum RecurrenceType: String, Codable, CaseIterable {
    case none, weekly, biweekly, monthly, yearly
}
