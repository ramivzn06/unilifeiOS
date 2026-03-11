import XCTest
@testable import UniLife360

final class UniLife360Tests: XCTestCase {

    func testBudgetCalculation() {
        let viewModel = FinanceViewModel()
        // Default state should have zero expenses
        XCTAssertEqual(viewModel.totalExpenses, 0)
        XCTAssertEqual(viewModel.budgetUsedPercent, 0)
    }

    func testGreeting() {
        let viewModel = DashboardViewModel()
        let greeting = viewModel.greeting
        XCTAssertFalse(greeting.isEmpty)
    }

    func testFormattedDate() {
        let viewModel = DashboardViewModel()
        let date = viewModel.formattedDate
        XCTAssertFalse(date.isEmpty)
    }

    func testOnboardingSteps() {
        let viewModel = OnboardingViewModel()
        XCTAssertEqual(viewModel.currentStep, 0)
        XCTAssertEqual(viewModel.totalSteps, 4)
        XCTAssertFalse(viewModel.canProceed) // Empty fields
    }
}
