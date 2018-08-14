import Foundation

protocol Gateway {
    static func makeRequest<T: Codable>(_ method: Method, onComplete: @escaping (Result<T>) -> Void)
}
