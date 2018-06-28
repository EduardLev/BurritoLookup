//
//  GoogleResultsFetcher.swift
//  BurritoLookup
//
//  Created by Eduard Lev on 6/27/18.
//  Copyright © 2018 Eduard Levshteyn. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class GoogleResultsFetcher {

    static let shared = GoogleResultsFetcher()

    private var session: URLSession
    private var task: URLSessionDataTask?

    // Injection for later testing
    private init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    /// Returns a completion with an array of GooglePlace objects created by completing a
    /// Google Places API 'Nearby' search using the user's coordinate location.
    ///
    /// - Parameters:
    ///   - coordinate: The coordinate to search nearby
    ///   - radius: The length, in meters, of the distance from coordinate to search
    ///   - completion: An array of nearby places if the search was successful. An empty array if there was an error in the API call or if no places were found.
    func fetchGooglePlaces(nearCoordinate coordinate: CLLocationCoordinate2D,
                           radius: Int, completion: @escaping ([GooglePlace]) -> Void) {
        guard let url = createGooglePlacesURL(withCoordinate: coordinate,
                                              andRadius: radius)
            else { completion([]); return }

        // Show that work will start in an asynchronous manner.
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }

        // (todo) error handling
        task = session.dataTask(with: url) { (data, response, error) in
            var googlePlaces: [GooglePlace] = []

            guard let data = data,
                let places = try? JSONDecoder().decode(GooglePlacesResponse.self, from: data) else {
                    completion([])
                    return
            }
            googlePlaces = places.results

            defer {
                // Completion handler work must continue on the main thread
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    completion(googlePlaces)
                }
            }
        }

        task?.resume()
    }
}

extension GoogleResultsFetcher {

    /// Creates a URL suitable for use with the Google Places API (Nearby Search)
    ///
    /// - Parameters:
    ///   - coordinate: The coordinate to search nearby
    ///   - radius: The length, in meters, of the distance from coordinate to search
    /// - Returns: An optional URL value for use in the Google Places API
    // swiftlint:disable:next line_length
    fileprivate func createGooglePlacesURL(withCoordinate coordinate: CLLocationCoordinate2D, andRadius radius: Int) -> URL? {
        let location: String = "location=\(coordinate.latitude),\(coordinate.longitude)"
        let radiusString: String = "radius=\(radius)"
        let type: String = "type=restaurant"
        let keyword: String = "keyword=burrito"
        let key: String = "key=\(AppDelegate.googleSDKApiKey)"

        let urlString = "\(GoogleURL.nearbySearchJSON)\(location)&\(radiusString)&\(type)&\(keyword)&\(key)"
        return URL(string: urlString)
    }
}

extension GoogleResultsFetcher {
    private struct GoogleURL {
        static let nearbySearchJSON = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
    }
}
