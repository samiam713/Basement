import XCTest
@testable import Basement

final class BasementTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let x = Neuron()
        let y = Neuron()

        // let network = NeuralNetwork()

        // network.create(neuron: x)
        XCTAssertEqual(x,x)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
