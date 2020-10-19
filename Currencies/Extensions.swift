//
//  Router.swift
//  Currencies
//
//  Created by Egor Bozko on 10/17/20.
//  Copyright © 2020 Egor Bozko. All rights reserved.
//

import Foundation
import UIKit

extension Bundle {
    static func apiURL() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "apiURL") as? String ?? "No API URL"
    }
}

extension Locale {
    static func getCurrencyName(for name: String) -> String {
        return Locale.current.localizedString(forCurrencyCode: name) ?? name
    }
}

extension UIViewController {
    func show(message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
