import Foundation

enum NetworkError: String, Error {
    case requestErr
    case pathErr
    case serverErr
    case networkFail
}
