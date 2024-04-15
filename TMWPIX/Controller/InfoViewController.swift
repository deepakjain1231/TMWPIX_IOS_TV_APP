//
//  InfoViewController.swift
//  TMWPIX
//
//  Created by Apple on 25/08/2022.
//

import Foundation
import UIKit

class InfoViewController: TMWViewController {
    var desc: String = ""
    @IBOutlet weak var infoLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.infoLbl.text = desc
    }
    
#if TARGET_OS_IOS
    //======= Orientation Control ===========
    override var shouldAutorotate: Bool{
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .landscapeLeft
    }
    //======================================
#endif
    
    @IBAction func viewDismissed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
