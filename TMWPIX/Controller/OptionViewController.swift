//
//  OptionViewController.swift
//  TMWPIX
//
//  Created by Apple on 22/08/2022.
//

import Foundation

import UIKit

class OptionViewController: TMWViewController {


    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
