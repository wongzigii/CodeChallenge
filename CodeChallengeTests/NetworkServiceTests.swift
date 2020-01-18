@testable import CodeChallenge
import XCTest

class NetworkServiceTests: XCTestCase {

    var network: NetworkService?

    override func setUp() {
        super.setUp()
        network = NetworkService.shared
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_list_request() {
        let promise = expectation(description: "com.networkservice.test.list")
        network?.list { result in
            switch result {
            case let .success(envelope):
                XCTAssertTrue(envelope.success)
                XCTAssertTrue(envelope.error == nil)
                XCTAssertFalse(envelope.currencies.isEmpty)
                promise.fulfill()
            case let .failure(err):
                print("Err", err)
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }

    /// This testcase should be passed.
    func test_live_request_for_usd_source() {
        let source = "USD"
        let currencies: [String] = ["AED", "AFN", "ALL", "AMD", "ANG", "AOA", "ARS", "AUD"]
        let promise = expectation(description: "com.networkservice.test.live.usd")

        network?.live(source: source, currencies: currencies) { result in
            switch result {
            case let .success(envelope):
                XCTAssertTrue(envelope.success)
                XCTAssertTrue(envelope.error == nil)
                XCTAssertTrue(envelope.quotes != nil)
                XCTAssertFalse(envelope.quotes!.isEmpty)
                XCTAssertTrue(envelope.quotes?.count == currencies.count)
                promise.fulfill()
            case let .failure(err):
                print("Err", err)
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }

    /// This testcase should be passed too but result's success should be false because the current subscription of currencylayer dont support source currency switching.
    func test_live_request_for_other_source() {
        let source = "JPY"
        let currencies: [String] = ["AED", "AFN", "ALL", "AMD", "ANG", "AOA", "ARS", "AUD"]
        let promise = expectation(description: "com.networkservice.test.live.jpy")

        network?.live(source: source, currencies: currencies) { result in
            switch result {
            case let .success(envelope):
                XCTAssertFalse(envelope.success)
                XCTAssertTrue(envelope.error != nil)
                XCTAssertTrue(envelope.quotes == nil)
                promise.fulfill()
            case let .failure(err):
                print("Err", err)
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }

}
