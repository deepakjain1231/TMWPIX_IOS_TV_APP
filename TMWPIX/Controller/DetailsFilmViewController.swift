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
import Alamofire

class DetailsFilmViewController: TMWViewController, delegate_Cpf_Verified, delegate_cpfVerified {
    
    var FilmName:String?
    var FilmID:String?
    var ImageUrl:String?
    var int_aluguel = 0
    var dic_movieData: Movie?
    var str_errorMsg = ""

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var filmImage: UIImageView!
    @IBOutlet weak var filmDiscription: UITextView!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblAluguel: UILabel!
    @IBOutlet weak var btn_Reset: UIButton!
    @IBOutlet weak var btn_Play: UIButton!
    
    var player: AVPlayer!
    var playerController: AVPlayerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btn_Play.isHidden = true
        self.btn_Reset.isHidden = true
        
        name.text = FilmName
        filmImage.sd_setImage(with: URL(string: ImageUrl!))
        
        self.loadingIndicator.startAnimating()
        FilmAPI.getMovieInfoData(delegate: self)
        FilmAPI.check_report_Status(film_id: self.FilmID ?? "") { str_report_status in
            if str_report_status.contains("erro") {
                var str_error = str_report_status.replacingOccurrences(of: "{", with: "")
                str_error = str_error.replacingOccurrences(of: "}", with: "")
                str_error = str_error.replacingOccurrences(of: ":", with: "")
                str_error = str_error.replacingOccurrences(of: "erro", with: "")
                self.str_errorMsg = str_error.trimed()
            }
            else if str_report_status.contains("status") && str_report_status.contains("aberto") {
                self.str_errorMsg = "Ticket já aberto"
            }
        }

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
                let currentTime = utils.getMovieSec_Data(str_type: "film", str_id: self.FilmID ?? "")
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
    
