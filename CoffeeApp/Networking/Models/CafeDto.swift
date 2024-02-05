import Foundation
import Firebase
import CoreLocation

struct CafeDto: Codable, Equatable {
    let uid: String
    var title: String
    var description: String
    var contactInfo: CafeContactInfoDto
    var location: GeoPoint
    
    static var mock: [CafeDto] = [CafeDto(uid: UUID().uuidString,
                                          title: "Kawiarnia Drukarnia",
                                          description: "Opis kawiarni",
                                          contactInfo: CafeContactInfoDto(phoneNumber: "+48662891281",
                                                                          email: "kawiania.drukarnia@gmail.com"),
                                          location: GeoPoint(latitude: 54.349628, longitude: 18.655946)),
                                  CafeDto(uid: UUID().uuidString,
                                          title: "Przystanek Kawa",
                                          description: "Opis kawiarni",
                                          contactInfo: CafeContactInfoDto(phoneNumber: "+48662891281",
                                                                          email: "przystanek.kawa@gmail.com"),
                                          location: GeoPoint(latitude: 54.410442, longitude: 18.601772)),
                                  CafeDto(uid: UUID().uuidString,
                                          title: "Kawiarnia CzKawka",
                                          description: "Opis kawiarni",
                                          contactInfo: CafeContactInfoDto(phoneNumber: "+48662891281",
                                                                          email: "kawiania.czkawka@gmail.com"),
                                          location: GeoPoint(latitude: 54.349628, longitude: 18.655946)),
                                  CafeDto(uid: UUID().uuidString,
                                          title: "Fukafe",
                                          description: "Opis kawiarni",
                                          contactInfo: CafeContactInfoDto(phoneNumber: "+48662891281",
                                                                          email: "fukafe@gmail.com"),
                                          location: GeoPoint(latitude: 54.356030, longitude: 18.646120))]
    
    static func == (lhs: CafeDto, rhs: CafeDto) -> Bool {
        lhs.uid == rhs.uid
    }
}

struct CafeContactInfoDto: Codable {
    var phoneNumber: String
    var email: String
}
