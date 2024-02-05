import CoreLocation
import Firebase

extension CLLocation {
    func toGeoPoint() -> GeoPoint {
        return GeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}
