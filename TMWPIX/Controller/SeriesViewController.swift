//
//  SeriesViewController.swift
//  TMWPIX
//
//  Created by Apple on 05/08/2022.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

class SeriesViewController: TMWViewController {
    
    let filmVC = 1
    var series : [Series] = []
    var films : [FilmSeries] = []
    var allSeries : [Series] = []
    var allFilms : [FilmSeries] = []
    var type: Int = 0
    
    var str_search_Text = ""
    let downloader = ImageDownloader()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblNoResult: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingIndicator.startAnimating()
        if(self.type == filmVC){
            FilmAPI.getFilmSeriesData(delegate: self)
        }else{
            SeriesAPI.getSeriesData(delegate: self)
        }
        
        // Do any additional setup after loading the view.
        
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
    
    @IBAction func menuBtnTapped(_ sender: Any) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let popupVC = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        popupVC.str_search_Text = self.str_search_Text
        popupVC.modalPresentationStyle = .overFullScreen
        popupVC.modalTransitionStyle = .crossDissolve
        let pVC = popupVC.popoverPresentationController
        pVC?.sourceRect = CGRect(x: 100, y: 100, width: 1, height: 1)
        present(popupVC, animated: true, completion: nil)
    }
    
    
}


extension SeriesViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(type == filmVC){
            return films.count
        }else{
            return series.count
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SeriesViewCell
        
        if(type == filmVC){
            let str_img = films[indexPath.row].image ?? ""
            
            if let imgURL = URL(string: "\(str_img)") {
                let request: URLRequest = URLRequest(url: imgURL)
                let mainQueue = OperationQueue.main
                NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                    if error == nil {
                        // Convert the downloaded data in to a UIImage object
                        cell.SeriesImage.image = UIImage(data: data!)
                    } else {
                        cell.SeriesImage = nil
                    }
                })
            }
          
            
            //cell.SeriesImage.af.setImage(withURL: URL(string: films[indexPath.row].image ?? "")!)
            
            //cell.SeriesImage.sd_setImage(with: URL(string: films[indexPath.row].image ?? ""))
            cell.StarImage.isHidden = films[indexPath.row].aluguel != 2
            
        }else{
            cell.SeriesImage.sd_setImage(with: URL(string: series[indexPath.row].image ?? ""))
            cell.StarImage.isHidden = series[indexPath.row].aluguel != 2
        }
        
        return cell
    }
    
}

extension SeriesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
                        UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width / 5 - 8, height: self.collectionView.frame.size.height/2 + 30)
    }
    
}

extension SeriesViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        if (type == filmVC) {
            // Load Films detail
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let popupVC = storyboard.instantiateViewController(withIdentifier: "DetailsFilmViewController") as! DetailsFilmViewController
            popupVC.modalPresentationStyle = .overCurrentContext
            popupVC.modalTransitionStyle = .crossDissolve
            popupVC.FilmName = films[indexPath.row].name!
            popupVC.ImageUrl = films[indexPath.row].image!
            popupVC.FilmID = "\(films[indexPath.row].id!)"
            popupVC.aluguel = films[indexPath.row].aluguel!
            present(popupVC, animated: true, completion: nil)
            
        }else{
            let popupVC = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
            popupVC.name = series[indexPath.row].name!
            popupVC.image = series[indexPath.row].image!
            popupVC.id = series[indexPath.row].id
            popupVC.modalPresentationStyle = .overCurrentContext
            popupVC.modalTransitionStyle = .crossDissolve
            let pVC = popupVC.popoverPresentationController
            pVC?.sourceRect = CGRect(x: 100, y: 100, width: 1, height: 1)
            present(popupVC, animated: true, completion: nil)
        }
        
        
    }
    
}

extension SeriesViewController{
    
    func handleSeriesData(series: [Series]) {
        self.loadingIndicator.stopAnimating()
        self.allSeries = series
        self.series = series
        collectionView.reloadData()
    }
    
    func handleFilmSeriesData(films: [FilmSeries]) {
        self.loadingIndicator.stopAnimating()
        self.films = films
        self.allFilms = films
        collectionView.reloadData()
    }
    
    func searchSeriesData(txt: String, cat_id: Int) {
        self.str_search_Text = txt
        if txt.isEmpty && cat_id == -1 { return }
        
        if (type == filmVC) {
            self.films = []
            for child in self.allFilms {
                if cat_id != -1 {
                    if txt.isEmpty {
                        if ((child.category?.contains(cat_id.description)) != nil){
                            if child.image != nil {
                                self.films.append(child)
                            }
                        }
                    } else if ((child.category?.contains(cat_id.description)) != nil) && child.name?.lowercased().range(of: txt.lowercased()) != nil {
                        if child.image != nil {
                            self.films.append(child)
                        }
                    }
                    
                } else if child.name?.lowercased().range(of: txt.lowercased()) != nil {
                    if child.image != nil {
                        self.films.append(child)
                    }
                }
            }
            if self.films.count == 0 {
                self.lblNoResult.isHidden = false
            }
            else {
                self.lblNoResult.isHidden = true
            }

        } else {
            self.series = []
            for child in self.allSeries {
                if cat_id != -1 {
                    if txt.isEmpty {
                        if child.category?.contains(cat_id.description) ?? false {
                            self.series.append(child)
                        }
                    } else if child.category?.contains(cat_id.description) ?? false && child.name?.lowercased().range(of: txt.lowercased()) != nil {
                        self.series.append(child)
                    }
                } else if child.name?.lowercased().range(of: txt.lowercased()) != nil {
                    self.series.append(child)
                }
            }
            if self.series.count == 0 {
                self.lblNoResult.isHidden = false
            }
        }
        
        collectionView.reloadData()
    }

}
