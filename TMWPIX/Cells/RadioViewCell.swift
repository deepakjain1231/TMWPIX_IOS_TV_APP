//
//  RadioViewCell.swift
//  TMWPIX
//
//  Created by Apple on 18/08/2022.
//

import Foundation


import UIKit

class RadioViewCell: UICollectionViewCell {
   
    @IBOutlet weak var ChannelText: UILabel!
    
    override var isSelected: Bool {
      didSet {
          self.contentView.backgroundColor = isSelected ?utils.UIColorFromRGBValue(red: 189, green: 0, blue: 54) : .clear
      }
    }
    
}
