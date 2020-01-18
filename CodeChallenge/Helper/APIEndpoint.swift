import Foundation

/// API Endpoint of Currencylayer
/// https://currencylayer.com/documentation
enum APIEndPoint {
    // list available currencies
    case list
    // get live exchange based on source currency
    case live(source: String, currencies: [String])
    //
    case historical(date: String, source: String)
    //
    case convert(from: String, to: String, amount: Float)
    //
    case timeframe(start: String, end: String)
    //
    case change((String, String))

    private var baseURL: String {
        return "http://apilayer.net"
    }

    private var accessKey: String {
        return "3e3d05e4d1ecb320126eb7cae197dc03"
    }

    var path: String {
        let prefix = "/api"
        switch self {
        case .list:       return prefix + "/list"
        case .live:       return prefix + "/live"
        case .historical: return prefix + "/historical"
        case .convert:    return prefix + "/convert"
        case .timeframe:  return prefix + "/timeframe"
        case .change:     return prefix + "/change"
        }
    }

    var parameters: [String: Any] {
        var param: [String: Any] = [:]
        switch self {
        case let .live(source, array):
            param = ["source": source,
                     "currencies": array.joined(separator: ",")]
        case let .historical(date, source):
            param = ["date": date,
                     "source": source]
        case let .convert(from, to, amount):
            param = ["from": from,
                     "to": to,
                     "amount": amount]
        case let .timeframe(start, end):
            param = ["start": start,
                     "end": end]
        case let .change(tuple):
            param = ["currencies": tuple.0+","+tuple.1]
        default:
            param = [:]
        }
        return param
    }

    var requestURL: URL? {
        var components = URLComponents(url: URL(string: baseURL)!, resolvingAgainstBaseURL: true)
        components?.path = path
        var queryItems: [URLQueryItem] = parameters.map { tuple in
            URLQueryItem(name: tuple.0, value: String(describing: tuple.1))
        }
        queryItems.append(URLQueryItem(name: "access_key", value: accessKey))
        components?.queryItems = queryItems

        return components?.url
    }
}
