import Foundation

struct AddressSuggestionModel: Decodable, Identifiable {
    var id = UUID().uuidString
    var adres: String
    var tip: String
    var poiadi: String
    var csb: String
    var mahalle: String
    var ilce: String
    var il: String
    var boylam: Double
    var enlem: Double
    var il_id: Int
    var ilce_id: Int
    var mah_id: Int
    var cs_id: Int
    var uavt: Int
    var mesafe: Int? // Optional mesafe
    var poiid: Int
    var csb_eskiadi: String
    var buildingID: Int
    var buildingNO: String
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        self.adres = try container.decode(String.self)
        self.tip = try container.decode(String.self)
        self.poiadi = try container.decode(String.self)
        self.csb = try container.decode(String.self)
        self.mahalle = try container.decode(String.self)
        self.ilce = try container.decode(String.self)
        self.il = try container.decode(String.self)
        self.boylam = try container.decode(Double.self)
        self.enlem = try container.decode(Double.self)
        self.il_id = try container.decode(Int.self)
        self.ilce_id = try container.decode(Int.self)
        self.mah_id = try container.decode(Int.self)
        self.cs_id = try container.decode(Int.self)
        self.uavt = try container.decode(Int.self)
        self.mesafe = try? container.decode(Int.self) // Optional mesafe
        self.poiid = try container.decode(Int.self)
        self.csb_eskiadi = try container.decode(String.self)
        self.buildingID = try container.decode(Int.self)
        self.buildingNO = try container.decode(String.self)
    }
}
