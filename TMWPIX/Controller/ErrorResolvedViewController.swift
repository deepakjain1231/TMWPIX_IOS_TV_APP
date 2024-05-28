//
//  ErrorResolvedViewController.swift
//  TMWPIX
//
//  Created by Apple on 04/08/2022.
//

import Foundation

import UIKit

class ErrorResolvedViewController: TMWViewController {
    
    var str_Error = ""
    var screenFrom = ""
    var superVC: UIViewController?
    
    @IBOutlet weak var tfError: UITextField!
    @IBOutlet weak var lbl_msg: UILabel!
    @IBOutlet weak var view_msg_bg: UIView!
    
    var FilmID:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view_msg_bg.isHidden = true
        
        if self.screenFrom == "error_resolved" {
            self.tfError.isHidden = true
            self.view_msg_bg.isHidden = false
            self.lbl_msg.text = str_Error
            self.lbl_msg.textColor = .black
        }
    }
    
    
    @IBAction func viewDismissed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func errorResolvedTapped(_ sender: Any) {
        if self.screenFrom == "error_resolved" {
            dismiss(animated: true, completion: nil)
        }
        else {
            if (tfError.text != "") {
                loadingIndicator.startAnimating()
                FilmAPI.reportError(delegate: self) { dic_response in
                    DispatchQueue.main.async {
                        if let dic_error = dic_response?["error"] as? [String: Any] {
                            if (dic_error["code"] as? Int ?? 0) == 0 {
                                let str_msg =  dic_error["message"] as? String ?? ""
                                if str_msg != "" {
                                    let alert = UIAlertController(title: nil, message: str_msg, preferredStyle: UIAlertController.Style.alert)
                                    alert.addAction(UIAlertAction.init(title: "OK", style: .default))
                                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                                        self.superVC?.present(alert, animated: true, completion: nil)
                                    }
                                }
                            }
                        }
                    }
                }
            }
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
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
            self.dismiss(animated: true)
        }
    }
}
