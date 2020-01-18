@testable import CodeChallenge
import XCTest

class StorageTests: XCTestCase {

    // we don't need to mock userdefault anymore
    // https://twitter.com/johnsundell/status/855713943809032192
    private var userDefaults: UserDefaults!
    private var storage: Storage!

    override func setUp() {
        userDefaults = UserDefaults(suiteName: "userdefaults.extension.test")
        storage = Storage(def: userDefaults)

    }

    override func tearDown() {
        userDefaults.removePersistentDomain(forName: "userdefaults.extension.test")
    }

    func test_use_local_rate_at_the_beginning() {
        XCTAssertFalse(storage.uselocalRate)
    }

    func test_storage_save_selected_currency() {
        storage.saveSelectedCurrency(value: "USD")
        XCTAssertTrue(storage.getSelectedCurrency() == "USD")

        storage.saveSelectedCurrency(value: "JPY")
        XCTAssertTrue(storage.getSelectedCurrency() == "JPY")
    }

    func test_storage_save_live_exchange_rate() {

        let rates: [String: Float] = ["USDAED": 3.6732, "USDAFN": 76.90058, "USDALL": 109.92432, "USDAMD": 479.610165, "USDANG": 1.674968, "USDAOA": 489.387499, "USDARS": 60.002599, "USDAUD": 1.454198, "USDAWG": 1.8, "USDAZN": 1.700735, "USDBAM": 1.75994, "USDBBD": 2.019068]
        storage.presistLiveExchangeRate(rates: rates)
        XCTAssertTrue(storage.getLiveExchangeRate() == rates)
        // we can check `uselocalRate` is true as well
        XCTAssertTrue(storage.uselocalRate)
    }

    func test_storage_last_presist_date() {
        // save a date  eariler than 30 minus

        let oneHourAgo = Calendar.current.date(byAdding: .hour, value: -1, to: Date())
        storage.saveLastPresistDate(date: oneHourAgo!)

        // `uselocalRate` should be false now
        XCTAssertFalse(storage.uselocalRate)

    }
}
