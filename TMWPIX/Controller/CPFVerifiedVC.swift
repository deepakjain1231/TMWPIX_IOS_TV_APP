//
//  CPFVerifiedVC.swift
//  TMWPIXtvOS
//
//  Created by DEEPAK JAIN on 26/05/24.
//

protocol delegate_cpfVerified {
    func cpf_verified_play_moview(_ success: Bool)
}

import UIKit

class CPFVerifiedVC: UIViewController, UITextFieldDelegate {

    var delegate: delegate_cpfVerified?
    @IBOutlet weak var txt_cpf: UITextField!
    @IBOutlet weak var lbl_validation: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: - UITextField Delegate DataSource
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //MARK: - UIButton Action
    @IBAction func btn_cancel_Action(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btn_confirm_Action(_ sender: UIButton) {
        if let str_cpf = self.txt_cpf.text, str_cpf != "" {
            let cpf_pass = appDelegate.str_cpfValue
            if cpf_pass != "" {
                let last5 = cpf_pass.substring(from:cpf_pass.index(cpf_pass.endIndex, offsetBy: -5))
                
                if last5 == str_cpf {
                    self.lbl_validation.text = ""
                    self.dismiss(animated: true) {
                        self.delegate?.cpf_verified_play_moview(true)
                    }
                }
                else {
                    self.lbl_validation.text = "CPF incorreto"
                }
            }
        }
    }
    
    
}
