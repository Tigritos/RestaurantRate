//
//  MainViewModel.swift
//  Restaurant Rate
//
//  Created by Tigran Oganisyan on 28.02.2022.
//

import Foundation
import RealmSwift

protocol MainViewModelDelegate: AnyObject {
    
}

final class MainViewModel {
    let realm = try! Realm()
    private var items: Results<Restaurant>!
    
    func viewDidLoad() {
        items = realm.objects(Restaurant.self)
    }
    
    func getItems() -> Results<Restaurant> {
        return items
    }
    
    func deleteItem(position: Int) {
        let item = self.items[position]
        try! realm.write {
            realm.delete(item)
        }
    }
}
