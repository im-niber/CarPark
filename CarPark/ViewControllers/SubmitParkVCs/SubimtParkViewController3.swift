import UIKit

final class SubimtParkViewController3: BaseViewController {
    
    private let images: [UIImage]
    private let lat: Double
    private let lng: Double
    
    private lazy var mainStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fill
        view.spacing = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let dateLabel = UILabel()
    private let startDateLabel = UILabel()
    private let endDateLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    private lazy var datePickerContainerView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 30
        view.distribution = .fill
        
        return view
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let view = UIDatePicker()
        view.addTarget(self, action: #selector(changeDate), for: .valueChanged)
        
        return view
    }()
    
    private let datePicker2 = UIDatePicker()
    
    private lazy var descriptionTextView: UITextView = {
        let view = UITextView()
        view.font = .systemFont(ofSize: 14, weight: .medium)
        view.delegate = self
        view.isScrollEnabled = false
        
        view.textAlignment = .justified
        view.spellCheckingType = .no
        
        view.textContainerInset = .init(top: 5, left: 4, bottom: 5, right: 4)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.95).isActive = true
        
        view.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.borderWidth = 1.5
        
        view.setContentHuggingPriority(UILayoutPriority(100), for: .vertical)
        
        return view
    }()
    
    private lazy var submitBtn: UIButton = {
        let view = UIButton(configuration: .filled())
        
        view.setTitle("등록", for: .normal)
        view.setTitleColor(.white, for: .selected)
        view.setTitleColor(.gray, for: .normal)
        view.addTarget(self, action: #selector(submitPark), for: .touchUpInside)
        view.tintColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    init(images: [UIImage], lat: Double, lng: Double) {
        self.images = images
        self.lat = lat
        self.lng = lng
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setDefaultComponent()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setDefaultComponent() {
        [dateLabel, descriptionLabel, startDateLabel, endDateLabel].forEach {
            $0.font = .systemFont(ofSize: 14, weight: .regular)
            $0.textColor = .darkGray
        }
    }
    
    override func configureHierarchy() {
        view.addSubview(mainStackView)
        view.addSubview(submitBtn)
        
        let datePickerContainerView2 = UIStackView()
        datePickerContainerView2.axis = .horizontal
        datePickerContainerView2.spacing = 30
        datePickerContainerView2.distribution = .fill
        
        datePickerContainerView.addArrangedSubview(startDateLabel)
        datePickerContainerView.addArrangedSubview(datePicker)
        
        datePickerContainerView2.addArrangedSubview(endDateLabel)
        datePickerContainerView2.addArrangedSubview(datePicker2)
        
        [dateLabel, datePickerContainerView, datePickerContainerView2, descriptionLabel, descriptionTextView].forEach { mainStackView.addArrangedSubview($0) }
    }
    
    override func configureConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -350),
            
            submitBtn.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 32),
            submitBtn.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            submitBtn.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor)
        ])
    }
    
    private func configure() {
        dateLabel.text = "이용 가능 시간을 알려주세요"
        descriptionLabel.text = "주차장의 특징과 금액을 알려주세요"
        
        var dateComponent = DateComponents()
        dateComponent.day = 0
        
        let minDate = Calendar.autoupdatingCurrent.date(byAdding: dateComponent, to: Date())
        
        datePicker.minimumDate = minDate
        startDateLabel.text = "시작 시간"
        endDateLabel.text = "종료 시간"
    }
    
    @objc func changeDate() {
        var dateComponent = DateComponents()
        dateComponent.day = 0
        let minDate = Calendar.autoupdatingCurrent.date(byAdding: dateComponent, to: datePicker.date)
        
        datePicker2.minimumDate = minDate
    }
    
    @objc func submitPark() {
        let nickName = UserDefault.shared.getNickname()
        let userPark = UserPark(userNickname: nickName, description: descriptionTextView.text ?? "", lat: self.lat, lng: self.lng, startTime: datePicker.date.toString(type: .monthAndDayAndHourAndMinute), endTime: datePicker2.date.toString(type: .monthAndDayAndHourAndMinute))
        
        _ = navigationController?.viewControllers.first(where: { vc in
            guard let vc = vc as? ViewController else { return false }
            let newMarker = ParkMarker(userPark: userPark, vc)
            newMarker.setTouchEvent(vc: vc, data: userPark, images: self.images)
            vc.appendParkMarker(marker: newMarker)
            self.navigationController?.popToViewController(vc, animated: true)
            
            return true
        })
    }
}

extension SubimtParkViewController3: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.count != 0 {
            submitBtn.isSelected = true
        }
    }
}
