//
//  OptionViewController.swift
//  TMWPIX
//
//  Created by Apple on 22/08/2022.
//

import UIKit
import Alamofire
import Foundation


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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.lbl_Name.text = "Nome: \(appDelegate.dic_UserData?.name ?? "")"
        self.lbl_Endereco.text = "Endereço:"
        self.lbl_Email.text = "E-mail: \(appDelegate.dic_UserData?.email ?? "")"
        self.lbl_Plano.text = "Plano: \(appDelegate.dic_UserData?.plano ?? "")"
        self.lbl_nesse.text = "Alugueis grátis restantes nesse mês: \(appDelegate.dic_UserData?.aluguelGratisRestante ?? 0)"
        self.lbl_device.text = "Dispositivo: \(utils.getDeviceId())"
        
        self.change_Button_Status()
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
            self.callAPI_for_DeleteUser()
        }
    }
    
    func move_ToLoginScreen() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.present(nextViewController, animated:true, completion:nil)
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
    }

    //MARK: - API Call for Delete User
    func callAPI_for_DeleteUser() {
        self.loadingIndicator.startAnimating()
        let userInfo = UserInfo.getInstance()
        let str_clientID = "\(UserProfile.getInstance()?.client_id ?? 0)"

        let params = ["id": str_clientID]

        let strURL = "https://api.tmwpix.com/conta/cancelamentoapp"
        
        AF.request(strURL, method: .post, parameters: params).response { response in
            if let data = response.data {
                print(data)
                print(response.result)
                do {
                    let dictonary =  try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
                    debugPrint(dictonary)
                    self.loadingIndicator.stopAnimating()
                    let int_status = dictonary?["status"] as? Int ?? 0
                    let str_msg = dictonary?["message"] as? Int ?? 0
                    let bool_error = dictonary?["error"] as? Bool ?? false
                    
                    var str_errorMessage = ""
                    if int_status == 200 {
                        str_errorMessage = "Você cancelou sua assinatura. Ela permanecerá ativa até \(str_msg)"
                    }
                    else {
                        str_errorMessage = "Algo errado... Tente novamente mais tarde..."
                    }
                    
                    let alert = UIAlertController(title: nil, message: str_errorMessage, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { actionn in
                        if int_status == 200 {
                            self.move_ToLoginScreen()
                        }
                    }))
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                        self.present(alert, animated: true, completion: nil)
                    }
                } catch let error as NSError {
                    print(error)
                    self.loadingIndicator.stopAnimating()
                }

            }
        }
        userInfo?.removeDic()
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
