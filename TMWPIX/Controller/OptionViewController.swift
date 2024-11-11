//
//  OptionViewController.swift
//  TMWPIX
//
//  Created by Apple on 22/08/2022.
//

import Foundation

import UIKit

class OptionViewController: TMWViewController, delegate_change_status {

    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_Endereco: UILabel!
    @IBOutlet weak var lbl_Email: UILabel!
    @IBOutlet weak var lbl_Plano: UILabel!
    @IBOutlet weak var lbl_nesse: UILabel!
    @IBOutlet weak var lbl_device: UILabel!
    @IBOutlet weak var btn_reabilitar: UIButton!
    
    @IBOutlet weak var btn_Back: UIButton!
    @IBOutlet weak var btn_profile: UIButton!
    
    @IBOutlet weak var view_main_POPupBG: UIView!
    @IBOutlet weak var view_main_POPupInnerBG: UIView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var btn_close: UIButton!
    @IBOutlet weak var stack_mobile: UIStackView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view_main_POPupBG.isHidden = true
        
        self.lbl_Name.text = "Nome: \(appDelegate.dic_UserData?.name ?? "")"
        self.lbl_Endereco.text = "Endereço:"
        self.lbl_Email.text = "E-mail: \(appDelegate.dic_UserData?.email ?? "")"
        self.lbl_Plano.text = "Plano: \(appDelegate.dic_UserData?.plano ?? "")"
        self.lbl_nesse.text = "Alugueis grátis restantes nesse mês: \(appDelegate.dic_UserData?.aluguelGratisRestante ?? 0)"
        self.lbl_device.text = "Dispositivo: \(utils.getDeviceId())"
        
        self.change_Button_Status()
        self.setupMobileNumber()
    }
    
    func change_Button_Status(){
        let userInfo = UserInfo.getInstance()
        if userInfo?.podeAlugar == true {
            //Button Color Red
            self.btn_reabilitar.setTitle("Reabilitar opção de aluguel", for: .normal)
            self.btn_reabilitar.backgroundColor = UIColor().hexStringToUIColor(hex: "#DE003F")
        }
        else {
            //Button Color Gray
            self.btn_reabilitar.setTitle("Desabilitar opção de aluguel", for: .normal)
            self.btn_reabilitar.backgroundColor = UIColor().hexStringToUIColor(hex: "#DE003F").withAlphaComponent(0.6)
        }
    }
    
    override var preferredFocusedView: UIView? {
        get {
            return self.btn_profile
        }
    }
    
    @IBAction func viewDismissed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func exitAccountTapped(_ sender: Any) {
        let userInfo = UserInfo.getInstance()
        if (userInfo?.isLogin == true){
            userInfo?.removeUser()
            // dismiss all presented view controllers until we have login screen again
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.present(nextViewController, animated:true, completion:nil)
        }
    }
    
    @IBAction func close_an_AccountTapped(_ sender: Any) {
        let userInfo = UserInfo.getInstance()
        if (userInfo?.isLogin == true) {
            
            if (appDelegate.dic_UserData?.type ?? "").trimed().lowercased() == "pagante" {
                self.openPopup_forConfirmation()
            }
            else {
                //Showing Popup
                self.openPopup()
            }
            
        }
    }
    
    @IBAction func openProfilesScreen(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    @IBAction func openChangeRentalStatus(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChangeRentalStatusViewController") as! ChangeRentalStatusViewController
        nextViewController.delegate = self
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    func change_status_check(success: Bool) {
        self.change_Button_Status()
        if success {
            let userInfo = UserInfo.getInstance()
            userInfo?.deleteUser()
            // dismiss all presented view controllers until we have login screen again
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.present(nextViewController, animated:true, completion:nil)
        }
    }
    
    
    //MARK: - CODE FOR CLOSE ACCOUNT POPUP
    func openPopup() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let popupVC = storyBoard.instantiateViewController(withIdentifier: "ContactInfoDialouge") as! ContactInfoDialouge
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        let pVC = popupVC.popoverPresentationController
        pVC?.sourceRect = CGRect(x: 100, y: 100, width: 1, height: 1)
        present(popupVC, animated: true, completion: nil)
    }
    
    //MARK: - CODE FOR CLOSE ACCOUNT POPUP
    func openPopup_forConfirmation() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let popupVC = storyBoard.instantiateViewController(withIdentifier: "AlertActionDialouge") as! AlertActionDialouge
        popupVC.delegate = self
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        let pVC = popupVC.popoverPresentationController
        pVC?.sourceRect = CGRect(x: 100, y: 100, width: 1, height: 1)
        present(popupVC, animated: true, completion: nil)
        
        
        //        objVC.view.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//        self.present(objVC, animated:false, completion:nil)
//        self.addChild(objVC)
//        objVC.view.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//        self.view.addSubview((objVC.view)!)
//        objVC.didMove(toParent: self)
        
//        self.setupMobileNumber()
//        self.view_main_POPupBG.isHidden = false
//        self.view_main_POPupBG.backgroundColor = UIColor.black.withAlphaComponent(0.0)
//        self.view_main_POPupBG.backgroundColor = .clear
//        self.view_main_POPupInnerBG.transform = CGAffineTransform.init(scaleX: 0.001, y: 0.001)
//        self.perform(#selector(show_animation), with: nil, afterDelay: 0.1)
    }

    @objc func show_animation() {
        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            self.view_main_POPupInnerBG.transform = .identity
            self.view_main_POPupBG.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            self.view.layoutIfNeeded()
        }) { (success) in
            self.setNeedsFocusUpdate()
        }
    }
        
    func clkToClose(_ is_Action: Bool) {
        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            self.view_main_POPupInnerBG.transform = CGAffineTransform.init(scaleX: 0.001, y: 0.001)
            self.view_main_POPupBG.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.view.layoutIfNeeded()
        }) { (success) in
            self.view_main_POPupBG.isHidden = true
        }
    }

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
