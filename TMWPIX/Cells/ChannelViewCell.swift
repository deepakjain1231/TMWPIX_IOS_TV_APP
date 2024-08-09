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
    
    @IBOutlet weak var img_focus: UIImageView!
    
    var did_completation_Focus: ((Int?)->Void)? = nil
    
    override var isSelected: Bool {
      didSet {
          self.backView.backgroundColor = isSelected ?.systemBlue: .clear

      }
    }
    
    
//    override var preferredFocusEnvironments: [UIFocusEnvironment]{
//        // Condition
//    }
    override func shouldUpdateFocus(in context: UIFocusUpdateContext) -> Bool {
        // Condition
        return true
    }
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        
        if isFocused {
            self.did_completation_Focus?(context.nextFocusedView?.tag)
        }
        else {
            self.backView.backgroundColor = .clear
        }
        
        // Condition
           // self.did_completation_Focus?(context.nextFocusedView?.tag)
    }
}

