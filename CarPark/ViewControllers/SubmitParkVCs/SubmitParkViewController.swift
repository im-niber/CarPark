import UIKit
import PhotosUI

final class SubmitParkViewController: BaseViewController {
    
    private var chooseImages: [UIImage] = []
    
    private lazy var picker: PHPickerViewController = {
        var configure = PHPickerConfiguration()
        configure.selectionLimit = 5
        configure.filter = .images
        let picker = PHPickerViewController(configuration: configure)
        picker.delegate = self
        
        return picker
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "주차장 사진을 등록해주세요"
        view.font = .systemFont(ofSize: 22, weight: .semibold)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var imagePickerBtn: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "submitBtn"), for: .normal)
        view.imageView?.contentMode = .scaleAspectFit
        view.addTarget(self, action: #selector(imageUploadBtn), for: .touchUpInside)

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "주차장 등록"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    override func configureHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(imagePickerBtn)
    }
    
    override func configureConstraints() {
        NSLayoutConstraint.activate([
            
            imagePickerBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imagePickerBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40),
            imagePickerBtn.widthAnchor.constraint(equalToConstant: 300),
            imagePickerBtn.heightAnchor.constraint(equalToConstant: 300),
            
            titleLabel.bottomAnchor.constraint(equalTo: imagePickerBtn.topAnchor, constant: -16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    @objc func imageUploadBtn() {
        self.present(picker, animated: true)
    }
}
extension SubmitParkViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        if !(results.isEmpty)  {
            chooseImages.removeAll()
            
            for result in results {
                let itemProvider = result.itemProvider
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                        self?.chooseImages.append(image as! UIImage)
                    
                        if self?.chooseImages.count == results.count {
                            
                            DispatchQueue.main.async {
                                let nextSumbitVC = SubmitParkViewController2(chooseImages: self?.chooseImages ?? [])
                                
                                self?.navigationController?.pushViewController(nextSumbitVC, animated: true)
                                
//                                self?.show(nextSumbitVC, sender: nil)
                            }
                        }
                    }
                }
            }
        }
    }
}
