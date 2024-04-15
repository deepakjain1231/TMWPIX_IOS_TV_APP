//
//  ChannelViewCell.swift
//  TMWPIX
//
//  Created by Apple on 03/08/2022.
//

import Foundation
import UIKit

class ChannelViewCell: UICollectionViewCell {
    @IBOutlet weak var ChannelImage: UIImageView!
    
    @IBOutlet weak var ChannelNumber: UILabel!
    @IBOutlet weak var backView: UIView!
    
    override var isSelected: Bool {
      didSet {
          self.backView.backgroundColor = isSelected ?.systemBlue: .clear

      }
    }
}

