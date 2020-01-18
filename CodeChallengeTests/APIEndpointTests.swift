@testable import CodeChallenge
import XCTest

class APIEndpointTests: XCTestCase {

    private let currencies: [String] = ["AED", "AFN", "ALL", "AMD", "ANG"]

    var network: NetworkService?

    override func setUp() {
        super.setUp()
        network = NetworkService.shared
    }

    func test_api_endpoint_path() {
        XCTAssert(APIEndPoint.list.path == "/api/list")
    }

    func test_currency_list_api_endpoint() {
        guard let url = URL(string: "http://apilayer.net/api/list?access_key=3e3d05e4d1ecb320126eb7cae197dc03") else {
            fatalError("URL can't be valid")
        }

        XCTAssert(url == APIEndPoint.list.requestURL)
    }

    func test_live_rate_api_endpoint() {

        let urlstr = "http://apilayer.net/api/live?source=USD&currencies=AED,AFN,ALL,AMD,ANG&access_key=3e3d05e4d1ecb320126eb7cae197dc03"

        let url = URL(string: urlstr)
        XCTAssert(url != nil)

        XCTAssert(currencies.joined(separator: ",") == "AED,AFN,ALL,AMD,ANG")

        let urlcomponent = URLComponents(string: urlstr)

        guard let requestURL = APIEndPoint.live(source: "USD", currencies: currencies).requestURL else { return }

        let expectedComponent = URLComponents(url: requestURL, resolvingAgainstBaseURL: false)
        XCTAssert(urlcomponent?.queryItems?.count == expectedComponent?.queryItems?.count)
        XCTAssert(url?.queryDictionary == requestURL.queryDictionary)
    }
}

extension URL {
    var queryDictionary: [String: String]? {
        guard let query = self.query else { return nil}

        var queryStrings = [String: String]()
        for pair in query.components(separatedBy: "&") {

            let key = pair.components(separatedBy: "=")[0]

            let value = pair
                .components(separatedBy: "=")[1]
                .replacingOccurrences(of: "+", with: " ")
                .removingPercentEncoding ?? ""

            queryStrings[key] = value
        }
        return queryStrings
    }
}
