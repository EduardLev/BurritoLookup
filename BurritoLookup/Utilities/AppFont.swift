//
//  AppFont.swift
//  BurritoLookup
//
//  Created by Eduard Lev on 6/27/18.
//  Copyright © 2018 Eduard Levshteyn. All rights reserved.
//

import Foundation
import UIKit

struct AppFonts {
    static var main: UIFont {
        if #available(iOS 11.0, *) {
            return UIFontMetrics(forTextStyle: .headline)
                .scaledFont(for: UIFont.preferredFont(forTextStyle: .headline)
                    .withSize(24.0))
        } else {
            return UIFont.preferredFont(forTextStyle: .headline).withSize(24)
        }
    }

    static var detail: UIFont {
        if #available(iOS 11.0, *) {
            return UIFontMetrics(forTextStyle: .body)
                .scaledFont(for: UIFont.preferredFont(forTextStyle: .body)
                    .withSize(18.0))
        } else {
            return UIFont.preferredFont(forTextStyle: .body).withSize(18)
        }
    }

    static var comment: UIFont {
        if #available(iOS 11.0, *) {
            return UIFontMetrics(forTextStyle: .caption1)
                .scaledFont(for: UIFont.preferredFont(forTextStyle: .caption1)
                    .withSize(14.0))
        } else {
            return UIFont.preferredFont(forTextStyle: .caption1).withSize(14)
        }
    }
}
