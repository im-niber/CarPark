import UIKit

final class DividerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    func configure() {
        backgroundColor = .lightGray
        setContentCompressionResistancePriority(.init(999), for: .horizontal)
        setContentCompressionResistancePriority(.init(999), for: .vertical)
        setContentHuggingPriority(.defaultHigh, for: .horizontal)
        setContentHuggingPriority(.defaultHigh, for: .vertical)
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 1)
    }

}
