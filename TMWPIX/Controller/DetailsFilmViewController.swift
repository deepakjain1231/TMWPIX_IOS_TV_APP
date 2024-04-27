//
//  DetailsFilmViewController.swift
//  TMWPIX
//
//  Created by Apple on 04/08/2022.
//

import Foundation

import UIKit
import AVFoundation
import AVKit


class DetailsFilmViewController: TMWViewController {
    
    var FilmName:String?
    var FilmID:String?
    var ImageUrl:String?
    var aluguel = 0
    var movie: Movie?

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var filmImage: UIImageView!
    @IBOutlet weak var filmDiscription: UITextView!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblAluguel: UILabel!
    var player: AVPlayer!
    var playerController: AVPlayerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.text = FilmName
        filmImage.sd_setImage(with: URL(string: ImageUrl!))
        
        self.loadingIndicator.startAnimating()
        FilmAPI.getMovieInfoData(delegate: self)

        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
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
    
    @IBAction func ReportErrorTapped(_ sender: Any) {
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let popupVC = storyboard.instantiateViewController(withIdentifier: "ErrorResolvedViewController") as! ErrorResolvedViewController
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        popupVC.FilmID = self.FilmID
        let pVC = popupVC.popoverPresentationController
        pVC?.sourceRect = CGRect(x: 100, y: 100, width: 1, height: 1)
        present(popupVC, animated: true, completion: nil)
    }
    
    
    @IBAction func RentalDetailTapped(_ sender: Any) {
        if aluguel == 2 {
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let popupVC = storyboard.instantiateViewController(withIdentifier: "RentalDetailViewController") as! RentalDetailViewController
            popupVC.modalPresentationStyle = .overCurrentContext
            popupVC.modalTransitionStyle = .crossDissolve
            if self.movie == nil {
                return
            }
            if let price = self.movie!.movies?.precoaluguel {
                popupVC.price = price
            }
            if self.movie!.movies?.duration != nil {
                if let sec = Int((self.movie!.movies?.duration)!) {
                    if sec / 60 >= 1 {
                        popupVC.hour = "\(sec/60) HORA E \(sec%60) MINUTOS"
                    } else {
                        popupVC.hour = "\(sec) MINUTOS"
                    }
                }
            }

            let pVC = popupVC.popoverPresentationController
            pVC?.sourceRect = CGRect(x: 100, y: 100, width: 1, height: 1)
            present(popupVC, animated: true, completion: nil)
            
        } else {

            guard let url = URL(string: self.movie?.movies?.url ?? "") else {
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
            
            let but_Back = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
            but_Back.addSubview(self.view)
//            self.present(self.playerController, animated: true) {
//                // Start playback
//                self.player.play()
//            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
//       scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width / 2 , height: UIScreen.main.bounds.height + 100)
    }

}

extension DetailsFilmViewController {
    func handleFilmInfoData(movie: Movie) {
        self.movie = movie
        
        self.loadingIndicator.stopAnimating()
        self.filmDiscription.text = movie.movies?.description
        if movie.movies?.year == nil {
            self.lblYear.text = movie.movies?.created?.components(separatedBy: "-")[0]
        } else {
            self.lblYear.text = movie.movies?.year
        }
        if movie.movies?.duration != nil {
            if let sec = Int((movie.movies?.duration)!) {
                if sec / 60 >= 1 {
                    self.lblDuration.text = "\(sec/60) hora e \(sec%60) minutos"
                } else {
                    self.lblDuration.text = "\(sec) minutos"
                }
            }
        }
        if let price = movie.movies?.precoaluguel {
            self.lblAluguel.text = "R$ \(price)"
        }
    }
}
