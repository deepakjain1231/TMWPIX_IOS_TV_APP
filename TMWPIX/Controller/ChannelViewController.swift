//
//  ChannelViewController.swift
//  TMWPIX
//
//  Created by Apple on 03/08/2022.
//

import Foundation

import SDWebImage
import UIKit

class ChannelViewController: TMWViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var channels : [Channel] = []
    var is_home = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.loadingIndicator.startAnimating()
        ChannelAPI.getChannelData(delegate: self)
    }
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true)
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


extension ChannelViewController {
    func channelResponseHandler(ChannelData:[Channel]){
        self.loadingIndicator.stopAnimating()
        channels = ChannelData
        self.collectionView.reloadData()
        self.open_firstChannel()
    }
}


extension ChannelViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return channels.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ChannelViewCell
        cell.backView.backgroundColor = .clear
        
        cell.tag = indexPath.row
        cell.ChannelImage.sd_setImage(with: URL(string: channels[indexPath.row].image!))
        cell.ChannelNumber.text = String(channels[indexPath.row].number!)
        
        cell.img_focus.isHidden = true//.adjustsImageWhenAncestorFocused = true
        
        cell.did_completation_Focus = { (indx_tag) in
            guard let indx = indx_tag else {
                return
            }
            if indexPath.row == indx {
                cell.backView.backgroundColor = .systemBlue
            }
            else {
                cell.backView.backgroundColor = .clear
            }
            //self.collectionView.reloadData()
        }
        
        return cell
    }
    
    
}

//extension ChannelViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
//                        UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: self.collectionView.frame.size.width / 4, height: self.collectionView.frame.size.height / 5 - 5)
//    }
//
//}

extension ChannelViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if is_home {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MediaViewController") as! MediaViewController
            nextViewController.ImageUrl = channels[indexPath.row].image ?? ""
            nextViewController.VideoURl = channels[indexPath.row].url ?? ""
            nextViewController.name = channels[indexPath.row].name ?? ""
            nextViewController.desc = channels[indexPath.row].description ?? ""
            nextViewController.channelID = "\(channels[indexPath.row].id ?? 0)"
            nextViewController.Channeltext = String(channels[indexPath.row].number ?? 0)
            nextViewController.is_epg = false
            self.present(nextViewController, animated:true, completion:nil)
            
        } else {
            let nextViewController = self.presentingViewController as! MediaViewController
            nextViewController.ImageUrl = channels[indexPath.row].image!
            nextViewController.VideoURl = channels[indexPath.row].url!
            nextViewController.name = channels[indexPath.row].name!
            nextViewController.desc = channels[indexPath.row].description!
            nextViewController.channelID = "\(channels[indexPath.row].id!)"
            nextViewController.Channeltext = String(channels[indexPath.row].number!)
            nextViewController.is_epg = true
            nextViewController.reloadPlayer()
            self.dismiss(animated: true, completion: nil)

        }
    }
    
    
    func open_firstChannel() {
        if is_home {
            if self.channels.count != 0 {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MediaViewController") as! MediaViewController
                nextViewController.ImageUrl = self.channels[0].image ?? ""
                nextViewController.VideoURl = channels[0].url ?? ""
                nextViewController.name = channels[0].name ?? ""
                nextViewController.desc = channels[0].description ?? ""
                nextViewController.channelID = "\(channels[0].id ?? 0)"
                nextViewController.Channeltext = String(channels[0].number ?? 0)
                nextViewController.is_epg = false
                self.present(nextViewController, animated:true, completion:nil)
            }
        }
    }
}
