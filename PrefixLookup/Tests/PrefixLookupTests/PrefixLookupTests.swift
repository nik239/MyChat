import XCTest
@testable import PrefixLookup

final class PrefixLookupTests: XCTestCase {
  func test_loadFor() {
    //given
    let loader = PrefixLoader(for: ["cat", "caps", "captain", "cool", "crate", "crash"])
    //when
    var result = (try? loader.loadFor(prefix: "c")) ?? []
    //then
    XCTAssertEqual(Set(result),
                   Set(["cat", "caps", "captain", "cool", "crate", "crash"]))
    //when
    result = (try? loader.loadFor(prefix: "ca")) ?? []
    //then
    XCTAssertEqual(Set(result), Set(["cat", "caps", "captain"]))
    //when
    result = (try? loader.loadFor(prefix: "captain")) ?? []
    //then
    XCTAssertEqual(Set(result), Set(["captain"]))
  }
}
