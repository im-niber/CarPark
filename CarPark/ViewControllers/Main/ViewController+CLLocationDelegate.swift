import UIKit
import NMapsMap

extension ViewController: CLLocationManagerDelegate {
    
    // MARK: 위치 설정 함수
    func setLocation(locationManager: CLLocationManager) {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    // MARK: 권한이 변경되면 카메라 이동 및 데이터 설정
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: locationManager.location?.coordinate.latitude ?? 0, lng: locationManager.location?.coordinate.longitude ?? 0))
        cameraUpdate.animation = .easeIn
        
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            setPartnerParks()
            setMarker()
            getClusterParks()
        }

        NM.mapView.moveCamera(cameraUpdate)
    }

}
