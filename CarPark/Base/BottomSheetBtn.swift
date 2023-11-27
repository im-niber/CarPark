import UIKit

final class BottomSheetBtn: UIButton {
    private var title: String?

    func updateLayerProperties() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 6
        self.layer.cornerRadius = 12
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configuration = .plain()
        self.tintColor = .black
        
        self.setTitleColor(.darkText ,for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 14, weight: .light)
        self.backgroundColor = .white
        self.setTitleShadowColor(.black, for: .selected)
        
        updateLayerProperties()
    }
    
    convenience init(title: String) {
        self.init(frame: .zero)
        self.title = title
        self.setTitle(title, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
