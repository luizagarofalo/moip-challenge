import Foundation
import SwiftKeychainWrapper

class NetworkRequest {
    private static let session = URLSession(configuration: .default)

    static func makeRequest<T: Codable>(_ method: Method, onComplete: @escaping (Result<T>) -> Void) {
        var request: URLRequest

        switch method {
        case .GET(let token, let order):
            var path = "https://sandbox.moip.com.br/v2/orders"
            
            if order != nil {
                path = path + "/\(String(describing: order))"
            }
            
            request = URLRequest(url: URL(string: path)!)
            request.httpMethod = "GET"
            request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")

        case .POST(let username, let password):
            let path = "https://connect-sandbox.moip.com.br/oauth/token"
            request = URLRequest(url: URL(string: path)!)
            request.httpMethod = "POST"

            let body = "client_id=APP-H1DR0RPHV7SP&" +
                "client_secret=05acb6e128bc48b2999582cd9a2b9787&" +
                "grant_type=password&" +
                "username=\(username)&" +
                "password=\(password)&" +
                "device_id=111111&" +
            "scope=APP_ADMIN"

            request.httpBody = body.data(using: String.Encoding.utf8)
        }

        self.session.dataTask(with: request)  { (data, response, error) in
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
