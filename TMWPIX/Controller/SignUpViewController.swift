//
//  SignUpViewController.swift
//  TMWPIX
//
//  Created by Apple on 02/08/2022.
//

import Foundation

import UIKit

class SignUpViewController: TMWViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txt_Nome: UITextField!
    @IBOutlet weak var txt_CPF: UITextField!
    @IBOutlet weak var txt_RG: UITextField!
    @IBOutlet weak var tfDataNasc: UITextField!

    @IBOutlet weak var mainView: UIView!
    
    //    @IBOutlet weak var logoImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        self.txt_Nome.attributedPlaceholder = NSAttributedString(string: "Nome",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        self.txt_CPF.attributedPlaceholder = NSAttributedString(string: "CPF",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        self.txt_RG.attributedPlaceholder = NSAttributedString(string: "RG",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        tfDataNasc.attributedPlaceholder = NSAttributedString(string: "Data de Nascimento",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    }

    override func viewDidAppear(_ animated: Bool) {
       scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height + 200)
    }
    
    @IBAction func MovetoNextTapped(_ sender: Any) {
        if validateFields() {
            
            self.loadingIndicator.startAnimating()
            SignupAPI.registerNewUser(parameters: [:], delegate: self)
            return

            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AnotherInfoViewController") as! AnotherInfoViewController
            nextViewController.nome = self.txt_Nome.text!
            nextViewController.cpf = self.txt_CPF.text!
            nextViewController.rg = self.txt_RG.text!
            nextViewController.dataNasc = self.tfDataNasc.text!
            
            self.present(nextViewController, animated:true, completion:nil)
        }
    }
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func validateFields() -> Bool {
        if self.txt_Nome.text == "" {
            self.txt_Nome.becomeFirstResponder()
        } else if self.txt_CPF.text == "" {
            self.txt_CPF.becomeFirstResponder()
        } else if self.txt_RG.text == "" {
            self.txt_RG.becomeFirstResponder()
        } else if self.tfDataNasc.text == "" {
            self.tfDataNasc.becomeFirstResponder()
        } else {
            return true
        }
        return false
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
