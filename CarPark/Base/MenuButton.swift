import UIKit

final class MenuButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        self.setTitleColor(.black, for: .normal)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
