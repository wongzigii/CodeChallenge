import Foundation.NSURLSession

struct NetworkService {

    static let shared = NetworkService()

    private let session = URLSession.shared

    //core request function
    internal func dataRequest<T: Decodable>(with endpoint: APIEndPoint,
                                           objectType: T.Type,
                                           completion: @escaping (Result<T>) -> Void) {

        guard let url = endpoint.requestURL else { return }

        let task = session.dataTask(with: url) { data, _, err in
            guard err == nil else {
                completion(.failure(.networkError(err!)))
                return
            }

            guard let data = data else {
                completion(.failure(.dataNotFound))
                return
            }
            do {
                #if DEBUG
                let obj = NSString(data: data, encoding: String.Encoding.utf8.rawValue) ?? ""
                print(obj)
                #endif
                let decodeObject = try JSONDecoder().decode(objectType, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodeObject))
                }

            } catch let err {
                completion(.failure(.jsonParsingError(err)))
            }
        }
        task.resume()
    }
}

extension NetworkService: NetworkServiceType {

    func list(completion: @escaping (Result<CurrencyEnvelope>) -> Void) {
        dataRequest(with: .list, objectType: CurrencyEnvelope.self, completion: completion)
    }

    func live(source: String, currencies: [String], completion: @escaping (Result<LiveRateEnvelope>) -> Void) {
        dataRequest(with: .live(source: source, currencies: currencies), objectType: LiveRateEnvelope.self, completion: completion)
    }
}

protocol NetworkServiceType {

    func list(completion: @escaping (Result<CurrencyEnvelope>) -> Void)

    func live(source: String, currencies: [String], completion: @escaping (Result<LiveRateEnvelope>) -> Void)
}
