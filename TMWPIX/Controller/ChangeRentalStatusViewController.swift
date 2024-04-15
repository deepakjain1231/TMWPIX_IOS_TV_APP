//
//  RentalDetailViewController.swift
//  TMWPIX
//
//  Created by Apple on 04/08/2022.
//

import Foundation

import Foundation

import UIKit

class ChangeRentalStatusViewController: TMWViewController {
    @IBOutlet weak var tokenText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    
    @IBAction func viewDismissed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func confirmTapped(_ sender: Any) {
        //call api and use data from text field
        let userInfo = UserInfo.getInstance()
        if(tokenText.text == ""){
            //show alert to enter password or token
            utils.showDestructiveAlert(message: "Por favor, digite o nome de usuário", presentationController: self)
        }else if(tokenText.text != userInfo?.token){
            //show alert to enter password or token
            utils.showDestructiveAlert(message: "Acesso incorreto, favor digitar novamente", presentationController: self)
        }else{
            //api call to take confirmation on rental status
            let userinfo = UserInfo.getInstance()
            if (userinfo?.podeAlugar == false){
                //call enable api
                ConfigAPI.enableAluguel(delegate: self)
            }else{
                //call disable api
                ConfigAPI.disableAluguel(delegate: self)
            }
        }
    }
}

extension ChangeRentalStatusViewController {
    func enableAluguelResponseHandler(errorMessage: String){
        let userInfo = UserInfo.getInstance()
        userInfo?.podeAlugar = true
        userInfo?.saveUserInfo()
        
    }
    func disableAluguelResponseHandler(errorMessage: String){
        let userInfo = UserInfo.getInstance()
        userInfo?.podeAlugar = false
        userInfo?.saveUserInfo()
    }
}
