//
//  BurritoListTableViewCell.swift
//  BurritoLookup
//
//  Created by Eduard Lev on 6/27/18.
//  Copyright © 2018 Eduard Levshteyn. All rights reserved.
//

import UIKit
import QuartzCore

class BurritoListTableViewCell: UITableViewCell {

    // MARK: - View Properties
    var containerView = UIView()
    let restaurantNameLabel = UILabel()
    let restaurantAddressLabel = UILabel()
    let restaurantDescriptionLabel = UILabel()
    let caratImageView = UIImageView()
    var stackView: UIStackView!

    private lazy var allViewOutlets = [containerView,
                                       restaurantNameLabel,
                                       restaurantAddressLabel,
                                       restaurantDescriptionLabel,
                                       caratImageView]

    var location: GooglePlace.Location?

    // MARK: - Initialization

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareViews()
        selectionStyle = .none
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Controller Model Setup

    func prepare(name: String, address: String, location: GooglePlace.Location, description: String) {
        restaurantNameLabel.text = name
        restaurantAddressLabel.text = address
        restaurantDescriptionLabel.text = description
        self.location = location
    }

    // MARK: - View Preparation & Loading

    fileprivate func prepareViews() {
        allViewOutlets.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        prepareContainerView()
        prepareRestaurantNameLabel()
        prepareRestaurantAddressLabel()
        prepareRestaurantDescriptionLabel()
        prepareCaratImageView()
        prepareStackView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        addShadow()
    }

    fileprivate func addShadow() {
        containerView.layer.masksToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        containerView.layer.shadowOpacity = 0.15
        containerView.layer.shadowRadius = 6
    }

    fileprivate func prepareContainerView() {
        contentView.addSubview(containerView)
        containerView.backgroundColor = UIColor.white
        containerView.layer.cornerRadius = Constants.cornerRadius

        containerView.leadingAnchor
            .constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalInset).isActive = true
        containerView.trailingAnchor
            .constraint(equalTo: contentView.trailingAnchor, constant:
                -Constants.horizontalInset).isActive = true
        containerView.topAnchor
            .constraint(equalTo: contentView.topAnchor, constant: Constants.verticalInset).isActive = true
        containerView.bottomAnchor
            .constraint(equalTo: contentView.bottomAnchor, constant:
                -Constants.verticalInset).isActive = true
    }

    fileprivate func prepareRestaurantNameLabel() {
        restaurantNameLabel.font = AppFonts.main
        restaurantNameLabel.textColor = AppColors.main
        generalPrepareLabel(restaurantNameLabel)
    }

    fileprivate func prepareRestaurantAddressLabel() {
        restaurantAddressLabel.font = AppFonts.detail
        restaurantAddressLabel.textColor = UIColor.darkGray
        generalPrepareLabel(restaurantAddressLabel)
    }

    fileprivate func prepareRestaurantDescriptionLabel() {
        restaurantDescriptionLabel.font = AppFonts.comment
        restaurantDescriptionLabel.textColor = UIColor.lightGray
        generalPrepareLabel(restaurantDescriptionLabel)
    }

    fileprivate func generalPrepareLabel(_ label: UILabel) {
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .left
    }

    fileprivate func prepareCaratImageView() {
        caratImageView.image = UIImage(named: "Chevron")
        containerView.addSubview(caratImageView)

        caratImageView.centerYAnchor
            .constraint(equalTo: containerView.centerYAnchor).isActive = true
        caratImageView.trailingAnchor
            .constraint(equalTo:
            containerView.trailingAnchor, constant: -10).isActive = true
    }

    fileprivate func prepareStackView() {
        stackView = UIStackView(arrangedSubviews:
            [restaurantNameLabel, restaurantAddressLabel, restaurantDescriptionLabel])

        containerView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        setStackViewConstraints()
    }

    fileprivate func setStackViewConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.leadingAnchor
            .constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor
            .constraint(equalTo: containerView.trailingAnchor).isActive = true
        stackView.topAnchor
            .constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
        stackView.bottomAnchor
            .constraint(equalTo: containerView.bottomAnchor, constant: -20).isActive = true
    }
}

extension BurritoListTableViewCell {
    private struct Constants {
        static let cornerRadius: CGFloat = 10
        static let horizontalInset: CGFloat = 10
        static let verticalInset: CGFloat = 10
    }
}
