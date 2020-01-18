struct CurrencyEnvelope: Decodable {

    typealias Currency = [String: String]

    var success: Bool
    var currencies: Currency
    var terms: String
    var privacy: String
    var error: APIError?

    enum CodingKeys: String, CodingKey {
        case success = "success"
        case terms = "terms"
        case privacy = "privacy"
        case currencies
    }
}
