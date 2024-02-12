import Foundation
import Firebase
import CoreLocation
import FirebaseFirestoreSwift

struct CafeDto: FirestoreProtocol, Hashable, Equatable {
    let uid: String
    var title: String
    var description: String
    var contactInfo: CafeContactInfoDto
    var location: GeoPoint
    var coupons: [CouponDto]?
    @ServerTimestamp var createdAt: Timestamp? = Timestamp(date: .now)
    
    static var mock: [CafeDto] = [
        CafeDto(uid: UUID().uuidString,
                                          title: "Kawiarnia Drukarnia",
                                          description: "Kawiarnia na malowniczej ul. Mariackiej, która mieści się w tym, co kiedyś było drukarnią. Wygląd jest dość nowoczesny i przemysłowy, odzwierciedlający poprzednie przeznaczenie lokalu, chociaż powodem do odwiedzenia jest kawa, która jest doskonała. Weź kawałek jednego z ich świeżo upieczonych ciast, tak jak my zrobiliśmy, i będziesz idealnie przygotowany do następnego etapu zwiedzania. Naprawdę jedna z najlepszych kawiarni w Trójmieście.",
                                          contactInfo: CafeContactInfoDto(phoneNumber: "+48662891281",
                                                                          email: "kawiania.drukarnia@gmail.com"),
                                          location: GeoPoint(latitude: 54.349628, longitude: 18.655946)),
                                  CafeDto(uid: UUID().uuidString,
                                          title: "Przystanek Kawa",
                                          description: "Kawiarnia na malowniczej ul. Mariackiej, która mieści się w tym, co kiedyś było drukarnią. Wygląd jest dość nowoczesny i przemysłowy, odzwierciedlający poprzednie przeznaczenie lokalu, chociaż powodem do odwiedzenia jest kawa, która jest doskonała. Weź kawałek jednego z ich świeżo upieczonych ciast, tak jak my zrobiliśmy, i będziesz idealnie przygotowany do następnego etapu zwiedzania. Naprawdę jedna z najlepszych kawiarni w Trójmieście.",
                                          contactInfo: CafeContactInfoDto(phoneNumber: "+48662891281",
                                                                          email: "przystanek.kawa@gmail.com"),
                                          location: GeoPoint(latitude: 54.410442, longitude: 18.601772)),
                                  CafeDto(uid: UUID().uuidString,
                                          title: "Kawiarnia CzKawka",
                                          description: "Kawiarnia na malowniczej ul. Mariackiej, która mieści się w tym, co kiedyś było drukarnią. Wygląd jest dość nowoczesny i przemysłowy, odzwierciedlający poprzednie przeznaczenie lokalu, chociaż powodem do odwiedzenia jest kawa, która jest doskonała. Weź kawałek jednego z ich świeżo upieczonych ciast, tak jak my zrobiliśmy, i będziesz idealnie przygotowany do następnego etapu zwiedzania. Naprawdę jedna z najlepszych kawiarni w Trójmieście.",
                                          contactInfo: CafeContactInfoDto(phoneNumber: "+48662891281",
                                                                          email: "kawiania.czkawka@gmail.com"),
                                          location: GeoPoint(latitude: 54.349628, longitude: 18.655946)),
                                  CafeDto(uid: UUID().uuidString,
                                          title: "Fukafe",
                                          description: "Kawiarnia na malowniczej ul. Mariackiej, która mieści się w tym, co kiedyś było drukarnią. Wygląd jest dość nowoczesny i przemysłowy, odzwierciedlający poprzednie przeznaczenie lokalu, chociaż powodem do odwiedzenia jest kawa, która jest doskonała. Weź kawałek jednego z ich świeżo upieczonych ciast, tak jak my zrobiliśmy, i będziesz idealnie przygotowany do następnego etapu zwiedzania. Naprawdę jedna z najlepszych kawiarni w Trójmieście.",
                                          contactInfo: CafeContactInfoDto(phoneNumber: "+48662891281",
                                                                          email: "fukafe@gmail.com"),
                                          location: GeoPoint(latitude: 54.356030, longitude: 18.646120))
    ]
    
    static func == (lhs: CafeDto, rhs: CafeDto) -> Bool {
        lhs.uid == rhs.uid
    }
}

struct CafeContactInfoDto: Codable, Hashable {
    var phoneNumber: String
    var email: String
}
