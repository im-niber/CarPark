import Foundation

enum NetworkError: Error {
    case requestErr
    case pathErr
    case serverErr
    case networkFail
}
