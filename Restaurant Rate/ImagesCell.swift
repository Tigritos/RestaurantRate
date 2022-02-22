//
//  ImagesCell.swift
//  Restaurant Rate
//
//  Created by Tigran Oganisyan on 27.01.2022.
//

import Foundation
import UIKit

class ImagesCell: UICollectionViewCell {
    
    
    static let identifier = "ImagesCell"
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
    
}
