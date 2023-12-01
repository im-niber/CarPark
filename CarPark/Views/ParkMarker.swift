import Foundation

import NMapsMap

final class ParkMarker: NMFMarker {
    
    var didTap: (() -> Bool)?

    let park: Park
    let userPark: UserPark
    
    var vc: ViewController?
    var drivingMarker: Bool = false
    
    private func configureMarker() {
        self.width = 30
        self.height = 35
        self.iconPerspectiveEnabled = true
        self.iconImage = NMFOverlayImage(name: "marker_normal")
        self.hidden = true
    }
    
    init(park: Park, _ vc: ViewController? = nil) {
        self.park = park
        self.vc = vc
        self.userPark = UserPark.empty()
        super.init()
        
        if park.yCdnt == "-" { return }
        configureMarker()
        
        if let emptySpace = Int(park.emptySpace ?? "") {
            self.width = 35
            self.height = 40
            self.hidden = false
            self.iconImage = NMFOverlayImage(name: "marker_available")
          
            if emptySpace == 0 {
                self.iconImage = NMFOverlayImage(name: "marker_unavailable")
            }
        }
        
        self.position = NMGLatLng(lat: Double(park.yCdnt) ?? -1, lng: Double(park.xCdnt) ?? -1)
    }
    
    init(userPark: UserPark, _ vc: ViewController? = nil) {
        self.userPark = userPark
        self.vc = vc
        self.park = Park.empty()
        
        super.init()
        
        configureMarker()
        self.iconImage = NMFOverlayImage(name: "marker_available")
        self.position = NMGLatLng(lat: userPark.lat, lng: userPark.lng)
    }
    
    func setTouchEvent(vc: ViewController, data: Park) {
        self.touchHandler = { (overlay: NMFOverlay) -> Bool in
            if self.drivingMarker { return false }
            
            let sheetVC: CarParkInfoViewController = UIStoryboard(name: "CarParkInfoView", bundle: nil).instantiateViewController(identifier: "CarParkInfoView") { coder in
                let vc = CarParkInfoViewController(viewModel: CarParkInfoViewModel(marker: self), coder: coder)
                return vc
            }
            if let presentationSheetVC = sheetVC.presentationController as? UISheetPresentationController {
                presentationSheetVC.detents = [.medium(), .large()]
                presentationSheetVC.prefersGrabberVisible = true
                sheetVC.viewModel.delegate = vc
                self.vc?.present(sheetVC, animated: true)
            }
            
            return true
        }
    }
    
    func setTouchEvent(vc: ViewController, data: UserPark) {
        self.touchHandler = { (overlay: NMFOverlay) -> Bool in
            if self.drivingMarker { return false }
            
            let sheetVC: UserCarParkInfoViewController = UserCarParkInfoViewController()
            
            if let presentationSheetVC = sheetVC.presentationController as? UISheetPresentationController {
                presentationSheetVC.detents = [.medium(), .large()]
                presentationSheetVC.prefersGrabberVisible = true
                self.vc?.present(sheetVC, animated: true)
            }
            
            return true
        }
    }
}
