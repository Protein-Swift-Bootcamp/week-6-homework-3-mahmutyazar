//
//  CollectionViewCell.swift
//  New York Times App
//
//  Created by Mahmut Yazar on 10.01.2023.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        captionLabel.font = .systemFont(ofSize: 18, weight: .heavy)
        cellView.clipsToBounds = true
        cellView.layer.cornerRadius = 12
    }

}
