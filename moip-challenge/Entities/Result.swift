import Foundation

enum Result<T> {
    case positive(T)
    case negative(Error)
}
