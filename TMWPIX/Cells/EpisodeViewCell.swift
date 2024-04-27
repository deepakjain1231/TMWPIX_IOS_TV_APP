//
//  EpisodeViewCell.swift
//  TMWPIX
//
//  Created by Apple on 24/08/2022.
//

import Foundation


import UIKit

class EpisodeViewCell: UICollectionViewCell {
   
    @IBOutlet weak var episodeNumber: UILabel!
    var did_completation_Focus: ((Int?)->Void)? = nil
    
    
    override class func awakeFromNib() {
        super.awakeFromNib()
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
