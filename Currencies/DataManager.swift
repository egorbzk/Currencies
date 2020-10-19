//
//  UserDataManager.swift
//  Currencies
//
//  Created by Egor Bozko on 10/17/20.
//  Copyright © 2020 Egor Bozko. All rights reserved.
//

import Foundation

final class DataManager {
    
    static let shared = DataManager()
    
    static let FavoriteItemsKey = "FavoriteItems"
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private let userDefaults = UserDefaults.standard
    var favoriteItems: [APILatestResponse.Rate] = []

    init() {
        self.reladData()
    }
    
    func isFavorite(_ item: APILatestResponse.Rate) -> Bool {
        return favoriteItems.contains(where: {$0.name == item.name})
    }
    
    func save(_ item: APILatestResponse.Rate) {
        if favoriteItems.contains(where: {$0.name == item.name}) {
            delete(item: item)
        } else {
            save(favoriteItems + [item])
        }
    }
    
    func delete(item: APILatestResponse.Rate) {
        if let index = favoriteItems.firstIndex(where: {$0.name == item.name}) {
            favoriteItems.remove(at: index)
            userDefaults.removeObject(forKey: DataManager.FavoriteItemsKey)
            userDefaults.synchronize()
            save(favoriteItems)
        }
    }
    
    private func save(_ items: [APILatestResponse.Rate]) {
        var j: [String : Double] = [:]
        for item in items {
            j[item.name] = item.value
        }
        let data = try! encoder.encode(j)
        userDefaults.set(data, forKey: DataManager.FavoriteItemsKey)
        userDefaults.synchronize()
        self.reladData()
    }
    
    private func reladData() {
        if let data = userDefaults.data(forKey: DataManager.FavoriteItemsKey) {
            let decoded: [String : Double] = try! decoder.decode([String : Double].self, from: data)
            favoriteItems = decoded.map({ APILatestResponse.Rate(name: $0.key, value: $0.value, localizedTitle: Locale.getCurrencyName(for: $0.key)) }).sorted(by: {$0.name < $1.name})
        }
    }
}
