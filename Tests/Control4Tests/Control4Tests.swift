import XCTest
@testable import Control4

final class Control4Tests: XCTestCase {
    func testExample() async throws {
//        try await Control4Controller(at: "192.168.2.46").getScenes()
        try await Control4Controller(at: "192.168.2.46").getScene(62)
    }
}
