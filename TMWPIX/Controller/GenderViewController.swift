//
//  GenderViewController.swift
//  TMWPIX
//
//  Created by Apple on 31/08/2022.
//

import Foundation

import UIKit

class GenderViewController: TMWViewController {
    var delegate: EditProfileViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func normalTapped(_ sender: Any) {
        delegate.stateSelection(stateSelection: "normal")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func infatileTapped(_ sender: Any) {
        delegate.stateSelection(stateSelection: "infantil")
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
