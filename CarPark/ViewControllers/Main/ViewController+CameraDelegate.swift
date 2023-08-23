import UIKit
import NMapsMap

extension ViewController: NMFMapViewCameraDelegate {

    func mapViewCameraIdle(_ mapView: NMFMapView) {
        let allMarkers = ParkDB.shared.allMarkers
        
        if driving {
            allMarkers.forEach { item in
                if item.drivingMarker { item.hidden = false }
                else { item.hidden = true }
            }
            return
        }
        
        let markers = ParkDB.shared.markers
        var partenerMarkers: [ParkMarker] = []
        
        let projection = mapView.projection
        
        let startCoord = projection.latlng(from: CGPoint(x: 0, y: 0))
        let endCoord = projection.latlng(from: CGPoint(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height))
        
        // allmarkers로 나중에 수정
        allMarkers.forEach { item in
            item.vc = self
            item.mapView = self.NM.mapView
            
            if let emptySpace = item.data.emptySpace, Int(emptySpace)! != 0 {
                let infoWindow = NMFInfoWindow()
                infoWindow.dataSource = CustomInfoWindowDataSource()
                infoWindow.open(with: item)
            }
            
            let lng = item.position.lng, lat = item.position.lat
            
            if (startCoord.lng <= lng && lng <= endCoord.lng) && (startCoord.lat >= lat && lat >= endCoord.lat) {
                
                if mapView.cameraPosition.zoom <= 11.5 {
                    
                    for clusterPark in clusterParks {
                        if item.data == clusterPark.0 {
                            
                            let infoWindow = NMFInfoWindow()
                            let dataSource = NMFInfoWindowDefaultTextSource.data()
                            dataSource.title = "\(clusterPark.1)"
                            infoWindow.dataSource = dataSource
                            infoWindow.open(with: item)
                            
                            item.hidden = false
                            
                            break
                        }
                        else { item.hidden = true }
                    }
                }
                
                else {
                    item.hidden = false
                    if item.data.emptySpace == nil {
                        item.infoWindow?.close()
                    }
                }
            }
            
            else {
                item.hidden = true
            }
        }
//
//        fetchPartnerParks { data in
//            data.forEach { item in
//                let item = item.toParkItem()
//                partenerMarkers.append(ParkMarker(data: item))
//            }
//
//            DispatchQueue.main.async {
//                partenerMarkers.forEach { item in
//                    item.vc = self
//                    item.mapView = self.NM.mapView
//
//                    let infoWindow = NMFInfoWindow()
//                    infoWindow.dataSource = CustomInfoWindowDataSource()
//                    infoWindow.open(with: item)
//                }
//            }
//        }
    }
    
    /// zoom의 값을 미터로 변환하는 함수
    func convertZoomMeter(zoom: Double) -> Double {
        switch zoom {
        case 12.0 : return 1000
        case 11.0 : return 2000
        case 10.0 : return 5000
        case 9.0 : return 10000
        case 8.0 : return 20000
        case 7.0 : return 50000
        default: return 0
        }
    }
    
    func fetchPartnerParks(completionHandler: @escaping ([PartnerPark]) -> Void) {
        NetworkManager.shared.request(with: APIConstants.partnerParkURL, method: .get, type: Array<PartnerPark>.self) { result in
            switch result {
            case .success(let data):
                completionHandler(data)
            case .failure(let error):
                print("\(error)")
            }
        }
    }
}

