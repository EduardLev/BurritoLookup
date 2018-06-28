//
//  GooglePlace.swift
//  BurritoLookup
//
//  Created by Eduard Lev on 6/27/18.
//  Copyright © 2018 Eduard Levshteyn. All rights reserved.
//

import Foundation
import CoreLocation

// Struct is based on the layout of the Google Places API JSON Response

struct GooglePlacesResponse: Codable {
    let results: [GooglePlace]

    enum CodingKeys: String, CodingKey {
        case results
    }
}

// Model
struct GooglePlace: Codable {
    let name: String
    let address: String
    let location: Location

    // Description hard-coded because Google Places API
    // does not return a description.
    let description: String = "$ • Budget Burrito Joint"

    struct Location: Codable {
        let latLong: GooglePlace.LatitudeLongitude

        // swiftlint:disable:next nesting
        enum CodingKeys: String, CodingKey {
            case latLong = "location"
        }
    }

    struct LatitudeLongitude: Codable {
        let latitude: Double
        let longitude: Double

        // swiftlint:disable:next nesting
        enum CodingKeys: String, CodingKey {
            case latitude = "lat"
            case longitude = "lng"
        }
    }

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case address = "vicinity"
        case location = "geometry"
    }
}
