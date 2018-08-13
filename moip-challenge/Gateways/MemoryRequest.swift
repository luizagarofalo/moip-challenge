import Foundation

class MemoryRequest: Request {
    static func makeRequest<T: Codable>(_ method: Method, onComplete: @escaping (Result<T>) -> Void) {
        if let path = Bundle.main.path(forResource: "Orders", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let response = try JSONDecoder().decode(T.self, from: data)
                onComplete(.positive(response))
            } catch {
                onComplete(.negative(error))
            }
        }
    }
}