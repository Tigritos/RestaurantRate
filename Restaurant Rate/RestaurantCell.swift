//
//  RestaurantCell.swift
//  Restaurant Rate
//
//  Created by Tigran Oganisyan on 27.01.2022.
//

import Foundation
import UIKit
import RealmSwift


class RestaurantCell: UITableViewCell {
    
    static let identifier = "RestaurantCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let totalRateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 35, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(image)
        contentView.addSubview(totalRateLabel)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(name: String, imageData: Data?, totalRate: Double) {
        nameLabel.text = name
        if let imageData = imageData {
            image.image = UIImage(data: imageData)
        } else {
            image.image = UIImage(systemName: "photo.fill")
        }
        totalRateLabel.text = "\(totalRate) / 10"
        if totalRate <= 3 {
            totalRateLabel.textColor = .systemRed
        } else if totalRate <= 6 {
            totalRateLabel.textColor = .systemYellow
        } else if totalRate <= 9 {
            totalRateLabel.textColor = .systemGreen
        } else if totalRate <= 10 {
            totalRateLabel.textColor = .green
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        image.image = nil
        totalRateLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageConstraints = [
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            image.widthAnchor.constraint(equalToConstant: 150),
            image.heightAnchor.constraint(equalToConstant: 150)
        ]
        NSLayoutConstraint.activate(imageConstraints)
        
        let nameConstraints = [
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            nameLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 5),
            nameLabel.widthAnchor.constraint(equalTo: image.widthAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 35)
        ]
        NSLayoutConstraint.activate(nameConstraints)
        
        let totalRateConstraints = [
            totalRateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            totalRateLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 50),
            totalRateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        NSLayoutConstraint.activate(totalRateConstraints)

        
    }
}
