//
//  RemoveProfileViewCell.swift
//  TMWPIX
//
//  Created by Apple on 03/08/2022.
//

import Foundation

import UIKit
class RemoveProfileViewCell: UICollectionViewCell {
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var ProfileName: UILabel!
   
    @IBOutlet weak var backView: UIView!
    
    override var isSelected: Bool {
      didSet {
          self.backView.backgroundColor = isSelected ?utils.UIColorFromRGBValue(red: 5, green: 23, blue: 41): utils.UIColorFromRGBValue(red: 2, green: 13, blue: 25)
          self.backView.layer.borderWidth = 1
          self.backView.layer.borderColor = UIColor(red:2/255, green:13/255, blue:5/255, alpha: 1).cgColor

          self.backView.layer.borderColor = isSelected ?UIColor(red:222/255, green:225/255, blue:227/255, alpha: 1).cgColor: UIColor(red:2/255, green:13/255, blue:5/255, alpha: 1).cgColor

      }
    }
    
}
