//
//  CollectionViewCell.swift
//  New York Times App
//
//  Created by Mahmut Yazar on 12.01.2023.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .white
        captionLabel.font = .systemFont(ofSize: 30, weight: .bold)
                        
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        if let attributes = layoutAttributes as? PinterestLayoutAttributes {
            imageHeightConstraint.constant = attributes.photoHeight
        }
    }
}
