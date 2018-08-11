import Foundation

enum Method {
    case GET(Request)
    case POST(String, String)
}

enum Request {
    case orders(String, Int, Int)
    case order(String, String)
}
