//
//  Router.swift
//  Currencies
//
//  Created by Egor Bozko on 10/17/20.
//  Copyright © 2020 Egor Bozko. All rights reserved.
//

import Foundation

extension Bundle {
    static func apiURL() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "apiURL") as? String ?? "No API URL"
    }
}
