import UIKit
import NMapsMap

final class CustomInfoWindowDataSource: NSObject, NMFOverlayImageDataSource {
    var rootView = CustomInfoWindowView()
    
    func view(with overlay: NMFOverlay) -> UIView {
        guard let infoWindow = overlay as? NMFInfoWindow else { return rootView }
        
        // MARK: PartnerMarker로 바꾼 다음 빈자리를 넣기
        if let marker = infoWindow.marker as? ParkMarker {
            guard marker.park.emptySpace != "0" else { return UIView() }
            rootView.textLabel.text = ": \(marker.park.emptySpace ?? "")"
            rootView.textLabel2.text = ": \(marker.park.handicapSpace ?? "")"
        }
        
//        rootView.textLabel.sizeToFit()
//        let width = rootView.textLabel.frame.size.width + 16
        
        rootView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        rootView.layoutIfNeeded()
        
        return rootView
    }
    
}
