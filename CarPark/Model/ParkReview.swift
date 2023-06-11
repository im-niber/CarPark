import Foundation

struct ParkReviewStatus: Codable {
    let code: Int
    let message: String
    let reviews: [ParkReview]
}

struct ParkReview: Codable {
    let user_Name: String
    let review: String
    let date: String
    let park_Name: String
}

