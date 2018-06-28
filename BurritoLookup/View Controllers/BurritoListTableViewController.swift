//
//  BurritoListTableViewController.swift
//  BurritoLookup
//
//  Created by Eduard Lev on 6/27/18.
//  Copyright © 2018 Eduard Levshteyn. All rights reserved.
//

import UIKit
import CoreLocation

class BurritoListTableViewController: UITableViewController {

    var placeList: [GooglePlace] = []

    lazy var googleResultsFetcher = GoogleResultsFetcher.shared
    lazy var locationManager = LocationManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = .title
        prepareTableView()
        prepareLocationManager()
    }

    fileprivate func prepareTableView() {
        tableView.separatorStyle = .none
        tableView.register(BurritoListTableViewCell.self, forCellReuseIdentifier: .burritoCellReuseIdentifier)
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    fileprivate func prepareLocationManager() {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }

    fileprivate func fetchGoogleResults(withCoordinate coordinate: CLLocationCoordinate2D) {
        googleResultsFetcher.fetchGooglePlaces(nearCoordinate: coordinate,
            radius: Constants.searchRadius) { [unowned self] (places) in
            self.placeList = places
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:
            .burritoCellReuseIdentifier, for: indexPath)
            as! BurritoListTableViewCell //swiftlint:disable:this force_cast
        let place = placeList[indexPath.row]
        cell.prepare(name: place.name, address: place.address, location: place.location, description: place.description)
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }

    // MARK: - Table View Delegate {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let burritoMapViewController = BurritoMapViewController()
        burritoMapViewController.googlePlace = placeList[indexPath.row]
       self.splitViewController?.showDetailViewController(burritoMapViewController, sender: nil)
    }
}

// MARK: - Location Updates Delegate Methods

extension BurritoListTableViewController: LocationManagerDelegate {
    func didUpdateLocation(currentLocation: CLLocation) {
        fetchGoogleResults(withCoordinate: currentLocation.coordinate)
    }

    func didFailWithError(error: Error) {
        // (todo) error handling
        print(error.localizedDescription)
    }
}

extension BurritoListTableViewController {
    private struct Constants {
        static let cellHeight: CGFloat = 150
        static let searchRadius: Int = 1000
    }
}

fileprivate extension String {
    static let burritoCellReuseIdentifier = "burritoListCell"

    static let title = NSLocalizedString("Burrito Places", comment: "Heading for the Burrito List View")
}
