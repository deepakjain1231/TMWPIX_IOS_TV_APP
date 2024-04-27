//
//  ContentCollectionViewCell.swift
//  CustomCollectionLayout
//
//  Created by JOSE MARTINEZ on 09/01/2015.
//  Copyright (c) 2015 brightec. All rights reserved.
//

import UIKit

class ContentCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var ChannelImage: UIImageView!

    var did_completation_Focus: ((Int?, Int?)->Void)? = nil
    
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
        self.did_completation_Focus?(context.nextFocusedView?.tag, Int(context.nextFocusedView?.accessibilityHint ?? ""))
    }

}
