import Foundation
//MARK: - MODEL

// MARK: - Rota Response
struct RotaResponse: Codable {
    let code: Int
    let message: String
    let errorIndex: Int
    let data: [RouteData]
    let manifestData: String?

    enum CodingKeys: String, CodingKey {
        case code, message, errorIndex, data, manifestData
    }
}

// MARK: - RouteData
struct RouteData: Codable {
    let features: [Feature]
    let properties: RouteProperties

    enum CodingKeys: String, CodingKey {
        case features, properties
    }
}

// MARK: - Feature
struct Feature: Codable {
    let type: String
    let geometry: Geometry
    let properties: FeatureProperties

    enum CodingKeys: String, CodingKey {
        case type, geometry, properties
    }
}

// MARK: - Geometry
struct Geometry: Codable {
    let type: String
    let coordinates: [[Double]]

    enum CodingKeys: String, CodingKey {
        case type, coordinates
    }
}

// MARK: - FeatureProperties
struct FeatureProperties: Codable {
    let fromNodeId: Int
    let toNodeId: Int
    let basarId: Int
    let fc: Int
    let df: Int
    let distance: Double
    let duration: Double
    let averageSpeed: Int
    let averageTrafficSpeed: Double
    let speedLimit: Int
    let typeName: String
    let constructionName: String
    let adjacentEdges: String?
    let name: String

    enum CodingKeys: String, CodingKey {
        case fromNodeId, toNodeId, basarId, fc, df, distance, duration, averageSpeed, averageTrafficSpeed, speedLimit, typeName, constructionName, adjacentEdges, name
    }
}

// MARK: - RouteProperties
struct RouteProperties: Codable {
    let duration: Int
    let distance: Double

    enum CodingKeys: String, CodingKey {
        case duration, distance
    }
}





