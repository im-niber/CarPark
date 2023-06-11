import UIKit

protocol DrivingActionDelegate: AnyObject {
    func didTapCancelButton()
}

final class DrivingView: UIView {
    
    weak var delegate: DrivingActionDelegate?
    private(set) var marker: ParkMarker?
    
    private lazy var verticalStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.spacing = 10
        stackview.alignment = .fill
        stackview.distribution = .fill
        stackview.translatesAutoresizingMaskIntoConstraints = false
        
        return stackview
    }()
    
    private lazy var goalStackView : UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.distribution = .fill
        stackview.spacing = 8
        stackview.translatesAutoresizingMaskIntoConstraints = false
        
        return stackview
    }()
    
    private lazy var goalLabel: UILabel = {
        let label = UILabel()
        label.text = "목적지"
        label.numberOfLines = 0
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var goalLocationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .left
        label.setContentHuggingPriority(.defaultLow - 1.0, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh - 1.0, for: .horizontal)
        
        return label
    }()
    
    private lazy var cancelDrivingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        
        return button
    }()
   
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 1
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        configureHirearchy()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHirearchy() {
        [goalLabel, goalLocationLabel, cancelDrivingButton].forEach { goalStackView.addArrangedSubview($0) }
        
        verticalStackView.addArrangedSubview(goalStackView)
        verticalStackView.addArrangedSubview(timeLabel)

        self.addSubview(verticalStackView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 32),
            verticalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            verticalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant:  -16),
            verticalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
        ])
        
    }
    
    func configure(to location: String, time: Int, marker: ParkMarker) {
        goalLocationLabel.text = location
        timeLabel.text = "도착 예상 시간은 \((time / 1000 / 60))분 입니다."
        self.marker = marker
    }
    
    @objc func cancelAction() {
        delegate?.didTapCancelButton()
        self.isHidden = true
    }
}
