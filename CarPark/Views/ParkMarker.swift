import Foundation

import NMapsMap

final class ParkMarker: NMFMarker {
    
    var didTap: (() -> Bool)?

    let data: Item
    var vc: ViewController?
    var drivingMarker: Bool = false
    
    init(data: Item, _ vc: ViewController? = nil) {
        self.data = data
        self.vc = vc
        super.init()
        
        if data.yCdnt == "-" { return }
        
        self.width = 30
        self.height = 35
        self.iconPerspectiveEnabled = true
        self.iconImage = NMFOverlayImage(name: "marker_normal")
        self.hidden = true
        
        if let emptySpace = Int(data.emptySpace ?? "") {
            self.width = 35
            self.height = 40
            self.hidden = false
            self.iconImage = NMFOverlayImage(name: "marker_available")
          
            if emptySpace == 0 {
                self.iconImage = NMFOverlayImage(name: "marker_unavailable")
            }
        }
        
        self.position = NMGLatLng(lat: Double(data.yCdnt) ?? -1, lng: Double(data.xCdnt) ?? -1)
    }
    
    func setTouchEvent(vc: ViewController) {
        self.touchHandler = { (overlay: NMFOverlay) -> Bool in
            if self.drivingMarker { return false }
            
            let sheetVC: CarParkInfoViewController = UIStoryboard(name: "CarParkInfoView", bundle: nil).instantiateViewController(identifier: "CarParkInfoView") { coder in
                let vc = CarParkInfoViewController(marker: self, coder: coder)
                return vc
            }
            if let presentationSheetVC = sheetVC.presentationController as? UISheetPresentationController {
                presentationSheetVC.detents = [.medium(), .large()]
                presentationSheetVC.prefersGrabberVisible = true
                sheetVC.delegate = vc
                self.vc?.present(sheetVC, animated: true)
            }
            
            return true
        }
    }
}
