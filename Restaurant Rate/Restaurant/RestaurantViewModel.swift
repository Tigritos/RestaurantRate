//
//  RestaurantViewModel.swift
//  Restaurant Rate
//
//  Created by Tigran Oganisyan on 28.02.2022.
//

import Foundation
import RealmSwift

protocol RestaurantViewModelDelegate: AnyObject {
    func fillStarButtons(_ tag: Int)
    func unfillStarButtons(_ tag: Int)
}

final class RestaurantViewModel {
    
    weak var delegate: RestaurantViewModelDelegate?
    
    let realm = try! Realm()
    private var name: String?
    private lazy var imagesArray = [UIImage]()
    
    private lazy var kitchenRate: Int = 0
    private lazy var interiorRate: Int = 0
    private lazy var serviceRate: Int = 0
    private lazy var totalRate: Double = 0
    
    func getImagesCount() -> Int {
        return imagesArray.count
    }
    
    func getImages() -> [UIImage] {
        return imagesArray
    }
    
    func addImage(image: UIImage) {
        imagesArray.append(image)
    }
    
    func updateSumOfRates() -> Double {
        let total: Double = Double(kitchenRate + interiorRate + serviceRate)/3
        let totalRounded: Double = round(total * 10) / 10
        return totalRounded
    }
    
    func saveButtonTapped() {
        let restaurant = Restaurant()
        restaurant.name = name ?? "Без названия"
        restaurant.kitchenRate = kitchenRate
        restaurant.interiorRate = interiorRate
        restaurant.serviceRate = serviceRate
        restaurant.totalRate = updateSumOfRates()
        if !imagesArray.isEmpty {
            restaurant.picture = imagesArray[0].jpegData(compressionQuality: 0.9)
        }
        
        try! realm.write {
            realm.add(restaurant)
        }
    }
    
    func starButtonDidTapped(tag: Int) {
        if tag < 11 {
            kitchenRate = tag
            for tag in 1...tag {
                delegate?.fillStarButtons(tag)
            }
            guard tag != 10 else {return}
            for tag in tag + 1...10 {
                delegate?.unfillStarButtons(tag)
            }
        } else if tag > 10 && tag < 21 {
            interiorRate = tag - 10
            for tag in 11...tag {
                delegate?.fillStarButtons(tag)
            }
            guard tag != 20 else {return}
            for tag in tag + 1...20 {
                delegate?.unfillStarButtons(tag)
            }
            
        } else if tag > 20 && tag < 31 {
            serviceRate = tag - 20
            for tag in 21...tag {
                delegate?.fillStarButtons(tag)
            }
            guard tag != 30 else {return}
            for tag in tag + 1...30 {
                delegate?.unfillStarButtons(tag)
            }
        }
    }
    
    func updateName(name: String?) {
        self.name = name
    }
}
