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
    
    override var isSelected: Bool {
      didSet {
          self.categoryName.textColor = isSelected ?.systemOrange : .white
      }
    }
}
