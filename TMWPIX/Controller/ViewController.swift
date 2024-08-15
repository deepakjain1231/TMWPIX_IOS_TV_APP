//
//  ViewController.swift
//  TMWPIX
//
//  Created by Apple on 01/08/2022.
//

import UIKit


class ViewController: TMWViewController, UITextFieldDelegate {
    
    @IBOutlet weak var img_logo: UIImageView!
    @IBOutlet weak var btn_login: buttonz!
    @IBOutlet weak var btn_register: buttonz!
    @IBOutlet weak var txt_token: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkIfLoggedIn()
        self.hideKeyboardWhenTappedAround()
        self.btn_login.setTitle("Logar", for: .normal)
        self.btn_register.setTitle("Cadastro", for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
#if TARGET_OS_IOS
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
#endif
        
        
    }
    func checkIfLoggedIn(){
        let userInfo = UserInfo.getInstance()
        if (userInfo?.isLogin == true){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.openHomeScreen(animated: false)
            }
        }
    }
    
    @IBAction func btn_Registraion_Action(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func btn_Login_Action(_ sender: Any) {
        self.trigger_login_Action()
    }
    
    func trigger_login_Action() {
        //        tokenText.text = "APP123"
        if(self.txt_token.text?.isEmpty == true) {
            //show please enter token error
            utils.showDestructiveAlert(message: "Por favor, digite o nome de usuário", presentationController: self)
            
        }else{
            //start network activity loader
            self.loadingIndicator.startAnimating()
            if let str_token = self.txt_token.text {
                LoginAPI.getLoginFirstTimeData(token: str_token,delegate: self);
            }
        }
    }
    
    
//    override func viewDidAppear(_ animated: Bool) {
//        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height + 20)
//    }

   //MARK: - UITextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.trigger_login_Action()
        return true
    }
    
    
}

extension ViewController {
    func openHomeScreen(animated: Bool){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        nextViewController.isFromLogin = true
        self.present(nextViewController, animated:animated, completion:nil)
    }
    func loginResponseHandler(userInfo: UserInfo, errorMessage: String){
        self.loadingIndicator.stopAnimating()
        if userInfo.isLogin {
            self.txt_token.text = ""
            openHomeScreen(animated: true)
        }else{
            utils.showDestructiveAlert(message: errorMessage, presentationController: self)
        }
        
    }
}
