import Foundation

typealias Limit = Int
typealias Offset = Int
typealias OrderId = String
typealias Token = String

enum Method {
    case GET(Path)
    case POST(String, String)

    func request() -> URLRequest {
        switch self {
        case .GET(let .orders(token, _, _)):
            var request = URLRequest(url: url())
            request.httpMethod = "GET"
            request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")
            return request

        case .GET(let .order(token, _)):
            var request = URLRequest(url: url())
            request.httpMethod = "GET"
            request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")
            return request

        case .POST(let username, let password):
            var request = URLRequest(url: url())
            request.httpMethod = "POST"
            let body = "client_id=APP-H1DR0RPHV7SP&client_secret=05acb6e128bc48b2999582cd9a2b9787&" +
                "grant_type=password&username=\(username)&password=\(password)&device_id=111111&scope=APP_ADMIN"
            request.httpBody = body.data(using: String.Encoding.utf8)
            return request
        }
    }

    private func url() -> URL {
        switch self {
        case .GET(let .orders(_, limit, offset)):
            return URL(string: "https://sandbox.moip.com.br/v2/orders?limit=\(limit)&offset=\(offset)")!
        case .GET(let .order(_, order)):
            return URL(string: "https://sandbox.moip.com.br/v2/orders/\(order)")!
        case .POST:
            return URL(string: "https://connect-sandbox.moip.com.br/oauth/token")!
        }
    }
}

enum Path {
    case orders(Token, Limit, Offset)
    case order(Token, OrderId)
}
