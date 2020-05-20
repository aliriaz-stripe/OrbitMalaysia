//
//  RoundedViews.swift
//  OrbitMalaysia
//
//  Created by Martin Parker on 17/05/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import UIKit

class RoundedButton : UIButton {
   override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
    }
}
class RoundedGrayButton : UIButton {
   override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.gray.cgColor
    layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        layer.shadowOpacity = 0.5
    }
}
class RoundedCartButton : UIButton{
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 6.5
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1.0
        layer.masksToBounds = true
    }
}
class RoundedGrayButton2 : UIButton {
   override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.shadowOpacity = 0.5
    }
}



class RoundedShadowView : UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
     //   layer.shadowOpacity = 0.1
        
    }
}
class RoundedGrayShadowView : UIView{
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.shadowOpacity = 0.5
        layer.cornerRadius = 5
      
    }
}


class RoundedLabelView : UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
    }
}

class RoundedImageView : UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
    }
}

