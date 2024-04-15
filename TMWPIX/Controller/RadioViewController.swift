//
//  RadioViewController.swift
//  TMWPIX
//
//  Created by Apple on 18/08/2022.
//

import Foundation

import UIKit
import AVFoundation

class RadioViewController: TMWViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selected_radio = ""
    @IBOutlet weak var RadioImage: UIImageView!
    @IBOutlet weak var RadioTitle: UILabel!
    @IBOutlet weak var RadioBtn: UIButton!
    @IBOutlet weak var RadioDiscription: UILabel!
    
    var isRadioPlay:Bool = false
    
    var player: AVPlayer?
    var AudioUrlString : String?
    
    var RadioName: [String] = []
    var Disc: [String] = []
    var image: [String] = []
    var url: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadingIndicator.startAnimating()
        RadioAPI.getRadioData(delegate: self);
    }
    
    
    @IBAction func viewDismissed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func RadioPlayBtnTapped(_ sender: Any) {
        self.click_playButton()
    }
    
    func click_playButton() {
        let urlString = AudioUrlString
        guard let url = URL.init(string: urlString!)
        else {
            return
        }
        let playerItem = AVPlayerItem.init(url: url)
        player = AVPlayer.init(playerItem: playerItem)
        
        if isRadioPlay{
            isRadioPlay = false
            RadioBtn.setImage(UIImage(named: "ic_play-1.png"), for: .normal)
            DispatchQueue.main.async {
                self.player!.pause()
            }
        }else{
            isRadioPlay = true
            RadioBtn.setImage(UIImage(named: "ic_pause-1.png"), for: .normal)
            DispatchQueue.main.async {
                self.player!.play()
            }
        }
    }
    
#if TARGET_OS_IOS
    override var shouldAutorotate: Bool{
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .landscapeLeft
    }
#endif
    
}

extension RadioViewController {
    func RadioResponseHandler(RadioData:[Radio]){
        self.loadingIndicator.stopAnimating()
        for data in RadioData{
            RadioName.append(data.name!)
            Disc.append(data.description!)
            image.append(data.image!)
            url.append(data.url!)
        }
        
        //
        //        (RadioName,Disc,image) = middleware.getRadioData()
        
        RadioTitle.text = RadioName[0]
        RadioDiscription.text = Disc[0]
        AudioUrlString = url[0]
        
        let url = URL(string: image[0])
        RadioImage.sd_setImage(with: url)
        
        self.collectionView.reloadData()
        self.click_playButton()
    }
}

extension RadioViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return RadioName.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RadioViewCell
        cell.ChannelText.text = RadioName[indexPath.row]
        
        if (self.AudioUrlString ?? "") == url[indexPath.row] {
            cell.contentView.backgroundColor = utils.UIColorFromRGBValue(red: 189, green: 0, blue: 54)
        }
        else {
            cell.contentView.backgroundColor = .clear
        }

        
        return cell
    }
    
}

extension RadioViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
//                        UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: self.collectionView.frame.size.width / 5 , height: self.collectionView.frame.size.height / 5 - 10)
//    }
    
}

extension RadioViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.click_playButton()
        RadioTitle.text = RadioName[indexPath.row]
        RadioDiscription.text = Disc[indexPath.row]
        
        RadioImage.sd_setImage(with: URL(string: image[indexPath.row]))
        AudioUrlString = url[indexPath.row]
        self.collectionView.reloadData()
        self.click_playButton()
    }
    
}


