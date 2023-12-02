import UIKit

final class ImagePageViewController: BaseViewController {
    
    private lazy var pageVC: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        return pageViewController
    }()
    
    var contentImages: [UIImage] = []
    private var contentViewControllers: [UIViewController] = []
    
    private lazy var dismissBtn: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "xmark"), for: .normal)
        view.tintColor = .black
        view.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configurePageViewController()
    }
    
    override func configureHierarchy() {
        self.view.addSubview(pageVC.view)
        self.view.addSubview(dismissBtn)
    }
    
    override func configureConstraints() {
        NSLayoutConstraint.activate([
            pageVC.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            pageVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
          
            dismissBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            dismissBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            dismissBtn.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configurePageViewController() {
        contentImages
           .forEach { image in
               let vc = ImageContentViewController(image: image)
               contentViewControllers.append(vc)
           }
        
        pageVC.dataSource = self
        addChild(pageVC)
        pageVC.didMove(toParent: self)
        pageVC.setViewControllers([contentViewControllers[0]], direction: .forward, animated: false)
    }
    
    @objc func dismissVC() {
        self.dismiss(animated: true)
    }
}

extension ImagePageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = contentViewControllers.firstIndex(of: viewController) else { return nil }
        var previousIndex = index - 1
        if previousIndex < 0 { previousIndex = contentViewControllers.count - 1 }
        return contentViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = contentViewControllers.firstIndex(of: viewController) else { return nil }
        let nextIndex = (index + 1) % contentViewControllers.count
        return contentViewControllers[nextIndex]
    }
}
