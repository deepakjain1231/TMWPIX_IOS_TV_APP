//
//  PinkButtons.swift
//  TMWPIX
//
//  Created by Apple on 01/08/2022.
//

import Foundation
import UIKit

public class buttonz: UIButton {


    required public init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)

        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1

    }

}
