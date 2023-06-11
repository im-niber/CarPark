import UIKit

protocol SearchResultHeaderViewDelegate: AnyObject {
    func didTapAllDelete()
}

final class SearchResultHeaderView: UITableViewHeaderFooterView {
    
    weak var delegate: SearchResultHeaderViewDelegate?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var deleteAllButton: UIButton = {
        let button = UIButton()
        button.setTitle("전체 삭제", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        
        button.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

     override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        self.addSubview(titleLabel)
        self.addSubview(deleteAllButton)
        
        NSLayoutConstraint.activate([
            self.titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            self.deleteAllButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.deleteAllButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    }
    
    func setRecommendParks() {
        titleLabel.text = "가까운 주차장"
        deleteAllButton.isHidden = true
    }
    
    func setSearchLogData() {
        titleLabel.text = "최근 검색어"
        deleteAllButton.isHidden = false
    }
    
    @objc func deleteAction() {
        delegate?.didTapAllDelete()
    }
}
