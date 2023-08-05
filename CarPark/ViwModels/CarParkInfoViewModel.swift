import UIKit
import Combine

protocol DrivingDelegate: AnyObject {
    func getDriving(goalLng: String, goalLat: String, goalLocation: String, marker: ParkMarker)
}

final class CarParkInfoViewModel: NSObject, ObservableObject {
    @Published private(set) var reviews: [ParkReview]?
    
    let tempData: [ParkReview] = [ParkReview(user_Name: "gkgk", review: "review~", date: "2023-08-04", park_Name: "zz"),ParkReview(user_Name: "gkgk", review: "review~123", date: "2023-08-04", park_Name: "zz"),ParkReview(user_Name: "gkgk", review: "review~456", date: "2023-08-04", park_Name: "zz"),]
    
    let marker: ParkMarker
    
    weak var delegate: DrivingDelegate?
    
    init(marker: ParkMarker) {
        self.marker = marker
        super.init()
        viewDidLoad()
        
        // MARK: 데이터 바인딩 Test
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.reviews = self.tempData
        }
    }
    
    private func viewDidLoad() {
        fetchReview()
    }
    
    func checkFavorite() -> Bool {
        UserDefault.shared.checkFavorite(with: self.marker.data)
    }
    
    func tappedFavoriteAction() {
        UserDefault.shared.setFavoriteParks(item: self.marker.data)
    }
    
    func getDriving() {
        delegate?.getDriving(goalLng: marker.data.xCdnt, goalLat: marker.data.yCdnt, goalLocation: marker.data.pkNam, marker: marker)
    }
    
    func postReview(with review: String) {
        let parameter: [String: Any] = [
            "user_Name" : UserDefault.shared.getNickname(),
            "review" : review,
            "park_Name" : self.marker.data.pkNam
        ]

        NetworkManager.shared.push(with: APIConstants.saveReviewURL, parameter: parameter) { result in
            guard result == .success else {
                print("review error")
                return
            }
            self.fetchReview()
        }
    }
    
    // MARK: 서버에서 리뷰를 가져오는 함수
    private func fetchReview() {
        let urlParkName = marker.data.pkNam.components(separatedBy: " ").joined()
        let encodeURL = (APIConstants.fetchReviewURL + urlParkName).encodeUrl()!

        NetworkManager.shared.fetch(with: encodeURL, type: ParkReviewStatus.self) { reviewData in
            self.reviews = reviewData.reviews
        }
    }
}

// MARK: 테이블 뷰 관련
extension CarParkInfoViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reviews?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ParkReviewCell.identifier, for: indexPath) as? ParkReviewCell else { return UITableViewCell() }
        guard let reviews else { return UITableViewCell() }
        let review = reviews[indexPath.row]
        cell.configure(with: review)

        return cell
    }
}

extension CarParkInfoViewModel: UITableViewDelegate { }
