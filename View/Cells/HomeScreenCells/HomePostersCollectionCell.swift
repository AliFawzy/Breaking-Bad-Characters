//
//  HomePostersCollectionCell.swift
//  BreakingBadCharacters
//
//  Created by ALY on 24/06/2021.
//

import UIKit

class HomePostersCollectionCell: UICollectionViewCell {

    @IBOutlet weak var poster: UIImageView!{
        didSet{
            poster.layer.cornerRadius = 15
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    func configure(with model: HomeCharacterModel) {
        guard let url = model.img else{ return }
        poster.sd_setImage(with: URL(string: url), placeholderImage: #imageLiteral(resourceName: "logo"))
    }

}
