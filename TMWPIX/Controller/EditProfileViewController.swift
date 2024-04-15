//
//  EditProfileViewController.swift
//  TMWPIX
//
//  Created by Apple on 03/08/2022.
//

import Foundation
import UIKit

class EditProfileViewController: TMWViewController, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var ProfilePic: UIImageView!
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var stateText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    var isAddProfile = false
    var userProfile : UserProfile = UserProfile()
    var state:String? = "normal"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
        ProfilePic.layer.borderWidth = 1.0
        ProfilePic.layer.masksToBounds = false
        ProfilePic.layer.borderColor = UIColor.white.cgColor
        ProfilePic.layer.cornerRadius = ProfilePic.frame.size.width / 2
        ProfilePic.clipsToBounds = true
        
    }


    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isAddProfile == false {
            self.nameText.text = userProfile.name
            self.passwordText.text = userProfile.senha
            if userProfile.infantil == 1 {
                stateSelection(stateSelection: "infantil")
            }else{
                stateSelection(stateSelection: "normal")
            }
            
        }
       scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    @IBAction func genderBtnTapped(_ sender: Any) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let popupVC = storyboard.instantiateViewController(withIdentifier: "GenderViewController") as! GenderViewController
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        popupVC.delegate = self
        let pVC = popupVC.popoverPresentationController
        pVC?.sourceRect = CGRect(x: 100, y: 100, width: 1, height: 1)
        present(popupVC, animated: true, completion: nil)
    }
    
    @IBAction func ViewDismissed(_ sender: Any) {
        self.view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func edit_addProfile(_ sender: Any) {
        //check name, password, state
        if (nameText.text == "" || passwordText.text == ""){
            utils.showDestructiveAlert(message: "name or password is missing", presentationController: self)
        }else{
            var tempState = 1
            if state == "normal" {
                tempState = 0
            }
            
            if isAddProfile == true {
                // call add profile api
                ProfileAPI.addProfile(status: "ativo", infantil: tempState, password: passwordText.text!, name: nameText.text!, delegate: self)
                // take name, password and state to send to api
            }else{
                //call edit profile api
                ProfileAPI.editProfile(status: "ativo", infantil: tempState, password: passwordText.text!, name: nameText.text!, delegate: self)
            }
        }
        
    }
    
    
    //TextField Delegate Method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension EditProfileViewController {
    func addProfileResponseHandler(errorMessage:String){
        if errorMessage == "" {
            self.ViewDismissed(NSNull.self)
        }
    }
    func editProfileResponseHandler(errorMessage:String){
        if errorMessage == "" {
            self.ViewDismissed(NSNull.self)
        }
    }
}
extension EditProfileViewController {
    func stateSelection(stateSelection:String){
        if stateSelection == "normal" {
            state = "normal"
            stateText.text = "Normal"
            
        }else{
            state = "infantil"
            stateText.text = "Infantil"
        }
    }
}



