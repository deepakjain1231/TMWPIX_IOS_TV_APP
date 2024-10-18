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

class DetailsFilmViewController: TMWViewController, delegate_Cpf_Verified, delegate_cpfVerified, delegate_change_status {
    
    var FilmName:String?
    var FilmID:String?
    var ImageUrl:String?
    var int_aluguel = 0
    var dic_movieData: Movie?
    var str_errorMsg = ""
    var int_playingTime = 0
    var is_PlayerClicked:Bool = false

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var filmImage: UIImageView!
    @IBOutlet weak var filmDiscription: UITextView!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var btn_Reset: UIButton!
    @IBOutlet weak var btn_Play: UIButton!
    @IBOutlet weak var btn_Report_Error: UIButton!
    @IBOutlet weak var btn_Resolved_Error: UIButton!
    
    @IBOutlet weak var lbl_Price: UILabel!
    @IBOutlet weak var lbl_Price_Title: UILabel!
    @IBOutlet weak var lbl_Duration: UILabel!
    @IBOutlet weak var lbl_Duration_Title: UILabel!
    @IBOutlet weak var lbl_HorseRemining: UILabel!
    @IBOutlet weak var lbl_HorseRemining_Title: UILabel!
    @IBOutlet weak var view_Top_layer: UIView!
    
    var player: AVPlayer!
    var playerController: AVPlayerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btn_Play.isHidden = true
        self.btn_Reset.isHidden = true
        self.view_Top_layer.isHidden = false
        
        name.text = FilmName
        filmImage.sd_setImage(with: URL(string: ImageUrl!))
        
