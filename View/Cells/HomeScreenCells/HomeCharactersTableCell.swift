//
//  HomeCharactersTableCell.swift
//  BreakingBadCharacters
//
//  Created by ALY on 24/06/2021.
//

import UIKit
import SDWebImage


class HomeCharactersTableCell: UITableViewCell {

    @IBOutlet weak var contentview: UIView!{
        didSet{
            contentview.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func configure(with model: HomeCharacterModel) {
        self.characterName.text = model.name
        guard let url = model.img else{ return }
        characterImage.sd_setImage(with: URL(string: url), placeholderImage: #imageLiteral(resourceName: "logo"))
        
    }
}
