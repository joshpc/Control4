import XCTest
@testable import Control4

final class Control4Tests: XCTestCase {
    private let controller = Control4Controller(at: "")
    
    func testGetScenes() async throws {
        let scenes = try await self.controller.getScenes()
        assert(scenes.count > 0)
    }
    
    func testGetSecondFloorHallway() async throws {
        try await self.controller.getScene(62)
    }
    
    func testTurnSecondFloorHallwayOn() async throws {
        try await self.controller.activateScene(62)
    }
    
    func testTurnSecondFloorHallwayOff() async throws {
        try await self.controller.deactivateScene(62)
    }
}
