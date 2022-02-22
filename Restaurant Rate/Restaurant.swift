//
//  Restaurant.swift
//  Restaurant Rate
//
//  Created by Tigran Oganisyan on 26.01.2022.
//


import Foundation
import RealmSwift

class Restaurant: Object {
    @objc dynamic var name = ""
    @objc dynamic var kitchenRate = 0
    @objc dynamic var interiorRate = 0
    @objc dynamic var serviceRate = 0
    @objc dynamic var totalRate = 0.0
    @objc dynamic var picture: Data? = nil
}
