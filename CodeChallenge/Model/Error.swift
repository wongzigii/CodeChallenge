// Custom Error type
enum APPError: Error {
    case networkError(Error)
    case dataNotFound
    case jsonParsingError(Error)
    case invalidStatusCode(Int)
}

struct APIError: Decodable {
    var code: Int
    var info: String
}
