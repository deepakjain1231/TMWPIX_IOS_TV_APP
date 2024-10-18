//
//  RentalDetailViewController.swift
//  TMWPIX
//
//  Created by Apple on 04/08/2022.
//

protocol delegate_change_status {
    func change_status_check(success: Bool)
}

import UIKit
import Foundation


class ChangeRentalStatusViewController: TMWViewController {
    
    var delegate: delegate_change_status?
    
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
        let str_tokenText = (tokenText.text ?? "").trimed()
        let userInfo = UserInfo.getInstance()
        if str_tokenText == "" {
            //show alert to enter password or token
            utils.showDestructiveAlert(message: "Por favor, digite o nome de usuário", presentationController: self)
        }
        else if str_tokenText != userInfo?.token {
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
        self.delegate?.change_status_check(success: true)
        dismiss(animated: true, completion: nil)
        
    }
    func disableAluguelResponseHandler(errorMessage: String){
        let userInfo = UserInfo.getInstance()
        userInfo?.podeAlugar = false
        userInfo?.saveUserInfo()
        self.delegate?.change_status_check(success: true)
        dismiss(animated: true, completion: nil)
    }
}
