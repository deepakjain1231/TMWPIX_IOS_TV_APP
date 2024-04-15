//
//  HomeViewController.swift
//  TMWPIX
//
//  Created by Apple on 02/08/2022.
//

import Foundation

import UIKit
import SDWebImage

class HomeViewController: TMWViewController {
    
    
    @IBOutlet weak var BackgroundImage: UIImageView!
    let radius:Int = 20
    @IBOutlet weak var filmView: UIView!
    @IBOutlet weak var channelView: UIView!
    @IBOutlet weak var seriesView: UIView!
    @IBOutlet weak var radioView: UIView!
    @IBOutlet weak var EPGView: UIView!
    @IBOutlet weak var optionView: UIView!
    @IBOutlet weak var profileView: UIView!
    
    
    var timer = Timer()
    var counter = 0
    
    var ImageUrl: [String] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Categories views Control
        
        filmView.layer.cornerRadius = CGFloat(radius)
        filmView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
//        filmView.backgroundColor = utils.getHomeButtonsBGColor()
        
        
        channelView.layer.cornerRadius = CGFloat(radius)
        channelView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
//        channelView.backgroundColor = utils.getHomeButtonsBGColor()
        
        seriesView.layer.cornerRadius = CGFloat(radius)
        seriesView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
//        seriesView.backgroundColor = utils.getHomeButtonsBGColor()
        
        radioView.layer.cornerRadius = CGFloat(radius)
        radioView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
//        radioView.backgroundColor = utils.getHomeButtonsBGColor()
        
        EPGView.layer.cornerRadius = CGFloat(radius)
        EPGView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
//        EPGView.backgroundColor = utils.getHomeButtonsBGColor()
        
        profileView.layer.cornerRadius = CGFloat(radius)
        profileView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
//        profileView.backgroundColor = utils.getHomeButtonsBGColor()
        
        optionView.layer.cornerRadius = CGFloat(radius)
        optionView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
//        optionView.backgroundColor = utils.getHomeButtonsBGColor()
        self.loadingIndicator.startAnimating()
        HomeAPI.getHomeBackgroundData(delegate: self);
        
    }
    
    func getCatrgoryBtnColor() -> UIColor{
        return UIColor(white:1, alpha: 0.25)
    }

    
    @IBAction func FilmBtnTapped(_ sender: Any) {
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "FilmSeriesViewController") as! FilmSeriesViewController
//        self.present(nextViewController, animated:true, completion:nil)
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SeriesViewController") as! SeriesViewController
        nextViewController.type = nextViewController.filmVC
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func SeriesBtnTapped(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SeriesViewController") as! SeriesViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func RadioBtnTapped(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RadioViewController") as! RadioViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func EPGBtnTapped(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "EPGViewController") as! EPGViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func OptionBtnTapped(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "OptionViewController") as! OptionViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func ProfileBtnTapped(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    @IBAction func ChannelBtnTapped(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChannelViewController") as! ChannelViewController
        nextViewController.is_home = true
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @objc func changeBackgroundImage(){
        counter += 1
        if counter == ImageUrl.count{
            counter = 0
        }
        if ImageUrl.count > 0 {
            BackgroundImage.sd_setImage(with: URL(string: ImageUrl[counter]),
                                        placeholderImage: UIImage(named: "img-background3"))
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
}

extension HomeViewController {
    func homeResponseHandler(homeData:[Home]){
        self.loadingIndicator.stopAnimating()
        for url in homeData{
            ImageUrl.append(url.url!)
        }
        if ImageUrl.count > 0 {
            BackgroundImage.sd_setImage(with: URL(string: ImageUrl[0]), placeholderImage: UIImage(named: "img-background3"))
        }
        
        if timer.isValid{
            timer.invalidate()
        }
        timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(changeBackgroundImage), userInfo: nil, repeats: true)
        
       
      
    }
}
