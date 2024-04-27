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
    
    var did_completation_Focus: ((Int?)->Void)? = nil
    
    override var isSelected: Bool {
      didSet {
          self.contentView.backgroundColor = isSelected ?utils.UIColorFromRGBValue(red: 189, green: 0, blue: 54) : .clear
      }
    }
    
    
    
    override func shouldUpdateFocus(in context: UIFocusUpdateContext) -> Bool {
        // Condition
        return true
    }
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        // Condition
        self.did_completation_Focus?(context.nextFocusedView?.tag)
    }
}
