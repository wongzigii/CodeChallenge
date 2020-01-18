import Foundation

class Storage {

    init(def: UserDefaults) {
        self.defaults = def
    }

    static let shared = Storage(def: .standard)

    private (set) var defaults: UserDefaults
    
    // The source last time presisted
    var lastPresistSource: String {
        #if DEBUG
        // The current subscription of currencylayer doesnot support source currency switching
        return "USD"
        #else
        return getSelectedCurrency()
        #endif
        
    }
    
    // presisted rates
    var rates: [String: Float] {
        return getLiveExchangeRate()
    }

    // We stored a value lastPresistDate for future comparion
    var lastPresistDate: Date? {
        return defaults.value(forKey: Storage.LAST_PRESIST_DATE_KEY) as? Date
    }

    // Should we use the local presist rate or fetch it by network?
    var uselocalRate: Bool {
         if let date = lastPresistDate, !isPassedMoreThan(minutes: 30, fromDate: date, toDate: Date()) {
            print("Has not passed more than 30 mins, using local rate.")
            return true
         } else {
            print("Fetch it again.")
            return false
        }
    }

    // Save last Presist Date
    func saveLastPresistDate(date: Date = Date()) {
        defaults.set(date, forKey: Storage.LAST_PRESIST_DATE_KEY)
    }

    // Save the selected currency
    func saveSelectedCurrency(value: String) {
        defaults.setValue(value, forKey: Storage.SELECTED_CURRENCY_KEY)
        _ = defaults.synchronize()
    }

    // Get the selected currency
    // - Parameter type: CurrencyButtonType
    func getSelectedCurrency() -> String {
        return defaults.string(forKey: Storage.SELECTED_CURRENCY_KEY) ?? "USD"
    }

    // Presist real-time exchange rates
    // - Parameter currencies: currencies list
    func presistLiveExchangeRate(rates: [String: Float]) {
        defaults.set(rates, forKey: Storage.LIVE_EXCHANGE_RATE_KEY)
        saveLastPresistDate()
        _ = defaults.synchronize()
    }

    //  Store the live exchange rate locally
    func  getLiveExchangeRate() -> [String: Float] {
        return defaults.value(forKey: Storage.LIVE_EXCHANGE_RATE_KEY) as? [String: Float] ?? [:]
    }

    // remove all data for unit testing
    func truncate() {
        let domain = Bundle.main.bundleIdentifier!
        defaults.removePersistentDomain(forName: domain)
        defaults.synchronize()
    }
}

private func isPassedMoreThan(minutes: Int, fromDate date: Date, toDate date2: Date) -> Bool {
    let deltaD = Calendar.current.dateComponents([.minute], from: date, to: date2).minute ?? 0
    return deltaD > minutes
}

extension Storage {

    static let SELECTED_CURRENCY_KEY = "selectedCurrency"

    static let LAST_PRESIST_DATE_KEY = "lastPresistDate"

    static let LIVE_EXCHANGE_RATE_KEY = "liveExchangeRate"
}
