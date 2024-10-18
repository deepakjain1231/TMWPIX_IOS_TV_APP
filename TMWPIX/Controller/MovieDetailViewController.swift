//
//  MovieDetailViewController.swift
//  TMWPIX
//
//  Created by Apple on 10/08/2022.
//

import UIKit
import AVKit
import AVFoundation


class MovieDetailViewController: TMWViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!

    //Movie Detail Data
    var id : Int?
    var name: String?
    var image: String?
    var str_series_id = ""
    var strSelectedSeason = ""
    var int_playingTime = 0
    var is_PlayerClicked:Bool = false
    
    var player: AVPlayer!
    var playerController: AVPlayerViewController!
    
    // Movie Detail
    @IBOutlet weak var view_Top_layer: UIView!
    @IBOutlet weak var seasonNumber: UILabel!
    @IBOutlet weak var sereisImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDiscription: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var img_logo: UIImageView!
    @IBOutlet weak var btn_Back: UIButton!
    @IBOutlet weak var collection_season: UICollectionView!

    var episodes: [SeriesEpisode] = []
    var arr_seasonData: [SeasonData] = []
    var seasonId: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view_Top_layer.isHidden = false
        
        sereisImage.sd_setImage(with: URL(string:image!))
        movieTitle.text = name
        self.img_logo.tag = 100
        self.btn_Back.tag = 100
        self.sereisImage.tag = 100
        self.sereisImage.accessibilityHint = "series_image"
        sereisImage.adjustsImageWhenAncestorFocused = true
        
        self.loadingIndicator.startAnimating()
        SeriesAPI.getSeasonData(serieid: String(self.id!), delegate: self)
        SeriesAPI.getSeriesInfoData(serieid: String(self.id!), delegate: self)
        
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])

    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let player = object as? AVPlayer, player == self.player, keyPath == "status" {
            if player.status == .readyToPlay {
                let currentTime = self.int_playingTime
                self.player?.seek(to: CMTimeMake(value: Int64(currentTime), timescale: 1))
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
    
    override var preferredFocusedView: UIView? {
        get {
            return self.collection_season
        }
    }
    
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
        
        //Check player started and log player time
        if self.is_PlayerClicked {
            self.is_PlayerClicked = false
            self.loadingIndicator.stopAnimating()
            FilmAPI.callAPIfor_PauseFilm(str_type: "series", film_id: self.str_series_id, playing_time: self.int_playingTime) { dic_response in
                self.loadingIndicator.stopAnimating()
            }
        }
    }
    
    override func shouldUpdateFocus(in context: UIFocusUpdateContext) -> Bool {
        return true
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
//        // Condition
//        self.collectionView.preferredFocusedView
//        if (context.previouslyFocusedView?.accessibilityHint as? String ?? "") == "series_image" {
//            self.collectionView.preferredFocusedView
//        }
        debugPrint(context)
    }
    
}


extension MovieDetailViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collection_season {
            return self.arr_seasonData.count
        }
        return episodes.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collection_season {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeriesNameCollectionCell", for: indexPath) as! SeriesNameCollectionCell
            cell.tag = indexPath.row
            cell.view_Base.layer.cornerRadius = 8
            cell.view_Base.layer.borderWidth = 1
            cell.view_Base.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
            cell.lbl_Title.text = "Temporada \(self.arr_seasonData[indexPath.item].name ?? "")"
            
            if self.strSelectedSeason == "\(self.arr_seasonData[indexPath.item].id ?? 0)" {
                cell.view_Base.layer.cornerRadius = 8
                cell.view_Base.layer.borderWidth = 3
                cell.view_Base.layer.borderColor = UIColor.white.cgColor
            }
            else {
                cell.view_Base.layer.cornerRadius = 8
                cell.view_Base.layer.borderWidth = 1
                cell.view_Base.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
            }
            
            
            cell.did_completation_Focus = { (indx_tag) in
                guard let indx = indx_tag else {
                    return
                }
                if indx == 100 {
                    if self.strSelectedSeason == "\(self.arr_seasonData[indexPath.item].id ?? 0)" {
                        cell.view_Base.layer.cornerRadius = 8
                        cell.view_Base.layer.borderWidth = 3
                        cell.view_Base.layer.borderColor = UIColor.white.cgColor
                    }
                    else {
                        cell.view_Base.layer.cornerRadius = 8
                        cell.view_Base.layer.borderWidth = 1
                        cell.view_Base.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
                    }
                }
                else if indexPath.row == indx {
                    cell.view_Base.layer.cornerRadius = 8
                    cell.view_Base.layer.borderWidth = 3
                    cell.view_Base.layer.borderColor = UIColor.white.cgColor

                    self.strSelectedSeason = "\(self.arr_seasonData[indexPath.item].id ?? 0)"
                    SeriesAPI.getSeriesEpisodeData(seasonid: String(self.arr_seasonData[indexPath.item].id ?? 0), delegate: self)
                }
                else {
                    cell.view_Base.layer.cornerRadius = 8
                    cell.view_Base.layer.borderWidth = 1
                    cell.view_Base.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
                }
            }
            
            return cell
        }
        else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! EpisodeViewCell
            cell.tag = indexPath.row
            
            let str_name = String(episodes[indexPath.row].name ?? "")
            let str_number = String(episodes[indexPath.row].number ?? 1)
            
            cell.episodeNumber.text = "EP\(str_number): \(str_name)"
            
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
    
    
    
}

