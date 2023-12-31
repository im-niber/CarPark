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
        UserDefault.shared.checkFavorite(with: self.marker.park)
    }
    
    func tappedFavoriteAction() {
        UserDefault.shared.setFavoriteParks(item: self.marker.park)
    }
    
    func getDriving() {
        delegate?.getDriving(goalLng: marker.park.xCdnt, goalLat: marker.park.yCdnt, goalLocation: marker.park.pkNam, marker: marker)
    }
    
    func postReview(with review: String) {
        let parameter: [String: Any] = [
            "user_Name" : UserDefault.shared.getNickname(),
            "review" : review,
            "park_Name" : self.marker.park.pkNam
        ]

        NetworkManager.shared.request(with: APIConstants.saveReviewURL, method: .post, parameter: parameter) { result in
            switch result {
            case .success(_):
                self.fetchReview()
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    // MARK: 서버에서 리뷰를 가져오는 함수
    private func fetchReview() {
        let urlParkName = marker.park.pkNam.components(separatedBy: " ").joined()
        let encodeURL = (APIConstants.fetchReviewURL + urlParkName).encodeUrl()!
        
        NetworkManager.shared.request(with: encodeURL, method: .get, type: ParkReviewStatus.self) { result in
            switch result {
            case .success(let data):
                self.reviews = data.reviews
            case .failure(let error):
                print("\(error)")
            }
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
