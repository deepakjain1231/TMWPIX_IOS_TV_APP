//
//  ProfileViewController.swift
//  TMWPIX
//
//  Created by Apple on 03/08/2022.
//

import UIKit
import Foundation


enum ProfileState {
    case profileList
    case editProfileList
    case deleteProfileList
}

class ProfileViewController: TMWViewController, UITextFieldDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBOutlet weak var view_Header_title: UIView!
    @IBOutlet weak var view_Header_title_Short: UIView!
    
    
    var isProfileState = ProfileState.profileList
    var isFromLogin = false
    var userProfiles : [UserProfile] = []
    var sel_index = -1
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view_Header_title.isHidden = true
        self.view_Header_title_Short.isHidden = false
        self.passwordView.isHidden = true
        getProfileList()
        
//        tfPassword.becomeFirstResponder()
        tfPassword.delegate = self
        
        
    }
    
    @IBAction func ViewDismissed(_ sender: Any) {
        if isProfileState != .profileList {
            isProfileState = .profileList
            handleBackButton()
        }else{
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func dismissPassowrdDialog(_ sender: Any) {
        passwordView.isHidden = true
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        if utils.md5(string: tfPassword.text!) == userProfiles[sel_index].senha {
            moveToNext()
        } else {
            utils.showDestructiveAlert(message: "Senha incorreta!", presentationController: self)
        }
    }

    @IBAction func EditProfileTapped(_ sender: Any) {
        isProfileState = .editProfileList
        handleBackButton()
    }
    
    @IBAction func RemoveProfileTapped(_ sender: Any) {
        isProfileState = .deleteProfileList
        handleBackButton()
    }
    
    private func moveToNext() {
        if sel_index == -1 { return }
        
        if isProfileState == .profileList {
            if sel_index == userProfiles.count{
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
                nextViewController.isAddProfile = true
                self.present(nextViewController, animated:true, completion:nil)
            } else {
                userProfiles[sel_index].saveUserProfile()

                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                self.present(nextViewController, animated:true, completion:nil)
            }
        }else{
            if isProfileState == .deleteProfileList {
                // call delete profile
                let profileId = userProfiles[sel_index].id
                ProfileAPI.removeProfile(profileId: "\(profileId!)", delegate: self)
                self.passwordView.isHidden = true
            }else{
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
                nextViewController.userProfile = userProfiles[sel_index]
                self.present(nextViewController, animated:true, completion:nil)
            }
        }

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("return pressed")
        tfPassword.resignFirstResponder()
        return false
    }
    
}

extension ProfileViewController : UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isProfileState == .profileList {
            return userProfiles.count + 1
        }else{
            return userProfiles.count
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProfileViewCell
        cell.tag = indexPath.row
        cell.profilePic.layer.borderWidth = 1.0
        cell.profilePic.layer.masksToBounds = false
        cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.width / 2
        cell.profilePic.clipsToBounds = true
        
        cell.backgorundView.layer.borderWidth = 1
        cell.backgorundView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        
        if isProfileState == .profileList {
            cell.actionImage.isHidden = true
        }else{
            cell.actionImage.isHidden = false
            if isProfileState == .deleteProfileList {
                //show delete image
                cell.actionImage.image = UIImage(named:"delete_icon")
            }else{
                //show edit image
                cell.actionImage.image = UIImage(named:"edit_icon")
            }
        }
        
        if indexPath.row == userProfiles.count {
            cell.profilePic.image = UIImage(named:"addperfil")
            cell.profilePic.layer.borderColor = UIColor.clear.cgColor
            cell.name.text = "Adicionar Perfil"
        }else{
            cell.profilePic.image = UIImage(named:"perfil")
            cell.profilePic.layer.borderColor = UIColor.white.cgColor
            cell.name.text = userProfiles[indexPath.row].name
        }
        
        //cell.profilePic.adjustsImageWhenAncestorFocused = true
        
        
        cell.did_completation_Focus = { (indx_tag) in
            guard let indx = indx_tag else {
                return
            }
            if indx == 100 {
                cell.backgorundView.layer.borderWidth = 1
                cell.backgorundView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
            }
            else if indexPath.row == indx {
                cell.backgorundView.layer.borderWidth = 3
                cell.backgorundView.layer.borderColor = UIColor.fromHex(hexString: "#DE003F").cgColor
            }
            else {
                cell.backgorundView.layer.borderWidth = 1
                cell.backgorundView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
            }
            
        }
        
        
        
        return cell
    }
}


extension ProfileViewController {
    func ProfileResponseHandler(profileData:[UserProfile]){
        self.loadingIndicator.stopAnimating()
        self.userProfiles = profileData
        
        self.collectionView.reloadData()
    }
    
    func deleteProfileResponseHandler(errorMessage:String){
        if errorMessage == "" {
            getProfileList()
        }
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
                        UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width / 5 - 10, height: 185)
    }
    
}

extension ProfileViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.sel_index = indexPath.row
        if indexPath.row == userProfiles.count {
            self.moveToNext()
        }
        else {
            let str_password = userProfiles[sel_index].senha ?? ""
            if str_password == "" {
                self.moveToNext()
            }
            else {
                self.passwordView.isHidden = false
                self.tfPassword.becomeFirstResponder()
            }
        }
    }
}

extension ProfileViewController{
    func handleBackButton(){
        if isFromLogin == true && isProfileState == .profileList{
            backButton.isHidden = true
            self.view_Header_title.isHidden = true
            self.view_Header_title_Short.isHidden = false
        }else{
            backButton.isHidden = false
            self.view_Header_title.isHidden = false
            self.view_Header_title_Short.isHidden = true
        }
        collectionView.reloadData()
    }
    func getProfileList(){
        isProfileState = .profileList
        handleBackButton()
        self.loadingIndicator.startAnimating()
        ProfileAPI.getProfileData(delegate: self);
    }
}



class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }

            layoutAttribute.frame.origin.x = leftMargin

            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }

        return attributes
    }
}
