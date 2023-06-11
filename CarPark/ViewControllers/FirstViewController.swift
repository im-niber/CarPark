import UIKit

final class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        checkLogin()
    }

    private func checkLogin() {
        if UserDefault.shared.checkLoggedIn() {
            self.navigationController?.popViewController(animated: false)
            self.navigationController?.pushViewController(ViewController(), animated: false)
        }
    }
}