extension MovieDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
                        UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.collection_season {
            return CGSize(width: 175, height: 68)
        }
        
        return CGSize(width: self.collectionView.frame.size.width, height: 50)
    }
    
}

extension MovieDetailViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.collection_season {
            self.loadingIndicator.stopAnimating()
            self.loadingIndicator.startAnimating()
            self.strSelectedSeason = "\(self.arr_seasonData[indexPath.item].id ?? 0)"
            SeriesAPI.getSeriesEpisodeData(seasonid: String(self.arr_seasonData[indexPath.item].id ?? 0), delegate: self)
        }
        else {
            self.str_series_id = "\(self.episodes[indexPath.row].id ?? 0)"
            
            var str_seriesURL = self.episodes[indexPath.row].url ?? ""
            str_seriesURL = str_seriesURL.replacingOccurrences(of: "play.m3u8", with: "playapple.m3u8")
            
            self.loadingIndicator.startAnimating()
            SeriesAPI.getOpenEpisodeData(episode_id: self.str_series_id) { dic_episode_info in
                self.loadingIndicator.stopAnimating()
                self.int_playingTime = Int(dic_episode_info.episode?.starttime ?? "0") ?? 0
                self.playSeries(seriesURL: str_seriesURL)
            }
        }
    }
    
    func playSeries(seriesURL: String) {
        if let videoURL = URL(string: seriesURL) {
            let asset = AVURLAsset(url: videoURL, options: nil)
            let playerItem = AVPlayerItem(asset: asset)
            self.player = AVPlayer(playerItem: playerItem)
            self.player?.addObserver(self, forKeyPath: "status", options: [], context: nil)// listen the current time of playing video
            self.player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: Double(1), preferredTimescale: 2), queue: DispatchQueue.main) { [weak self] (sec) in
                guard let self = self else { return }
                debugPrint(sec.seconds)
                self.is_PlayerClicked = true
                self.int_playingTime = Int(sec.seconds)
            }
            self.player?.volume = 1.0
            
            // Create AVPlayerViewController and set player
            self.playerController = AVPlayerViewController()
            self.playerController.player = self.player
            
            // Present the AVPlayerViewController or add it to your view hierarchy
            self.present(self.playerController, animated: true)
        }
    }
        
}


extension MovieDetailViewController {
    func episodeResponseHandler(episodeData:[SeriesEpisode]) {
        self.view_Top_layer.isHidden = true
        self.loadingIndicator.stopAnimating()
        self.episodes = episodeData
        self.collection_season.reloadData()
        collectionView.reloadData()
    }
    
    func seriesInfoResponseHandler(series:Series){
        self.loadingIndicator.stopAnimating()
        movieDiscription.text = series.description
    }
    
    func seasonResponseHandler(season: [SeasonData]){
        self.loadingIndicator.stopAnimating()
        self.loadingIndicator.startAnimating()
        //seasonNumber.text = season.name
        self.arr_seasonData = season
        self.strSelectedSeason = "\(season[0].id ?? 0)"
        self.collection_season.reloadData()
        if season.count != 0 {
            SeriesAPI.getSeriesEpisodeData(seasonid: String(season[0].id ?? 0), delegate: self)
        }
    }
}




