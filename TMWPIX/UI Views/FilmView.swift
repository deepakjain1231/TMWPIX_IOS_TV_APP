//
//  FilmView.swift
//  TMWPIX
//
//  Created by Apple on 04/08/2022.
//

import Foundation

import UIKit

@IBDesignable
class FilmView: UIView {

    
}

extension UIView {
    public func addViewBorder(borderColor:CGColor,borderWith:CGFloat,borderCornerRadius:CGFloat){
           self.layer.borderWidth = borderWith
           self.layer.borderColor = borderColor
           self.layer.cornerRadius = borderCornerRadius

       }
    

    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
}
