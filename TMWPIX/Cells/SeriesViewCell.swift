//
//  SeriesViewCell.swift
//  TMWPIX
//
//  Created by Apple on 05/08/2022.
//

import Foundation
import UIKit

class SeriesViewCell: UICollectionViewCell {
    @IBOutlet weak var SeriesImage: UIImageView!
    @IBOutlet weak var StarImage: UIImageView!
    
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

