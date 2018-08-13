import Foundation

protocol Request {
    static func makeRequest<T: Codable>(_ method: Method, onComplete: @escaping (Result<T>) -> Void)
}
