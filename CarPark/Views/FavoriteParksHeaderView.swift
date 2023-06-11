import UIKit

protocol FavoriteParksHeaderViewDelegate: AnyObject {
    func didTapAllDelete()
}

final class FavoriteParksHeaderView: UITableViewHeaderFooterView {
    
    weak var delegate: FavoriteParksHeaderViewDelegate?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "즐겨찾기 한 주차장"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
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
    
    @objc func deleteAction() {
        delegate?.didTapAllDelete()
    }
}
