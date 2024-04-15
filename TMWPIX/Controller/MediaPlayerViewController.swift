//
//  MediaPlayerViewController.swift
//  TMWPIX
//
//  Created by Apple on 03/08/2022.
//

import Foundation
import AVKit
import AVFoundation
import UIKit
import PlayKit


class MediaPlayerViewController: TMWViewController, AVPlayerViewControllerDelegate, delegateChange_Language {
    
    var Channeltext:String?
    var ImageUrl:String?
    var VideoURl:String?
    var name: String?
    var desc: String?
    
    @IBOutlet weak var MediaView: UIView!
    var playerController = AVPlayerViewController()
    var player: AVPlayer!
    var asset: AVAsset!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var titleView: UIView!
    
    
    @IBOutlet weak var channelNumber: UILabel!
    
    @IBOutlet weak var channelImage: UIImageView!
    @IBOutlet weak var channelTitle: UILabel!
    @IBOutlet weak var channelName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        channelImage.sd_setImage(with: URL(string: ImageUrl!))
        channelNumber.text = Channeltext
        channelName.text = name
        
        self.loadingIndicator.startAnimating()
        
        try! AVAudioSession.sharedInstance().setCategory(.playback)
        
        // Video Streaming
//        VideoURl = "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8"
        guard let url = URL(string: VideoURl!) else{
            return
        }
        player = AVPlayer(url: url)
        
        let playerLayer = AVPlayerLayer(player: player)
        view.layer.addSublayer(playerLayer)
        playerLayer.frame =  view.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        asset = AVAsset(url: url)
        
        player.play()
        player.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)


        //        self.loadingIndicator.stopAnimating()
        
//        playerController.allowsPictureInPicturePlayback = true
//        playerController.delegate = self
//        playerController.player?.play()
//
//        self.present(playerController, animated: true, completion: nil)
        
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "timeControlStatus", let change = change, let newValue = change[NSKeyValueChangeKey.newKey] as? Int, let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
            if #available(iOS 10.0, *) {
                let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
                let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
                if newStatus != oldStatus {
                    
                    for characteristic in asset.availableMediaCharacteristicsWithMediaSelectionOptions {
                        print("\(characteristic)")

                        // Retrieve the AVMediaSelectionGroup for the specified characteristic.
                        if let group = asset.mediaSelectionGroup(forMediaCharacteristic: .audible) {
                            // Print its options.
                            for option in group.options {
                                if option.displayName.contains("dubbing") {
                                    self.player.currentItem!.select(option, in: group)
                                }
                                print("  Option: \(option.locale)")
                            }
                        }
                    }
                    if let playerItem = player?.currentItem,
                        let group = playerItem.asset.mediaSelectionGroup(forMediaCharacteristic: AVMediaCharacteristic.audible) {
                        let selectedOption = playerItem.currentMediaSelection.selectedMediaOption(in: group)
                        let locale = selectedOption?.locale
                        print("locale : \(locale)")
                    }

//                    if let group = asset.mediaSelectionGroup(forMediaCharacteristic: .audible) {
//                        let locale = Locale(identifier: "dubbing")
//                        let options =
//                            AVMediaSelectionGroup.mediaSelectionOptions(from: group.options, with: locale)
//                        if let option = options.first {
//                            // Select Spanish-language subtitle option
//                            self.player.currentItem!.select(option, in: group)
//                        }
//                    }

                    DispatchQueue.main.async {[weak self] in
                        if newStatus == .playing || newStatus == .paused {
                            self!.loadingIndicator.stopAnimating()
                        } else {
                            self!.loadingIndicator.startAnimating()
                        }
                    }
                }
            } else {
                // Fallback on earlier versions
                self.loadingIndicator.stopAnimating()
            }
        }
    }

    @IBAction func openChangeAudioTapped(_ sender: Any) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let popupVC = storyboard.instantiateViewController(withIdentifier: "AudioViewController") as! AudioViewController
        popupVC.delegate = self
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        let pVC = popupVC.popoverPresentationController
        pVC?.sourceRect = CGRect(x: 100, y: 100, width: 1, height: 1)
        present(popupVC, animated: true, completion: nil)
    }
    
    
    @IBAction func openInformationBoxTapped(_ sender: Any) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let popupVC = storyboard.instantiateViewController(withIdentifier: "InfoViewController") as! InfoViewController
        popupVC.desc = self.desc!
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        let pVC = popupVC.popoverPresentationController
        pVC?.sourceRect = CGRect(x: 100, y: 100, width: 1, height: 1)
        present(popupVC, animated: true, completion: nil)
    }
    
//    @IBAction func goToMoveChannel(_ sender: Any) {
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChannelViewController") as! ChannelViewController
//
//        self.present(nextViewController, animated:true, completion:nil)
//    }
    @IBAction func ViewDismissed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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

    
    func did_changeLanguage(changed_track: Track) {
        
    }
}
