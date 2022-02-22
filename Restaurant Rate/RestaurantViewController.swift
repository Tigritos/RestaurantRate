//
//  RestauranViewController.swift
//  Restaurant Rate
//
//  Created by Tigran Oganisyan on 24.01.2022.
//

import Foundation
import UIKit
import RealmSwift
import Photos
import PhotosUI
import Alamofire

final class RestaurantViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate, PHPickerViewControllerDelegate {

    let realm = try! Realm()

    private lazy var kitchenRate: Int = 0
    private lazy var interiorRate: Int = 0
    private lazy var serviceRate: Int = 0
    private lazy var totalRate: Double = 0
    
    private lazy var imagesArray = [UIImage]()
    // lazy var
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 150)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.register(ImagesCell.self,
                                forCellWithReuseIdentifier: ImagesCell.identifier)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var sumLabel: UILabel = {
        let label = UILabel()
        label.text = "/ 10"
        label.font = label.font?.withSize(30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var sumOfRatesLabel: UILabel = {
        let label = UILabel()
        label.text = " -"
        label.font = label.font?.withSize(30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    private lazy var kitchenStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var interiorStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var serviceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var defaultImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "photo.fill"))
        imageView.tintColor = .systemGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Название:"
        label.font = label.font?.withSize(18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var totalLabel: UILabel = {
        let label = UILabel()
        label.text = "Итог:"
        label.font = label.font?.withSize(30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 1
        textField.autocorrectionType = .no
        textField.placeholder = "  Ресторан у Ашота"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private lazy var kitchenLabel: UILabel = {
        let label = UILabel()
        label.text = "Кухня:"
        label.font = label.font?.withSize(17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var interiorLabel: UILabel = {
        let label = UILabel()
        label.text = "Интерьер:"
        label.font = label.font?.withSize(17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var serviceLabel: UILabel = {
        let label = UILabel()
        label.text = "Сервис:"
        label.font = label.font?.withSize(17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Сохранить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var checkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Check", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapCheckButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var addImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Добавить фото", for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        title = "Редактирование ресторана"
        view.backgroundColor = .white
//        imagesArray.append(UIImage(named: "sugar")!)
        addViews() 
        setupLayout()
        setupButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
// super redko delat'
    }
    
    private func addViews() {
//        view.addSubview(image)
        view.addSubview(collectionView)
        view.addSubview(nameLabel)
        view.addSubview(totalLabel)
        view.addSubview(sumOfRatesLabel)
        view.addSubview(sumLabel)
        view.addSubview(nameTextField)
        view.addSubview(saveButton)
        view.addSubview(checkButton)
        view.addSubview(scrollView)
        view.addSubview(defaultImage)
        scrollView.addSubview(contentView)
        contentView.addSubview(kitchenStackView)
        contentView.addSubview(interiorStackView)
        contentView.addSubview(serviceStackView)
        contentView.addSubview(kitchenLabel)
        contentView.addSubview(interiorLabel)
        contentView.addSubview(serviceLabel)
        collectionView.addSubview(addImageButton)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagesCell.identifier,
                                                            for: indexPath) as? ImagesCell else {
            return UICollectionViewCell()
        }
//        let queue = DispatchQueue(label: "serial queue")
//        queue.asyncAfter(deadline: .now() + 1, execute: <#T##DispatchWorkItem#>)
//        queue.sync(flags: DispatchWorkItemFlags.barrier, execute: <#T##() throws -> T#>)
        cell.imageView.image = imagesArray[indexPath.row]
        return cell
    }
    
    func updateSumOfRatesLabel() {
        let total: Double = Double(kitchenRate + interiorRate + serviceRate)/3
        let totalRounded: Double = round(total * 10) / 10
        sumOfRatesLabel.text = "\(totalRounded)"
        totalRate = totalRounded
        if totalRounded <= 3 {
            sumOfRatesLabel.textColor = .systemRed
        } else if totalRounded <= 6 {
            sumOfRatesLabel.textColor = .systemYellow
        } else if totalRounded <= 9 {
            sumOfRatesLabel.textColor = .systemGreen
        } else if totalRounded <= 10 {
            sumOfRatesLabel.textColor = .green
        }
    }
    
    @objc private func didTapAddButton(_ sender: UIButton) {
        if #available(iOS 14, *) {
            var config = PHPickerConfiguration(photoLibrary: .shared())
            
            config.selectionLimit = 5
            config.filter = .images
            let vc = PHPickerViewController(configuration: config)
            vc.delegate = self
            present(vc, animated: true, completion: nil)
        } else {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .photoLibrary
            present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    @available(iOS 14, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            results.forEach { result in
                result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] reading, error in
                    DispatchQueue.main.async {
                        guard let self = self, let image = reading as? UIImage, error == nil else {
                            return
                        }
                        let lastIndexPath = IndexPath(row: self.imagesArray.count, section: 0)
                        self.imagesArray.append(image)
                        self.defaultImage.isHidden = true
                        self.collectionView.insertItems(at: [lastIndexPath])
                    }
                }
            }
        }
    }
    
    @objc private func didTapCheckButton() {
        fetchFilms() { [weak self] (result: Result<FilmsResponseDTO>) in
            switch result {
            case .success(let data):
                print(data)
                var resultAll: Set<String> = [] // not safe -> make Atomic
                let dispatchGroup = DispatchGroup()
                data.arr.forEach {
                    dispatchGroup.enter()
                    print("222 entered")
                    self?.fetchCharacter(url: $0.characters) { result in
                        print("222 leave")
                        resultAll.insert(result?.first ?? "")
                        dispatchGroup.leave()
                    }
                }
                dispatchGroup.notify(queue: .global()) {
                    print("222 all: \(resultAll)")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc private func didTapStarButton(_ sender: UIButton) {
        
        if sender.tag < 11 {
            kitchenRate = sender.tag
            updateSumOfRatesLabel()
            for tag in 1...sender.tag {
                if let button = view.viewWithTag(tag) as? UIButton
                {
                    button.setImage(UIImage(systemName: "star.fill"), for: .normal)
                }
            }
            guard sender.tag != 10 else {return}
            for tag in sender.tag + 1...10 {
                if let button = view.viewWithTag(tag) as? UIButton
                {
                    button.setImage(UIImage(systemName: "star"), for: .normal)
                }
            }
        } else if sender.tag > 10 && sender.tag < 21 {
            interiorRate = sender.tag - 10
            updateSumOfRatesLabel()
            for tag in 11...sender.tag {
                if let button = view.viewWithTag(tag) as? UIButton
                {
                    button.setImage(UIImage(systemName: "star.fill"), for: .normal)
                }
            }
            guard sender.tag != 20 else {return}
            for tag in sender.tag + 1...20 {
                if let button = view.viewWithTag(tag) as? UIButton
                {
                    button.setImage(UIImage(systemName: "star"), for: .normal)
                }
            }
        } else if sender.tag > 20 && sender.tag < 31 {
            serviceRate = sender.tag - 20
            updateSumOfRatesLabel()
            for tag in 21...sender.tag {
                if let button = view.viewWithTag(tag) as? UIButton
                {
                    button.setImage(UIImage(systemName: "star.fill"), for: .normal)
                }
            }
            guard sender.tag != 30 else {return}
            for tag in sender.tag + 1...30 {
                if let button = view.viewWithTag(tag) as? UIButton
                {
                    button.setImage(UIImage(systemName: "star"), for: .normal)
                }
            }
        }
    }
    
    @objc private func didTapSaveButton() {
        
        let restaurant = Restaurant()
        restaurant.name = nameTextField.text ?? "Без названия"
        restaurant.kitchenRate = kitchenRate
        restaurant.interiorRate = interiorRate
        restaurant.serviceRate = serviceRate
        restaurant.totalRate = totalRate
        if !imagesArray.isEmpty {
            restaurant.picture = imagesArray[0].jpegData(compressionQuality: 0.9)
        }
        try! realm.write {
            realm.add(restaurant)
        }
        navigationController?.popViewController(animated: true)
    }
    
    func setupButtons() {
        for tag in 1...30 {
            let button = UIButton()
            button.setImage(UIImage(systemName: "star"), for: .normal)
            button.tag = tag
            button.tintColor = .systemYellow
            button.translatesAutoresizingMaskIntoConstraints = false
            if tag < 11 {kitchenStackView.addArrangedSubview(button)}
            if tag > 10 && tag < 21 {interiorStackView.addArrangedSubview(button)}
            if tag > 20 && tag < 31 {serviceStackView.addArrangedSubview(button)}
            button.addTarget(self, action: #selector(didTapStarButton(_:)), for: .touchUpInside)
        }
    }
    
    func setupLayout() {
        
        let kitchenStackViewConstraints = [
            kitchenStackView.topAnchor.constraint(equalTo: kitchenLabel.bottomAnchor, constant: 5),
            kitchenStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            kitchenStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            kitchenStackView.heightAnchor.constraint(equalToConstant: 35)
        ]
        NSLayoutConstraint.activate(kitchenStackViewConstraints)
        
        let interiorStackViewConstraints = [
            interiorStackView.topAnchor.constraint(equalTo: interiorLabel.bottomAnchor, constant: 5),
            interiorStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            interiorStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            interiorStackView.heightAnchor.constraint(equalToConstant: 35)
        ]
        NSLayoutConstraint.activate(interiorStackViewConstraints)
        
        let serviceStackViewConstraints = [
            serviceStackView.topAnchor.constraint(equalTo: serviceLabel.bottomAnchor, constant: 5),
            serviceStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            serviceStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            serviceStackView.heightAnchor.constraint(equalToConstant: 35)
        ]
        NSLayoutConstraint.activate(serviceStackViewConstraints)
        
        let imageConstraints = [
            defaultImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            defaultImage.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
            defaultImage.heightAnchor.constraint(equalToConstant: 200),
            defaultImage.widthAnchor.constraint(equalToConstant: 280)
        ]
        if imagesArray.isEmpty {
            NSLayoutConstraint.activate(imageConstraints)
        }
        
        let collectionViewConstraints = [
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20),
            collectionView.heightAnchor.constraint(equalToConstant: 300)
        ]
        NSLayoutConstraint.activate(collectionViewConstraints)
        
        let addImagesButtonConstraints = [
            addImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addImageButton.bottomAnchor.constraint(equalTo: nameTextField.topAnchor, constant: -30),
            addImageButton.heightAnchor.constraint(equalToConstant: 30)
        ]
        NSLayoutConstraint.activate(addImagesButtonConstraints)
        
        let nameLabelConstraints = [
            nameLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.widthAnchor.constraint(equalToConstant: 90)
        ]
        NSLayoutConstraint.activate(nameLabelConstraints)
        
        let textFieldConstraints = [
            nameTextField.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            nameTextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 5),
            nameTextField.heightAnchor.constraint(equalToConstant: 30),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(textFieldConstraints)
        
        let totalLabelConstraints = [
            totalLabel.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -20),
            totalLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 85)
        ]
        NSLayoutConstraint.activate(totalLabelConstraints)
        
        let sumOfRatesLabelConstraints = [
            sumOfRatesLabel.leadingAnchor.constraint(equalTo: totalLabel.trailingAnchor, constant: 20),
            sumOfRatesLabel.centerYAnchor.constraint(equalTo: totalLabel.centerYAnchor),
            sumOfRatesLabel.widthAnchor.constraint(equalToConstant: 60)
        ]
        NSLayoutConstraint.activate(sumOfRatesLabelConstraints)
        
        let sumLabelConstraints = [
            sumLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -85),
            sumLabel.leadingAnchor.constraint(equalTo: sumOfRatesLabel.trailingAnchor, constant: 5),
            sumLabel.centerYAnchor.constraint(equalTo: sumOfRatesLabel.centerYAnchor)
        ]
        NSLayoutConstraint.activate(sumLabelConstraints)

        let scrollViewConstraints = [
            scrollView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            scrollView.bottomAnchor.constraint(equalTo: totalLabel.topAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(scrollViewConstraints)
        
        let contentViewConstraints = [
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 500)
        ]
        NSLayoutConstraint.activate(contentViewConstraints)
        
        let kitchenLabelConstraints = [
            kitchenLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            kitchenLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5)
        ]
        NSLayoutConstraint.activate(kitchenLabelConstraints)
        
        let interiorLabelConstraints = [
            interiorLabel.topAnchor.constraint(equalTo: kitchenStackView.bottomAnchor, constant: 10),
            interiorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5)
        ]
        NSLayoutConstraint.activate(interiorLabelConstraints)
        
        let serviceLabelConstraints = [
            serviceLabel.topAnchor.constraint(equalTo: interiorStackView.bottomAnchor, constant: 10),
            serviceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5)
        ]
        NSLayoutConstraint.activate(serviceLabelConstraints)
        
        let saveButtonConstraints = [
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        saveButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal) // priority
        NSLayoutConstraint.activate(saveButtonConstraints)
        
        let checkButtonConstraints = [
            checkButton.leadingAnchor.constraint(equalTo: saveButton.trailingAnchor, constant: 20),
            checkButton.centerYAnchor.constraint(equalTo: saveButton.centerYAnchor)
        ]
        NSLayoutConstraint.activate(checkButtonConstraints)
    }
}



struct FilmsResponseDTO: Codable {
    
    struct Film: Codable {
        let characters: [String]
        let title: String
        let releaseDate: String
        
        enum CodingKeys: String, CodingKey {
            case characters
            case title
            case releaseDate = "release_date"
        }
    }
    
    let arr: [Film]
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        case arr = "results"
        case count
    }
}


struct CharacterDTO: Codable {
    
    let films: [String]
    
    enum CodingKeys: String, CodingKey {
        case films
    }
}

enum ApiError: Error {
    case unknown
}

extension RestaurantViewController {
    func fetchFilms<T: Codable>(completion: @escaping (Result<T>) -> Void) {
        var resultURl = ""
        let host = "https://swapi.dev"
        let path: String? = "api/films"
        let params: [String: Any]? = nil
        
        resultURl.append(host)
        if let path = path {
            resultURl.append("/\(path)")
        }
        let request = Alamofire.request(resultURl, method: .get, parameters: params, headers: nil)
        request.responseJSON { response in
            
            guard
                response.result.isSuccess,
                let data = response.data
            else {
                print("Error while fetching tags: \(String(describing: response.result.error))")
                let error = response.result.error ?? ApiError.unknown
                completion(.failure(error))
                return
            }
            
            do {
                let responseJSON = response.result.value as? [String: Any]
                print(responseJSON)
                let dto = try JSONDecoder().decode(T.self, from: data)
                
                completion(.success(dto))
            } catch(let error) {
                print(error)
                completion(.failure(error))
            }
            
            
        }
    }
    
    func fetchCharacter(url: [String], completion: @escaping ([String]?) -> Void) {
        
        url.forEach { url in
            let request = Alamofire.request(url, method: .get, headers: nil)
            request.responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching tags: \(String(describing: response.result.error))")
                    completion(nil)
                  return
                }
                guard let responseJSON = response.result.value as? [String: AnyObject],
                      let name = responseJSON["name"] as? String else {
                          print("Error")
                          completion(nil)
                          return
                      }
//                print(name)
            }
        }
//        print(names)
        completion(nil)
    }
}

