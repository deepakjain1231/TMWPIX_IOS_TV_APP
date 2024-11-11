//
//  AlertActionDialouge.swift
//  TMWPIXtvOS
//
//  Created by DEEPAK JAIN on 11/11/24.
//

import UIKit

class AlertActionDialouge: UIViewController {
    
    var delegate: delegate_change_status?
    @IBOutlet weak var view_main: UIView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var btn_yes: UIButton!
    @IBOutlet weak var btn_cancel: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view_main.transform = CGAffineTransform.init(scaleX: 0.001, y: 0.001)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        self.view.backgroundColor = .clear
        self.perform(#selector(show_animation), with: nil, afterDelay: 0.1)
    }
    
    @objc func show_animation() {
        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            self.view_main.transform = .identity
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            self.view.layoutIfNeeded()
        }) { (success) in
        }
    }
    
    func clkToClose(_ is_Action: Bool) {
        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            self.view_main.transform = CGAffineTransform.init(scaleX: 0.001, y: 0.001)
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.view.layoutIfNeeded()
        }) { (success) in
            self.dismiss(animated: true) {
                if is_Action {
                    self.delegate?.change_status_check(success: true)
                }
            }
        }
    }
    
    override var preferredFocusedView: UIView? {
        get {
            return self.btn_yes
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - UIButton Action
    @IBAction func btn_yes_action(_ sender: UIButton) {
        self.clkToClose(true)
    }
    
    @IBAction func btn_cancel_action(_ sender: UIButton) {
        self.clkToClose(false)
    }
}

