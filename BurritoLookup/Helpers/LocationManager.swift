//
//  LocationManager.swift
//  BurritoLookup
//
//  Modified from https://gist.github.com/igroomgrim/ac1d46b5aea1173e6760
//  Created by Eduard Lev on 6/27/18.
//  Copyright © 2018 Eduard Levshteyn. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate: class {
    func didUpdateLocation(currentLocation: CLLocation)
    func didFailWithError(error: Error)
}

class LocationManager: NSObject {
    static let shared = LocationManager()

    private var locationManager: CLLocationManager?
    var lastLocation: CLLocation?
    weak var delegate: LocationManagerDelegate?

    override private init() {
        super.init()

        if self.locationManager == nil {
            self.locationManager = CLLocationManager()
        }
        requestAuthorizationStatus()
        prepareLocationManager()
    }

    fileprivate func requestAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager?.requestWhenInUseAuthorization()
        }
    }

    fileprivate func prepareLocationManager() {
        locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager?.distanceFilter = 500
        locationManager?.delegate = self
    }

    func startUpdatingLocation() {
        self.locationManager?.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        self.locationManager?.stopUpdatingLocation()
    }
}

// MARK: - CLLocationManager Delegate Methods

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        self.lastLocation = location
        updateLocation(currentLocation: location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        updateLocationDidFailWithError(error: error)
    }
}

// MARK: - Delegate Methods

extension LocationManager {
    fileprivate func updateLocation(currentLocation: CLLocation) {
        guard let delegate = self.delegate else { return }
        delegate.didUpdateLocation(currentLocation: currentLocation)
    }

    fileprivate func updateLocationDidFailWithError(error: Error) {
        guard let delegate = self.delegate else { return }
        delegate.didFailWithError(error: error)
    }
}
