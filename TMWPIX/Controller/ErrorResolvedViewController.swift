//
//  ErrorResolvedViewController.swift
//  TMWPIX
//
//  Created by Apple on 04/08/2022.
//

import Foundation

import UIKit

class ErrorResolvedViewController: TMWViewController {
    
    @IBOutlet weak var tfError: UITextField!
    var FilmID:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    
    @IBAction func viewDismissed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func errorResolvedTapped(_ sender: Any) {
        if (tfError.text != "") {
            loadingIndicator.startAnimating()
            FilmAPI.reportError(delegate: self)
        }
    }
    
#if TARGET_OS_IOS
    override var shouldAutorotate: Bool{
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .landscapeLeft
    }
#endif
   

}

extension ErrorResolvedViewController {
    func handleErrorReport(success: Bool) {
        loadingIndicator.stopAnimating()
        dismiss(animated: true)
    }
}
