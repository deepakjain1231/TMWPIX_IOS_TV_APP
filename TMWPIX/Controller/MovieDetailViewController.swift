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
        sereisImage.adjustsImageWhenAncestorFocused = true
        
        self.loadingIndicator.startAnimating()
        SeriesAPI.getSeasonData(serieid: String(self.id!), delegate: self)
        SeriesAPI.getSeriesInfoData(serieid: String(self.id!), delegate: self)
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
        popupVC.FilmID = "\(self.id)"
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
        
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MoviePlayerViewController") as! MoviePlayerViewController
//        nextViewController.ImageUrl = "http://api.tmwpix.com/storage/uploads/canais/capa2/1.png?timestamp=1661492443432"
//        nextViewController.VideoURl = self.episodes[indexPath.row].url!
//        self.present(nextViewController, animated:true, completion:nil)
        
        if let videoURL = URL(string: self.episodes[indexPath.row].url ?? "") {
            // Create an AVPlayer instance with the URL as the asset
            let player = AVPlayer(url: videoURL)
            
            // Create an AVPlayerViewController and set its player
            let controller = AVPlayerViewController()
            controller.player = player
            
            // Present the AVPlayerViewController or add it to your view hierarchy
            present(controller, animated: true) {
                // Start playback
                player.play()
            }
        }
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





class FocusableImageView: UIImageView {
    
    override var canBecomeFocused: Bool {
        return true
    }

    override var isUserInteractionEnabled: Bool {
        get {
            return true
        }
        set {}
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if self.isFocused {
            // Change appearance when focused (e.g., increase size, change border color)
            self.layer.borderWidth = 5.0
            self.layer.borderColor = UIColor.fromHex(hexString: "#DE003F").cgColor
        } else {
            // Reset appearance when unfocused
            self.layer.borderWidth = 0.0
        }
    }
}


class FocusableView: UIView {
    
    override var canBecomeFocused: Bool {
        return true
    }

    override var isUserInteractionEnabled: Bool {
        get {
            return true
        }
        set {}
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if self.isFocused {
            // Change appearance when focused (e.g., increase size, change border color)
            self.layer.borderWidth = 2.0
            self.layer.borderColor = UIColor.fromHex(hexString: "#DE003F").cgColor
        } else {
            // Reset appearance when unfocused
            self.layer.borderWidth = 0.0
        }
    }
}
