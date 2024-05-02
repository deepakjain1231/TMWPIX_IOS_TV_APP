//
//  MovieDetailViewController.swift
//  TMWPIX
//
//  Created by Apple on 10/08/2022.
//

import Foundation

import UIKit
import AVFoundation
import AVKit

class MovieDetailViewController: TMWViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!

    //    // Movie Detail Data
    var id : Int?
    var name: String?
    var image: String?
    
    var player: AVPlayer!
    var playerController: AVPlayerViewController!
    
    // Movie Detail
    @IBOutlet weak var seasonNumber: UILabel!
    @IBOutlet weak var sereisImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDiscription: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var img_logo: UIImageView!
    @IBOutlet weak var btn_Back: UIButton!

    var episodes: [SeriesEpisode] = []
    var seasonId: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sereisImage.sd_setImage(with: URL(string:image!))
        movieTitle.text = name
        self.img_logo.tag = 100
        self.btn_Back.tag = 100
        self.sereisImage.tag = 100
        sereisImage.adjustsImageWhenAncestorFocused = true
        
        self.loadingIndicator.startAnimating()
        SeriesAPI.getSeasonData(serieid: String(self.id!), delegate: self)
        SeriesAPI.getSeriesInfoData(serieid: String(self.id!), delegate: self)
        
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])

    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let player = object as? AVPlayer, player == self.player, keyPath == "status" {
            if player.status == .readyToPlay {
                self.player?.play()
            } else if player.status == .failed {
                debugPrint("failed_player")
            }
        }
    }
    
    
    @IBAction func viewDismissed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
#if TARGET_OS_IOS
    override var shouldAutorotate: Bool{
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .landscapeLeft
    }
#endif
    
    
    @IBAction func ReportErrorTapped(_ sender: Any) {
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let popupVC = storyboard.instantiateViewController(withIdentifier: "ErrorResolvedViewController") as! ErrorResolvedViewController
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        popupVC.FilmID = "\(self.id ?? 0)"
        let pVC = popupVC.popoverPresentationController
        pVC?.sourceRect = CGRect(x: 100, y: 100, width: 1, height: 1)
        present(popupVC, animated: true, completion: nil)
    }
    
    
    @IBAction func RentalDetailTapped(_ sender: Any) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let popupVC = storyboard.instantiateViewController(withIdentifier: "RentalDetailViewController") as! RentalDetailViewController
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        let pVC = popupVC.popoverPresentationController
        pVC?.sourceRect = CGRect(x: 100, y: 100, width: 1, height: 1)
        present(popupVC, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width / 2 , height: UIScreen.main.bounds.height)
    }
    
    override func shouldUpdateFocus(in context: UIFocusUpdateContext) -> Bool {
        return true
    }
    
}


extension MovieDetailViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return episodes.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! EpisodeViewCell
        cell.tag = indexPath.row
        cell.episodeNumber.text = "Episodio " + String(episodes[indexPath.row].number!)
        
        cell.did_completation_Focus = { (indx_tag) in
            guard let indx = indx_tag else {
                return
            }
            if indx == 100 {
                cell.backgroundColor = UIColor.fromHex(hexString: "#F35302")
            }
            else if indexPath.row == indx {
                cell.backgroundColor = UIColor.fromHex(hexString: "#DE003F")
            }
            else {
                cell.backgroundColor = UIColor.fromHex(hexString: "#F35302")
            }
        }
        
        return cell
    }
    
}

extension MovieDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
                        UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width, height: 50)
    }
    
}

extension MovieDetailViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let url = URL(string: self.episodes[indexPath.row].url ?? "") else {
            debugPrint("Invalid URL")
            return
        }

        let asset = AVURLAsset(url: url, options: nil)
        let playerItem = AVPlayerItem(asset: asset)
        self.player = AVPlayer(playerItem: playerItem)
        self.player?.addObserver(self, forKeyPath: "status", options: [], context: nil)// listen the current time of playing video
        self.player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: Double(1), preferredTimescale: 2), queue: DispatchQueue.main) { [weak self] (sec) in
            guard let self = self else { return }
            
        }
        self.player?.volume = 1.0

        // Create AVPlayerViewController and set player
        self.playerController = AVPlayerViewController()
        self.playerController.player = self.player

        // Present the AVPlayerViewController or add it to your view hierarchy
        self.present(self.playerController, animated: true)
        
        
        
        
        
        
//        if let videoURL = URL(string: self.episodes[indexPath.row].url ?? "") {
//            // Create an AVPlayer instance with the URL as the asset
//            let player = AVPlayer(url: videoURL)
//            
//            // Create an AVPlayerViewController and set its player
//            let controller = AVPlayerViewController()
//            controller.player = player
//            
//            // Present the AVPlayerViewController or add it to your view hierarchy
//            present(controller, animated: true) {
//                // Start playback
//                player.play()
//            }
//        }
    }
    
}


extension MovieDetailViewController {
    func episodeResponseHandler(episodeData:[SeriesEpisode]){
        self.loadingIndicator.stopAnimating()
        self.episodes = episodeData
        collectionView.reloadData()
    }
    
    func seriesInfoResponseHandler(series:Series){
        self.loadingIndicator.stopAnimating()
        movieDiscription.text = series.description
    }
    
    func seasonResponseHandler(season:SeasonData){
        self.loadingIndicator.stopAnimating()
        self.loadingIndicator.startAnimating()
        seasonNumber.text = season.name
        SeriesAPI.getSeriesEpisodeData(seasonid: String(season.id!), delegate: self)
    }
}




