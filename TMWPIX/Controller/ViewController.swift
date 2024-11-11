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
    @IBOutlet weak var stack_mobile: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkIfLoggedIn()
        self.hideKeyboardWhenTappedAround()
        self.btn_login.setTitle("Logar", for: .normal)
        self.btn_register.setTitle("Cadastro", for: .normal)
        self.setupMobileNumber(contactdata: nil)
        LoginAPI.getMobileNumbers_Data(delegate: self)
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
                self.openHomeScreen(animated: false, profile_data: nil)
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
    

   //MARK: - UITextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.trigger_login_Action()
        return true
    }
    
    
}

extension ViewController {
    
    func openHomeScreen(animated: Bool, profile_data: [UserProfile]?){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        nextViewController.isFromLogin = animated
        
        if let dic_profileData = profile_data {
            nextViewController.userProfiles = dic_profileData
        }
        
        self.present(nextViewController, animated:animated, completion:nil)
    }
    
    func loginResponseHandler(userInfo: UserInfo, errorMessage: String, profileData:[UserProfile]?){
        self.loadingIndicator.stopAnimating()
        if userInfo.isLogin {
            self.txt_token.text = ""
            openHomeScreen(animated: true, profile_data: profileData)
        }else{
            utils.showDestructiveAlert(message: errorMessage, presentationController: self)
        }
    }
    
    
    func contact_information_ResponseHandler(contactInfo: Contact_Info_Model, errorMessage: String) {
        appDelegate.contactInfoData = contactInfo
        self.setupMobileNumber(contactdata: contactInfo)
    }
    
    func setupMobileNumber(contactdata: Contact_Info_Model?) {
        self.remove_existing_Label()

        if contactdata?.contactInfo?.count != 0 {
            if let arr_Data = contactdata?.contactInfo {
                self.setLabelInStack("Entre em contato com a TMW Telecom pelos Fones:")
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
        lbl_number.font = UIFont.systemFont(ofSize: 15)
        lbl_number.textColor = .white
        lbl_number.textAlignment = .center
        lbl_number.numberOfLines = 1
        self.stack_mobile.addArrangedSubview(lbl_number)
    }
    
    func addStaticData() {
        self.setLabelInStack("Entre em contato com a TMW Telecom pelos Fones:")
        self.setLabelInStack("0800 648 3961")
        self.setLabelInStack("(51) 3656 7200")
    }
}
