import Foundation

enum HTTPStatusCode: Int, Codable {
    case ok = 200
    case forbidden = 403
    case notFound = 404
}
