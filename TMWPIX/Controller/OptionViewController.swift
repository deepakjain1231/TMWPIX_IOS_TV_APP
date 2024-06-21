//
//  OptionViewController.swift
//  TMWPIX
//
//  Created by Apple on 22/08/2022.
//

import Foundation

import UIKit

class OptionViewController: TMWViewController {

    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_Endereco: UILabel!
    @IBOutlet weak var lbl_Email: UILabel!
    @IBOutlet weak var lbl_Plano: UILabel!
    @IBOutlet weak var lbl_nesse: UILabel!
    @IBOutlet weak var lbl_device: UILabel!
    
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
    
    @IBAction func openProfilesScreen(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    @IBAction func openChangeRentalStatus(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChangeRentalStatusViewController") as! ChangeRentalStatusViewController
        self.present(nextViewController, animated:true, completion:nil)
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
