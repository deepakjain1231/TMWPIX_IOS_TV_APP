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
    
    var did_completation_Focus: ((Int?)->Void)? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func shouldUpdateFocus(in context: UIFocusUpdateContext) -> Bool {
        // Condition
        return true
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        // Condition
        //self.did_completation_Focus?(context.nextFocusedView?.tag)
        
        if isFocused {
            self.did_completation_Focus?(context.nextFocusedView?.tag)
        }
        else {
            self.backgorundView.layer.borderWidth = 1
            self.backgorundView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        }
    }
    
}
