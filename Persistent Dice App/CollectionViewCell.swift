//
//  CollectionViewCell.swift
//  Persistent Dice App
//
//  Created by Lubomir Olshansky on 28/04/2018.
//  Copyright © 2018 Lubomir Olshansky. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
     var diceView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        diceView = UIView(frame: contentView.frame)
        contentView.addSubview(diceView)
        self.contentView.backgroundColor = .white
    }
    
}
