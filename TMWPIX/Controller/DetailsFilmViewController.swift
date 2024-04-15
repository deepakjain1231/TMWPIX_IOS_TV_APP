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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.text = FilmName
        filmImage.sd_setImage(with: URL(string: ImageUrl!))
        
        self.loadingIndicator.startAnimating()
        FilmAPI.getMovieInfoData(delegate: self)

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
            
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MoviePlayerViewController") as! MoviePlayerViewController
//            nextViewController.ImageUrl = ImageUrl
//            nextViewController.VideoURl = self.movie?.movies?.url!
//            self.present(nextViewController, animated:true, completion:nil)

            
            
            if let videoURL = URL(string: self.movie?.movies?.url ?? "") {
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
