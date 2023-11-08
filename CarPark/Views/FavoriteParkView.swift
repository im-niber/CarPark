import UIKit

final class FavoriteParkView: UIView {

    private(set) lazy var notFavoriteParkView: UILabel = {
        let label = UILabel()
        label.text = "즐겨찾기한 주차장이 없습니다."
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .gray
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var tableView: UITableView = {
        let vc = UITableView()
        vc.translatesAutoresizingMaskIntoConstraints = false
        
        return vc
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        addSubview(tableView)
        addSubview(notFavoriteParkView)
        
        tableView.layer.cornerRadius = 20
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 10.0
        tableView.sectionHeaderHeight = 35
        
        tableView.register(ParkTitleCell.self, forCellReuseIdentifier: ParkTitleCell.identifier)
        tableView.register(FavoriteParksHeaderView.self, forHeaderFooterViewReuseIdentifier: FavoriteParksHeaderView.identifier)
        
        NSLayoutConstraint.activate([
            notFavoriteParkView.centerXAnchor.constraint(equalTo: centerXAnchor),
            notFavoriteParkView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
