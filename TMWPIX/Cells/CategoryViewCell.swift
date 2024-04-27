//
//  CategoryViewCell.swift
//  TMWPIX
//
//  Created by Apple on 25/08/2022.
//

import Foundation

import UIKit

class CategoryViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryName: UILabel!
    var did_completation_Focus: ((Int?)->Void)? = nil
    
    override var isSelected: Bool {
      didSet {
          self.categoryName.textColor = isSelected ?.systemOrange : .white
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