        self.loadingIndicator.startAnimating()
        FilmAPI.getMovieInfoData(delegate: self)
        self.checkReportStatus()

        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
    }
    
    func checkReportStatus() {
        FilmAPI.check_report_Status(film_id: self.FilmID ?? "") { str_report_status in
            if str_report_status.contains("erro") {
                var str_error = str_report_status.replacingOccurrences(of: "{", with: "")
                str_error = str_error.replacingOccurrences(of: "}", with: "")
                str_error = str_error.replacingOccurrences(of: ":", with: "")
                str_error = str_error.replacingOccurrences(of: "erro", with: "")
                self.str_errorMsg = str_error.trimed()
            }
            else if str_report_status.contains("status") && str_report_status.contains("aberto") || str_report_status.contains("analisando") {
                DispatchQueue.main.async {
                    self.str_errorMsg = "Ticket já aberto"
                    self.btn_Report_Error.isUserInteractionEnabled = false
                    self.btn_Report_Error.setTitleColor(.white, for: .normal)
                    if str_report_status.contains("analisando") {
                        self.btn_Report_Error.setTitle("Erro em Análise", for: .normal)
                    }
                    else {
                        self.btn_Report_Error.setTitle("Erro Aberto", for: .normal)
                    }
                    
                    self.btn_Resolved_Error.isHidden = true
                    self.btn_Report_Error.backgroundColor = UIColor().hexStringToUIColor(hex: "#BD0036")//Red Color
                }
            }
            else {
                DispatchQueue.main.async {
                    self.btn_Resolved_Error.isHidden = false
                    self.btn_Report_Error.setTitleColor(.white, for: .normal)
                }
            }
        }
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
                let currentTime = Int(self.dic_movieData?.movies?.starttime ?? "0") ?? 0
                self.player?.seek(to: CMTimeMake(value: Int64(currentTime), timescale: 1))
                self.player?.play()
            } else if player.status == .failed {
                debugPrint("failed_player")
            }
        }
    }
    
    func change_status_check(success: Bool) {
        if success {
            self.checkReportStatus()
        }
    }
    
    @IBAction func viewDismissed(_ sender: Any) {
        self.player?.pause()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ReportErrorTapped(_ sender: UIButton) {
        if (sender.titleLabel?.text ?? "") == "Erro em Análise" || (sender.titleLabel?.text ?? "") == "Erro Aberto" {
            return
        }
        else {
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let popupVC = storyboard.instantiateViewController(withIdentifier: "ErrorResolvedViewController") as! ErrorResolvedViewController
            popupVC.modalPresentationStyle = .overCurrentContext
            popupVC.modalTransitionStyle = .crossDissolve
            popupVC.FilmID = self.FilmID
            popupVC.superVC = self
            popupVC.delegate = self
            let pVC = popupVC.popoverPresentationController
            pVC?.sourceRect = CGRect(x: 100, y: 100, width: 1, height: 1)
            present(popupVC, animated: true, completion: nil)
        }
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
        self.loadingIndicator.stopAnimating()
        FilmAPI.callAPIfor_PauseFilm(str_type: "filmes", film_id: self.FilmID ?? "", playing_time: self.int_playingTime) { dic_response in
            self.int_playingTime = -1
            self.loadingIndicator.stopAnimating()
            self.dic_movieData?.movies?.starttime = "\(self.int_playingTime)"
            self.setupButtonText()
            self.play_video()
        }
    }
    
    @IBAction func RentalDetailTapped(_ sender: Any) {
        //Changes as per Dinesh (Skype Call) - 15-Oct
        if (self.dic_movieData?.movies?.aluguel == "1" && (self.dic_movieData?.movies?.preco ?? "0") > "0") {
            // Paid movie
            if (self.dic_movieData?.movies?.alugado == "1") {
                // Paid movie and already rented
                self.play_video()
            } else {
                // Paid movie but not yet rented
                self.openPasswordPopup()
            }
        } else if (self.dic_movieData?.movies?.aluguel == "0" && (self.dic_movieData?.movies?.preco ?? "0") == "0") {
            // Free movie
            self.play_video()
        } else if (self.dic_movieData?.movies?.alugado == "0" && self.dic_movieData?.movies?.aluguel == "1") {
            // Paid movie but not rented yet
            self.openPasswordPopup()
        } else {
            // Default behavior for any other case
            self.play_video()
        }

    }

    func openPasswordPopup() {
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
            self.is_PlayerClicked = true
            self.int_playingTime = Int(sec.seconds)
            debugPrint(sec.seconds)
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

        //Check player started and log player time
        if self.is_PlayerClicked {
            self.is_PlayerClicked = false
            self.loadingIndicator.stopAnimating()
            FilmAPI.callAPIfor_PauseFilm(str_type: "filmes", film_id: self.FilmID ?? "", playing_time: self.int_playingTime) { dic_response in
                self.loadingIndicator.stopAnimating()
                self.dic_movieData?.movies?.starttime = "\(self.int_playingTime)"
                self.setupButtonText()
            }
        }
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
        self.view_Top_layer.isHidden = true
        
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
            self.lbl_Price.text = "R$ \(price)"
        }
        
        self.setupButtonText()
    }
    
    func setupButtonText() {
        //Load movie Info in Screen
        self.btn_Reset.isHidden = true
        self.btn_Play.isHidden = false
        
        //Changes as per Dinesh (Skype Call) - 15-Oct

        if (self.dic_movieData?.movies?.aluguel == "1" && (self.dic_movieData?.movies?.preco ?? "0") > "0") {
            // Paid movie
            if (self.dic_movieData?.movies?.alugado == "1") {
                // Paid movie and already rented
                
                if self.dic_movieData?.movies?.starttime != "-1" {
                    self.btn_Reset.isHidden = false
                    self.btn_Play.setTitle("Continuar Assistindo", for: .normal)
                } else {
                    self.btn_Play.setTitle("Assistir!", for: .normal)
                }

                self.lbl_HorseRemining.isHidden = false
                self.lbl_HorseRemining_Title.isHidden = false
                self.lbl_Price_Title.text = "Status:"
                self.lbl_Price.text = "Filme já alugado"
                self.lbl_Duration_Title.text = "Filme alugado até:"
                self.lbl_Duration.text = self.dic_movieData?.movies?.finalaluguel
                self.lbl_HorseRemining_Title.text = "Horas até o fim da locação:"
                self.lbl_HorseRemining.text = "\(self.dic_movieData?.movies?.restoaluguel ?? "") Horas"
            } else {
                // Paid movie but not yet rented
                self.btn_Play.setTitle("Alugue esse filme!", for: .normal)
                self.lbl_Price.isHidden = false
                self.lbl_Price_Title.isHidden = false
                self.lbl_Price_Title.text = "Preço do aluguel:"
                self.lbl_Price.text = "R$ \(self.dic_movieData?.movies?.precoaluguel ?? "")"
                self.lbl_Duration.text = "48 Horas"
                self.lbl_Duration_Title.text = "Duração Aluguel:"
            }
        } else if (self.dic_movieData?.movies?.aluguel == "0" && (self.dic_movieData?.movies?.preco ?? "0") == "0.0") {
            // Free movie

            if self.dic_movieData?.movies?.starttime != "-1" {
                self.btn_Reset.isHidden = false
                self.btn_Play.setTitle("Continuar Assistindo", for: .normal)
            } else {
                self.btn_Play.setTitle("Assistir!", for: .normal)
            }

            self.lbl_Duration.isHidden = true
            self.lbl_Duration_Title.isHidden = true
            self.lbl_Price.isHidden = true
            self.lbl_Price_Title.isHidden = true
        } else if (self.dic_movieData?.movies?.alugado == "0" && self.dic_movieData?.movies?.aluguel == "1") {
            // Paid movie but not rented
            self.btn_Play.setTitle("Alugue esse filme!", for: .normal)
            self.lbl_Price.isHidden = false
            self.lbl_Price_Title.isHidden = false
            self.lbl_Price_Title.text = "Preço:"
            self.lbl_Price.text = "R$ \(self.dic_movieData?.movies?.precoaluguel ?? "")"
            self.lbl_Duration.isHidden = true
            self.lbl_Duration_Title.isHidden = true
        } else {
            // Handle any other case

            if self.dic_movieData?.movies?.starttime != "-1" {
                self.btn_Reset.isHidden = false
                self.btn_Play.setTitle("Continuar Assistindo", for: .normal)
            } else {
                self.btn_Play.setTitle("Assistir!", for: .normal)
            }

            self.lbl_Price.isHidden = true
            self.lbl_Price_Title.isHidden = true
            self.lbl_Duration.isHidden = true
            self.lbl_Duration_Title.isHidden = true
        }
    }
}





extension UIColor{
    func hexStringToUIColor(hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
