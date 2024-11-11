//
//  ContactInfoDialouge.swift
//  TMWPIXtvOS
//
//  Created by DEEPAK JAIN on 11/11/24.
//

import UIKit

class ContactInfoDialouge: UIViewController {
    
    @IBOutlet weak var view_main: UIView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var btn_close: UIButton!
    @IBOutlet weak var stack_mobile: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupMobileNumber()
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
            self.dismiss(animated: true)
        }
    }
    
    override var preferredFocusedView: UIView? {
        get {
            return self.btn_close
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
    
    func setupMobileNumber() {
        self.remove_existing_Label()
        
        if appDelegate.contactInfoData?.contactInfo?.count != 0 {
            if let arr_Data = appDelegate.contactInfoData?.contactInfo {
                self.setLabelInStack("Entre em contato com alguns dos nossos telefones:")
                for dic_phone in arr_Data {
                    let str_number = "(\(dic_phone.ddd ?? "")) \(dic_phone.numero ?? "")"
                    self.setLabelInStack(str_number)
                }
            }
            else {
                self.addStaticData()
            }
        }
        else {
            self.addStaticData()
        }
    }
    
    func remove_existing_Label() {
        let labelss = self.stack_mobile.arrangedSubviews.filter {$0 is UILabel}
        for label in labelss {
            self.stack_mobile.removeArrangedSubview(label)
            label.removeFromSuperview()
        }
    }
    
    func setLabelInStack(_ str_Text: String) {
        let lbl_number = UILabel()
        lbl_number.text = str_Text
        lbl_number.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.medium)
        lbl_number.textColor = .white
        lbl_number.textAlignment = .left
        lbl_number.numberOfLines = 1
        self.stack_mobile.addArrangedSubview(lbl_number)
    }
    
    func addStaticData() {
        self.setLabelInStack("Entre em contato com alguns dos nossos telefones:")
        self.setLabelInStack("0800 648 3961")
        self.setLabelInStack("(51) 3656 7200")
    }
    
    
    
    // MARK: - UIButton Action
    @IBAction func btn_close_action(_ sender: UIButton) {
        self.clkToClose(false)
    }
}

