//
//  BurritoMapViewController.swift
//  BurritoLookup
//
//  Created by Eduard Lev on 6/27/18.
//  Copyright © 2018 Eduard Levshteyn. All rights reserved.
//

import UIKit
import GoogleMaps

class BurritoMapViewController: UIViewController {

    // MARK: - View Properties

    private let containerView = UIView()
    private let addressLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let googleMapView = GMSMapView()
    private var stackView: UIStackView!
    private let marker = GMSMarker()

    // MARK: - Model Object

    var googlePlace: GooglePlace? {
        didSet {
            updateForChangedModelObject()
        }
    }

    // MARK: - View Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareContainerView()
        prepareAddressLabel()
        prepareDescriptionLabel()
        prepareMapView()
        prepareStackView()
        updateForChangedModelObject()
    }

    // MARK: - View Preparation

    fileprivate func prepareView() {
        view.backgroundColor = UIColor.white
    }

    fileprivate func prepareContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.clipsToBounds = true
        containerView.backgroundColor = AppColors.main
        containerView.layer.cornerRadius = 10
        view.addSubview(containerView)
        setContainerViewConstraints()
    }

    fileprivate func prepareAddressLabel() {
        prepareGeneralLabel(label: addressLabel)
        addressLabel.font = AppFonts.main
    }

    fileprivate func prepareDescriptionLabel() {
        prepareGeneralLabel(label: descriptionLabel)
        descriptionLabel.font = AppFonts.detail
    }

    fileprivate func prepareGeneralLabel(label: UILabel) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.adjustsFontForContentSizeCategory = true
        label.textColor = UIColor.white
    }

    fileprivate func prepareMapView() {
        googleMapView.translatesAutoresizingMaskIntoConstraints = false
        googleMapView.delegate = self
        googleMapView.mapType = .normal
    }

    fileprivate func prepareStackView() {
        stackView = UIStackView(arrangedSubviews: [addressLabel, descriptionLabel, googleMapView])

        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10

        containerView.addSubview(stackView)
        setStackViewConstraints()
        setGoogleMapViewConstraints()
        setLabelConstraints()
    }

    fileprivate func prepareMarker() {
        let markerImage = UIImage(named: .pinImageName)
        let markerView = UIImageView(image: markerImage)
        marker.iconView = markerView
        marker.map = googleMapView
    }

    // MARK: - Constraints

    fileprivate func setContainerViewConstraints() {
        // (todo) Fix - Navigation Bar Overlays View
        containerView.topAnchor
            .constraint(equalTo: view.topAnchor, constant: 10 +
                navigationBarHeight + statusBarHeight).isActive = true
        containerView.bottomAnchor
            .constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        containerView.leadingAnchor
            .constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        containerView.trailingAnchor
            .constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
    }

    fileprivate func setStackViewConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.leadingAnchor
            .constraint(equalTo: containerView.leadingAnchor).isActive = true
        stackView.trailingAnchor
            .constraint(equalTo: containerView.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }

    fileprivate func setGoogleMapViewConstraints() {
        googleMapView.leadingAnchor
            .constraint(equalTo: stackView.leadingAnchor).isActive = true
        googleMapView.trailingAnchor
            .constraint(equalTo: stackView.trailingAnchor).isActive = true
        googleMapView.heightAnchor
            .constraint(equalTo: stackView.heightAnchor, multiplier: 0.8).isActive = true
    }

    fileprivate func setLabelConstraints() {
        addressLabel.leadingAnchor
            .constraint(equalTo: stackView.leadingAnchor, constant: 10).isActive = true
        descriptionLabel.leadingAnchor
            .constraint(equalTo: stackView.leadingAnchor, constant: 10).isActive = true
    }

    // MARK: - Updated Model

    fileprivate func updateForChangedModelObject() {
        if let googlePlace = googlePlace {
            prepareMarker()
            title = googlePlace.name
            addressLabel.text = googlePlace.address
            descriptionLabel.text = googlePlace.description
            prepareCamera(withPlace: googlePlace)
        }
    }

    fileprivate func prepareCamera(withPlace googlePlace: GooglePlace) {
        let latitude = googlePlace.location.latLong.latitude
        let longitude = googlePlace.location.latLong.longitude
        let camera = GMSCameraPosition.camera(withLatitude: latitude,
                                              longitude: longitude,
                                              zoom: zoom)
        googleMapView.camera = camera
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

// MARK: Google Map View Delegate

extension BurritoMapViewController: GMSMapViewDelegate {
    // EMPTY
}

// MARK: - Constants

extension BurritoMapViewController {
    private var navigationBarHeight: CGFloat {
        return self.navigationController?.navigationBar.frame.size.height ?? 0
    }

    private var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.size.height
    }

    private var zoom: Float { return 15.0 }
}

fileprivate extension String {
    static let pinImageName = "Pin"
}
