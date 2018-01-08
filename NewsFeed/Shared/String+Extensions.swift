//
//  Strings+Localized.swift
//  NewsFeed
//
//  Created by Tran Minh Tung on 1/7/18.
//  Copyright © 2018 TungTM. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }

    func localized(withComment: String) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: withComment)
    }
}

enum Localizer: String {
    // swiftlint:disable identifier_name
    case something_wrong, no_internet

    var description: String {
        return self.rawValue.localized
    }
}
