import Combine
import UIKit

class BaseViewController: UIViewController {
    
    // MARK: - Properties
    var cancellable: Set<AnyCancellable> = []
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        configureHierarchy()
        configureConstraints()
        bind()
    }
    
    func configureHierarchy() {}
    func configureConstraints() {}
    func bind() {}
    
}
