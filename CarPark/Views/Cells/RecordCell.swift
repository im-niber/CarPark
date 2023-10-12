import UIKit

final class RecordCell: UICollectionViewCell {
    
    private lazy var recordStackView: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .white
        view.axis = .vertical
        view.spacing = 30
        view.layer.cornerRadius = 10
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = .init(top: 5, left: 16, bottom: 5, right: 16)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var title: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.font = .systemFont(ofSize: 20, weight: .semibold)
        
        return view
    }()
    
    private lazy var date: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.textColor = .black
        view.font = .systemFont(ofSize: 15, weight: .medium)
        
        return view
    }()
    
    private(set) lazy var time: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = .systemFont(ofSize: 15, weight: .medium)
        
        return view
    }()
    
    private lazy var charge: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.font = .systemFont(ofSize: 17, weight: .semibold)
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray6
        configureHierarchy()
        customSpacing()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        title.text = ""
        time.text = ""
        date.text = ""
        charge.text = ""
    }
    
    func customSpacing() {
        recordStackView.setCustomSpacing(5, after: title)
    }
    
    func configureHierarchy() {
        contentView.addSubview(recordStackView)
        [title, date, time, charge].forEach { recordStackView.addArrangedSubview($0) }
    }

    func configureConstraints() {
        NSLayoutConstraint.activate([
            recordStackView.topAnchor.constraint(equalTo: topAnchor),
            recordStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            recordStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            recordStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(with data: Record) {
        var data = data
        if data.category == "주차장" {
            data.title = "🅿️ " + data.title
        }
        title.text = data.title
        date.text = "이용한 날짜: " + data.date
        time.text = "이용한 시간: " + data.time
        charge.text = "이용 금액: " + data.charge + " 원"
    }
}
