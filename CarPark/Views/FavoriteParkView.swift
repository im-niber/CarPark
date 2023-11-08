import UIKit

final class FavoriteParkView: UIView {

    private(set) lazy var notFavoriteParkView: UILabel = {
        let label = UILabel()
        label.text = "즐겨찾기한 주차장이 없습니다."
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        addSubview(notFavoriteParkView)
        
        NSLayoutConstraint.activate([
            notFavoriteParkView.centerXAnchor.constraint(equalTo: centerXAnchor),
            notFavoriteParkView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
    }
}
