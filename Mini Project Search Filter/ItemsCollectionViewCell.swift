//
//  ItemsCollectionViewCell.swift
//  Mini Project Search Filter
//
//  Created by Gams-Mac on 05/01/2018.
//  Copyright © 2018 Gamma Rizkinata Satriana. All rights reserved.
//

import UIKit
import Kingfisher

class ItemsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var lblProduct: UILabel!
    @IBOutlet weak var lblPrice: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        
        
    }
}
