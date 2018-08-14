import Foundation

class NetworkRequest: Request {
    private static let session = URLSession(configuration: .default)
    static func makeRequest<T: Codable>(_ method: Method, onComplete: @escaping (Result<T>) -> Void) {
        self.session.dataTask(with: method.request()) { (data, response, error) in
            if let error = error {
                return onComplete(.negative(error))
            }
            guard let data = data else { return }

            do {
                let response = try JSONDecoder().decode(T.self, from: data)
                onComplete(.positive(response))
            } catch {
                onComplete(.negative(error))
            }
            }.resume()
    }
}
