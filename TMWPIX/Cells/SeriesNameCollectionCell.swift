//
//  SeriesNameCollectionCell.swift
//  TMWPIXtvOS
//
//  Created by DEEPAK JAIN on 12/06/24.
//

import UIKit

class SeriesNameCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var view_Base: UIView!
    @IBOutlet weak var lbl_Title: UILabel!
    
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
