//
//  CharacterCollectionViewCell.swift
//  BreakingBadCharacters
//
//  Created by ALY on 24/06/2021.
//

import UIKit

class CharacterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var NickNameLbl: UILabel!
    @IBOutlet weak var birthLbl: UILabel!
    @IBOutlet weak var occupationLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with model: HomeCharacterModel) {
        self.nameLbl.text = model.name
        self.NickNameLbl.text = model.nickname
        self.birthLbl.text = model.birthday
        self.occupationLbl.text = model.occupation.joined(separator: ",\n")
//        guard let url = model.img else{ return }
        posterImage.sd_setImage(with: URL(string: model.img), placeholderImage: #imageLiteral(resourceName: "logo"))
        
    }
}
