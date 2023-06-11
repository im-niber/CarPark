import UIKit
import NMapsMap

extension ViewController: DrivingDelegate {
    // MARK: 선택한 주차장까지의 경로를 나타내는 함수
    func getDriving(goalLng: String, goalLat: String, goalLocation: String, marker: ParkMarker) {
        driving = true
        
        let startLng = String(locationManager.location?.coordinate.longitude ?? -1)
        let startLat = String(locationManager.location?.coordinate.latitude ?? -1)
        
        let configuraiton = URLSessionConfiguration.default
        configuraiton.httpAdditionalHeaders = [
            "X-NCP-APIGW-API-KEY-ID" : Secret.clientID,
            "X-NCP-APIGW-API-KEY" : Secret.clientSecret
        ]
      
        NetworkManager.shared.fetch(session: URLSession(configuration: configuraiton), with: APIConstants.wayURL(start: "\(startLng),\(startLat)", goal: "\(goalLng),\(goalLat)").wayURL, type: Root.self) { [weak self] data in
            guard let data = data.route.first?.value.first else { return }
            
            self?.pathOverlay.path = NMGLineString(points: data.path.map { route in
                NMGLatLng(lat: route[1], lng: route[0])
            })

            DispatchQueue.main.async {
                self?.pathOverlay.mapView = self?.NM.mapView
                self?.drivingView.isHidden = false
                marker.drivingMarker = true
                self?.drivingView.configure(to: goalLocation, time: data.summary.duration, marker: marker)
                
                let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: self?.locationManager.location?.coordinate.latitude ?? 0, lng: self?.locationManager.location?.coordinate.longitude ?? 0))
                cameraUpdate.animation = .easeIn
              
                self?.NM.mapView.moveCamera(cameraUpdate)
            }
        }
    }
}

extension ViewController: DrivingActionDelegate {
    func didTapCancelButton() {
        pathOverlay.mapView = nil
        driving = false
        self.drivingView.marker?.drivingMarker = false
    }
}
