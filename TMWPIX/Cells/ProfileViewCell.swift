//
//  ProfileViewCell.swift
//  TMWPIX
//
//  Created by Apple on 03/08/2022.
//

import Foundation

import UIKit
class ProfileViewCell: UICollectionViewCell {
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var actionImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var backgorundView: UIView!
    
    override var isSelected: Bool {
      didSet {
          self.backgorundView.backgroundColor = isSelected ?utils.UIColorFromRGBValue(red: 5, green: 23, blue: 41): utils.UIColorFromRGBValue(red: 2, green: 13, blue: 25)
          self.backgorundView.layer.borderWidth = 1
          
          self.backgorundView.layer.borderColor = isSelected ?UIColor(red:222/255, green:225/255, blue:227/255, alpha: 1).cgColor: UIColor(red:2/255, green:13/255, blue:5/255, alpha: 1).cgColor

      }
    }
    
}
