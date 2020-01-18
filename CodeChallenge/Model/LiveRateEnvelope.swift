struct LiveRateEnvelope: Decodable {
    var success: Bool
    var timestamp: Int?
    var source: String?
    var quotes: [String: Float]?
    var error: APIError?
}
