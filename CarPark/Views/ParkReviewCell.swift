import UIKit

final class ParkReviewCell: UITableViewCell {
    
    private lazy var id: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private(set) lazy var content: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var date: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        id.text = ""
        content.text = ""
        date.text = ""
    }
    
    func configureHierarchy() {
        [id, content, date].forEach { contentView.addSubview($0) }
    }

    func configureConstraints() {
        NSLayoutConstraint.activate([
            id.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            id.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            id.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            content.topAnchor.constraint(equalTo: id.bottomAnchor, constant: 16),
            content.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            content.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            content.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            date.topAnchor.constraint(equalTo: id.topAnchor),
            date.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
    
    func configure(with data: ParkReview) {
        id.text = data.user_Name
        content.text = data.review
        date.text = data.date.toDate(type: .timeStamp)?.toString(type: .yearAndMonthAndDate)
    }
}
