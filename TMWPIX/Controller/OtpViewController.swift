//
//  OtpViewController.swift
//  TMWPIX
//
//  Created by Apple on 02/08/2022.
//

import Foundation

import UIKit

class OtpViewController: TMWViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var tfPlano: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfCreditNumber: UITextField!
    @IBOutlet weak var tfCreditMonth: UITextField!
    @IBOutlet weak var tfCreditYear: UITextField!
    @IBOutlet weak var tfCvv: UITextField!
    
    var nome = ""
    var cpf = ""
    var rg = ""
    var dataNasc = ""
    var rua = ""
    var numero = ""
    var bairro = ""
    var cep = ""
    var cidade = ""
    var estado = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        tfPlano.attributedPlaceholder = NSAttributedString(
            string: "Plano",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        tfEmail.attributedPlaceholder = NSAttributedString(
            string: "E-Mail",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        tfCreditNumber.attributedPlaceholder = NSAttributedString(
            string: "Número do Cartão",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        tfCreditMonth.attributedPlaceholder = NSAttributedString(
            string: "Validade Mês",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        tfCreditYear.attributedPlaceholder = NSAttributedString(
            string: "Validade Ano",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        tfCvv.attributedPlaceholder = NSAttributedString(
            string: "Validade Ano",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])

    }
    
    override func viewDidAppear(_ animated: Bool) {
       scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 2)
    }

    @IBAction func viewDismissed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerUser(_ sender: Any) {
        if !validateFields() { return }
        
        let params = ["nome" : nome,
                      "cpf" : cpf,
                      "rg" : rg,
                      "dataNasc" : dataNasc,
                      "rua" : rua,
                      "numero" : numero,
                      "bairro" : bairro,
                      "cep" : cep,
                      "cidade" : cidade,
                      "estado" : estado,
                      "plano" : self.tfPlano.text!,
                      "email" : self.tfEmail.text!,
                      "creditNumber" : self.tfCreditNumber.text!,
                      "creditMonth" : self.tfCreditMonth.text!,
                      "creditYear" : self.tfCreditYear.text!,
                      "cvv" : self.tfCvv.text!]

    }
    
    private func validateFields() -> Bool {
        if self.tfPlano.text == "" {
            self.tfPlano.becomeFirstResponder()
        } else if self.tfEmail.text == "" {
            self.tfEmail.becomeFirstResponder()
        } else if self.tfCreditNumber.text == "" {
            self.tfCreditNumber.becomeFirstResponder()
        } else if self.tfCreditMonth.text == "" {
            self.tfCreditMonth.becomeFirstResponder()
        } else if self.tfCreditYear.text == "" {
            self.tfCreditYear.becomeFirstResponder()
        } else if self.tfCvv.text == "" {
            self.tfCvv.becomeFirstResponder()
        } else {
            return true
        }
        return false
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
    

}
