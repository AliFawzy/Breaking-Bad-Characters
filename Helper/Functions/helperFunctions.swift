
//
//  helperFunctions.swift
//  BreakingBadCharacters
//
//  Created by ALY on 24/06/2021.
//

import Foundation
import UIKit


class  circleImageView : UIImageView {
    override func layoutSubviews() {
       // self.layer.borderWidth = 2.5
        self.layer.masksToBounds = false
       // self.layer.borderColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
        self.layer.cornerRadius = self.frame.size.height/2
        self.clipsToBounds = true
    }
}
