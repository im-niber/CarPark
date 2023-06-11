import UIKit

protocol DrivingDelegate: AnyObject {
    func getDriving(goalLng: String, goalLat: String, goalLocation: String, marker: ParkMarker)
}

final class CarParkInfoViewController: UIViewController {
    
    private var reviews: [ParkReview]?
    private let marker: ParkMarker
    
    weak var delegate: DrivingDelegate?
    
    private var isKeyboardShowing = false
    
    @IBOutlet weak var pkNamLabel: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    @IBOutlet weak var pkGubunLabel: UILabel!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var pkCntLabel: UILabel!
    
    @IBOutlet weak var findWayBtn: UIButton!
    
    @IBOutlet weak var sectionStackView: UIStackView!
    
    @IBOutlet weak var InfoStackView: UIStackView!
    
    @IBOutlet weak var infoBtn: UIButton!
    @IBOutlet weak var selectInfoDivider: UIView!
    
    @IBOutlet weak var selectReviewDivider: UIView!
    @IBOutlet weak var reviewBtn: UIButton!
    
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var feeLabelData: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeLabelData: UILabel!
    
    @IBOutlet weak var dividerView2: UIView!
    
    @IBOutlet weak var doroAddrLabel: UILabel!
    @IBOutlet weak var tponNumLabel: UILabel!
    
    @IBOutlet weak var notiLabel: UILabel!
    
    @IBOutlet weak var reviewStackView: UIStackView!
    
    @IBOutlet weak var reviewTextField: UITextField!
    @IBOutlet weak var postReviewBtn: UIButton!
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    init?(marker: ParkMarker, coder: NSCoder) {
        self.marker = marker
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        reviewTextField.delegate = self
        fetchReview()
        setUpTableView()
        setData(with: marker.data)
        checkFavorite()
        addKeyboardNotification()
    }

    private func setUpTableView() {
        view.addSubview(tableView)
        
        tableView.register(ParkReviewCell.self, forCellReuseIdentifier: ParkReviewCell.identifier)
        
        tableView.rowHeight = UITableView.automaticDimension
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: sectionStackView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: reviewStackView.topAnchor),
        ])
    }
    
    private func setData(with item: Item) {
        self.pkNamLabel.text = item.pkNam
        self.pkGubunLabel.text = item.pkGubun
        self.pkCntLabel.text = item.pkCnt + " 면"
        self.feeLabelData.text = "기본요금 \(item.tenMin)원\n  1일 \(item.ftDay)원\n 월 정기권 \(item.ftMon)원"
        self.timeLabelData.text = "평일 \(item.svcSrtTe) ~ \(item.svcEndTe)\n 토요일 \(item.satSrtTe) ~ \(item.satEndTe)\n 공휴일 \(item.hldSrtTe) ~ \(item.hldEndTe)"
        self.doroAddrLabel.text = "📍 \(item.doroAddr)"
        self.tponNumLabel.text = "📞 \(item.tponNum)"
    }
    
    private func checkFavorite() {
        favoriteBtn.isSelected = UserDefault.shared.checkFavorite(with: self.marker.data)
    }
    
    @IBAction func tappedFavoriteAction(_ sender: Any) {
        UserDefault.shared.setFavoriteParks(item: self.marker.data)
        checkFavorite()
    }
    
    // MARK: 서버에서 리뷰를 가져오는 함수
    private func fetchReview() {
        let urlParkName = marker.data.pkNam.components(separatedBy: " ").joined()
        let encodeURL = (APIConstants.fetchReviewURL + urlParkName).encodeUrl()!

        NetworkManager.shared.fetch(with: encodeURL, type: ParkReviewStatus.self) { reviewData in
            self.reviews = reviewData.reviews

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    // MARK: 리뷰 작성 로직
    @IBAction func postReview(_ sender: Any) {
        let parameter: [String : Any] = [
            "user_Name" : UserDefault.shared.getNickname(),
            "review" : reviewTextField.text!,
            "park_Name" : marker.data.pkNam
        ]
        
        NetworkManager.shared.push(with: APIConstants.saveReviewURL, parameter: parameter) { result in
            guard result == .success else {
                print("review error")
                return
            }
            self.fetchReview()
        }
        reviewTextField.text = ""
    }
    
    // MARK: 길찾기
    @IBAction func findWayAction(_ sender: Any) {
        delegate?.getDriving(goalLng: marker.data.xCdnt, goalLat: marker.data.yCdnt, goalLocation: marker.data.pkNam, marker: marker)
        self.dismiss(animated: true)
    }
    
    @IBAction func infoBtnAction(_ sender: Any) {
        showInfoSection(true)
    }
    
    @IBAction func reviewBtnAction(_ sender: Any) {
        showInfoSection(false)
    }
    
    private func showInfoSection(_ bool: Bool) {
        infoBtn.isHighlighted = !bool
        reviewBtn.isHighlighted = bool
        selectInfoDivider.isHidden = !bool
        selectReviewDivider.isHidden = bool
        InfoStackView.isHidden = !bool
        tableView.isHidden = bool
        reviewStackView.isHidden = bool
    }
    
    private func addKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if isKeyboardShowing { return }
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            isKeyboardShowing = true
            
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            let frame = self.view.frame
            let keyboardShowheight = frame.height - keyboardHeight
            UIView.animate(withDuration: 1) {
                self.view.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: keyboardShowheight)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if !isKeyboardShowing { return }
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            let frame = self.view.frame
            UIView.animate(withDuration: 1) {
                self.view.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height + keyboardHeight)
            }
            isKeyboardShowing = false
        }
    }
}

extension CarParkInfoViewController: UITableViewDataSource {
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

extension CarParkInfoViewController: UITableViewDelegate { }

extension CarParkInfoViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text != "" {
            postReviewBtn.isSelected = true
        } else {
            postReviewBtn.isSelected = false
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != "" {
            postReviewBtn.isSelected = true
        } else {
            postReviewBtn.isSelected = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
