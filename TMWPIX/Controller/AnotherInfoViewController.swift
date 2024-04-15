//
//  AnotherInfoViewController.swift
//  TMWPIX
//
//  Created by Apple on 02/08/2022.
//

import Foundation

import UIKit

class AnotherInfoViewController: TMWViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tfRua: UITextField!
    @IBOutlet weak var tfNumero: UITextField!
    @IBOutlet weak var tfBairro: UITextField!
    @IBOutlet weak var tfCep: UITextField!
    @IBOutlet weak var tfCidade: UITextField!
    @IBOutlet weak var tfEstado: UITextField!
    
    var nome = ""
    var cpf = ""
    var rg = ""
    var dataNasc = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        tfRua.attributedPlaceholder = NSAttributedString(
            string: "Rua, Av.",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        tfNumero.attributedPlaceholder = NSAttributedString(
            string: "Número",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        tfBairro.attributedPlaceholder = NSAttributedString(
            string: "Bairro",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        tfCep.attributedPlaceholder = NSAttributedString(
            string: "Cep",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        tfCidade.attributedPlaceholder = NSAttributedString(
            string: "Cidade",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        tfEstado.attributedPlaceholder = NSAttributedString(
            string: "UF",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])

    }

    
    @IBAction func viewDismissed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func moveToOtp(_ sender: Any) {
        if !validateFields() { return }
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "OtpViewController") as! OtpViewController
        
        nextViewController.nome = nome
        nextViewController.cpf = cpf
        nextViewController.rg = rg
        nextViewController.dataNasc = dataNasc
        nextViewController.rua = self.tfRua.text!
        nextViewController.numero = self.tfNumero.text!
        nextViewController.bairro = self.tfBairro.text!
        nextViewController.cep = self.tfCep.text!
        nextViewController.cidade = self.tfCidade.text!
        nextViewController.estado = self.tfEstado.text!
        
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
       scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.height + 200)
    }
    
    private func validateFields() -> Bool {
        if self.tfRua.text == "" {
            self.tfRua.becomeFirstResponder()
        } else if self.tfNumero.text == "" {
            self.tfNumero.becomeFirstResponder()
        } else if self.tfBairro.text == "" {
            self.tfBairro.becomeFirstResponder()
        } else if self.tfCep.text == "" {
            self.tfCep.becomeFirstResponder()
        } else if self.tfCidade.text == "" {
            self.tfCidade.becomeFirstResponder()
        } else if self.tfEstado.text == "" {
            self.tfEstado.becomeFirstResponder()
        } else {
            return true
        }
        return false
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