    @IBAction func ReportErrorTapped(_ sender: Any) {
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let popupVC = storyboard.instantiateViewController(withIdentifier: "ErrorResolvedViewController") as! ErrorResolvedViewController
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        popupVC.FilmID = self.FilmID
        popupVC.superVC = self
        let pVC = popupVC.popoverPresentationController
        pVC?.sourceRect = CGRect(x: 100, y: 100, width: 1, height: 1)
        present(popupVC, animated: true, completion: nil)
    }
    
    
    @IBAction func btn_resolve_Error_Action(_ sender: Any) {
        if self.str_errorMsg != "" {
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let popupVC = storyboard.instantiateViewController(withIdentifier: "ErrorResolvedViewController") as! ErrorResolvedViewController
            popupVC.screenFrom = "error_resolved"
            popupVC.modalPresentationStyle = .overCurrentContext
            popupVC.modalTransitionStyle = .crossDissolve
            popupVC.str_Error = self.str_errorMsg
            let pVC = popupVC.popoverPresentationController
            pVC?.sourceRect = CGRect(x: 100, y: 100, width: 1, height: 1)
            present(popupVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func btn_ResetTapped(_ sender: Any) {
        utils.setMovieData_globally(str_type: "film", str_id: self.FilmID ?? "", time: 0)
        self.play_video()
    }
    
    
    @IBAction func RentalDetailTapped(_ sender: Any) {
        
        if (self.dic_movieData?.movies?.alugado ?? "") == "1" ||
            (self.dic_movieData?.movies?.preco ?? "") == "0" {
            self.play_video()
        }
        else {
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let popupVC = storyboard.instantiateViewController(withIdentifier: "RentalDetailViewController") as! RentalDetailViewController
            popupVC.delegate = self
            popupVC.modalPresentationStyle = .overCurrentContext
            popupVC.modalTransitionStyle = .crossDissolve
            if self.dic_movieData == nil {
                return
            }
            if let price = self.dic_movieData!.movies?.precoaluguel {
                popupVC.price = price
            }
            if self.dic_movieData!.movies?.duration != nil {
                if let sec = Int((self.dic_movieData!.movies?.duration)!) {
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
            
        }
    }
    
    func play_video() {
        
        var str_MovieURL = self.dic_movieData?.movies?.url ?? ""
        str_MovieURL = str_MovieURL.replacingOccurrences(of: "play.m3u8", with: "playapple.m3u8")
        
        guard let url = URL(string: str_MovieURL) else {
            debugPrint("Invalid URL")
            return
        }

        let asset = AVURLAsset(url: url, options: nil)
        let playerItem = AVPlayerItem(asset: asset)
        self.player = AVPlayer(playerItem: playerItem)
        self.player?.addObserver(self, forKeyPath: "status", options: [], context: nil)// listen the current time of playing video
        self.player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: Double(1), preferredTimescale: 2), queue: DispatchQueue.main) { [weak self] (sec) in
            guard let self = self else { return }
            debugPrint(sec.seconds)
            utils.setMovieData_globally(str_type: "film", str_id: self.FilmID ?? "", time: sec.seconds)
            self.setupButtonText()
        }
        self.player?.volume = 1.0

        // Create AVPlayerViewController and set player
        self.playerController = AVPlayerViewController()
        self.playerController.player = self.player

        // Present the AVPlayerViewController or add it to your view hierarchy
        self.present(self.playerController, animated: true)
        
        let but_Back = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        but_Back.addSubview(self.view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
//       scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width / 2 , height: UIScreen.main.bounds.height + 100)
    }

    
    func check_and_openCPF_popup(_ success: Bool) {
        if success {
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let popupVC = storyboard.instantiateViewController(withIdentifier: "CPFVerifiedVC") as! CPFVerifiedVC
            popupVC.delegate = self
            popupVC.modalPresentationStyle = .overCurrentContext
            popupVC.modalTransitionStyle = .crossDissolve
            let pVC = popupVC.popoverPresentationController
            pVC?.sourceRect = CGRect(x: 100, y: 100, width: 1, height: 1)
            present(popupVC, animated: true, completion: nil)
        }
    }
    
    func cpf_verified_play_moview(_ success: Bool, str_cpf_value: String) {
        if success {
            self.play_video()
            self.callAPIforUpdateStatus(verified_cpf: str_cpf_value)
        }
    }
    
    func callAPIforUpdateStatus(verified_cpf: String) {
        
        let userInfo = UserInfo.getInstance()
        let userProfile = UserProfile.getInstance()
        let userToken: String = userInfo?.token ?? ""
        
        let str_url = Constants.baseUrl + "/alugafilme?appversion=\(utils.getAppVersion())&email=\(userInfo?.email ?? "")&confirma=\(verified_cpf)&cpf=\(appDelegate.str_cpfValue)&cliente_id=\(userInfo?.client_id ?? 0)&filme_id=\(self.FilmID ?? "")&user=&time=\(utils.getTime())&hash=\(utils.getHash())&dtoken=\(utils.getDToken())&os=ios&operator=1&tipo=t&usrtoken=\(userToken)&hashtoken=\(utils.getHashToken(token: userToken))"
        
        AF.request(str_url, method: .get).response{ response in
            
            if let data = response.data {
                print(data)
                debugPrint("API====>>>\(str_url)\n\nResult=====>>\(response.result)")
                do {
                    let dictonary =  try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:AnyObject]

                    FilmAPI.getMovieInfoData(delegate: self)
                    
                } catch let error as NSError {
                    print(error)
                }
            }
        }
    }
}

extension DetailsFilmViewController {
    func handleFilmInfoData(movie: Movie) {
        self.dic_movieData = movie
        
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
        
        self.setupButtonText()
    }
    
    func setupButtonText() {
        //Load movie Info in Screen
        self.btn_Reset.isHidden = true
        self.btn_Play.isHidden = false
        
        if (self.dic_movieData?.movies?.alugado ?? "") == "1" ||
            (self.dic_movieData?.movies?.preco ?? "") == "0" {
            
            let currentTime = utils.getMovieSec_Data(str_type: "film", str_id: self.FilmID ?? "")
            
            if currentTime != 0 {
                self.btn_Reset.isHidden = false
                self.btn_Play.setTitle("Continuar Assistindo", for: .normal)
            }
            else {
                self.btn_Play.setTitle("Assistir!", for: .normal)
            }
        }
        else {
            self.btn_Play.setTitle("Alugue esse filme!", for: .normal)
        }

    }
}
