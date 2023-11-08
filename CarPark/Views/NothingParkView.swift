import UIKit

final class NothingParkView: UIView {
    
    private var title: String?

    private(set) lazy var notFavoriteParkView: UILabel = {
        let label = UILabel()
        label.text = title
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
    
    func setTitle(msg: String) {
        notFavoriteParkView.text = msg
    }
    
    private func setUpView() {
        addSubview(notFavoriteParkView)
        
        NSLayoutConstraint.activate([
            notFavoriteParkView.centerXAnchor.constraint(equalTo: centerXAnchor),
            notFavoriteParkView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
    }
}
