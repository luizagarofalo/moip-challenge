import Foundation

class NetworkRequest: Gateway {
    private static let session = URLSession(configuration: .default)
    static func makeRequest<T: Codable>(_ method: Method, onComplete: @escaping (Result<T>) -> Void) {
        self.session.dataTask(with: method.request()) { (data, response, error) in
            if let error = error {
                return onComplete(.failure(error))
            }

            guard let data = data else { return }

            do {
                let response = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    onComplete(.success(response))
                }
            } catch {
                DispatchQueue.main.async {
                    onComplete(.failure(error))
                }
            }
            }.resume()
    }
}
