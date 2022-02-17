import XCTest
@testable import Control4

final class Control4Tests: XCTestCase {
    func testExample() async throws {
		try await Control4Controller(at: "192.168.2.46").rampValue(device: 72, variable: 1001, newValue: 0.0)
    }
}
