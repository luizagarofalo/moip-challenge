import Foundation

enum Method {
    case GET(Path)
    case POST(String, String)
}

enum Path {
    case orders(String, Int, Int)
    case order(String, String)
}
