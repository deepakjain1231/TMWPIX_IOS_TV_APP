//
//  RemoveProfileViewController.swift
//  TMWPIX
//
//  Created by Apple on 03/08/2022.
//


import Foundation

import UIKit

class RemoveProfileViewController: TMWViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var middleware = Middlewares()
    
    var userProfiles : [UserProfile] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func ViewDismissed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func ComeBackTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func EditProfileTapped(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func RemoveProfileTapped(_ sender: Any) {
    }
    
    
}

extension RemoveProfileViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userProfiles.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RemoveProfileViewCell
        
        cell.ProfileImage.image = UIImage(named:"perfil")
        cell.ProfileImage.layer.borderWidth = 1.0
        cell.ProfileImage.layer.masksToBounds = false
        cell.ProfileImage.layer.borderColor = UIColor.white.cgColor
        cell.ProfileImage.layer.cornerRadius = cell.ProfileImage.frame.size.width / 2
        cell.ProfileImage.clipsToBounds = true
        //        "perfil"
        cell.ProfileName.text = userProfiles[indexPath.row].name
        
        return cell
    }
    
}

extension RemoveProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
                        UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width / 4 - 10, height: self.collectionView.frame.size.height)
    }
    
}

extension RemoveProfileViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //api call for remove profile
        let profileId = userProfiles[indexPath.row].id
//        ProfileAPI.removeProfile(profileId: "\(profileId!)", delegate: self)
        
    }
    
}

extension RemoveProfileViewController {
    func deleteProfileResponseHandler(errorMessage:String){
        if errorMessage == "" {
            self.ViewDismissed(NSNull.self)
        }
    }
}
