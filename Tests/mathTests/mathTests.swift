import XCTest
@testable import OpenMath

final class mathTests: XCTestCase {
    func initTest() throws {
		let zero = Vec2()
		let one = Vec2(1)
		let two = one + Vec2(0, 1)
		let three = two * 3

		XCTAssertEqual(zero.array, [0, 0])
		XCTAssertEqual(one.array, [1, 1])
		XCTAssertEqual(two.array, [1, 2])
		XCTAssertEqual(three.array, [3, 6])
	}
}
