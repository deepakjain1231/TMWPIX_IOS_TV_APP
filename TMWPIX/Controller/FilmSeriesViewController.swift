//
//  FilmSeriesViewController.swift
//  TMWPIX
//
//  Created by Apple on 24/08/2022.
//


import Foundation
import UIKit


class FilmSeriesViewController: TMWViewController {

    var series : [FilmSeries] = []
    var image:[String] = []
//    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    var filmApi = FilmAPI()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingIndicator.startAnimating()
        print("---------------  In Film Series Controller -----------")
//        filmApi.getFilmSeriesData(delegate: self)
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

}


extension FilmSeriesViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return image.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FilmViewCell
        
        cell.filmImage.sd_setImage(with: URL(string: image[indexPath.row]))
//        cell.filmImage.sd_setImage(with: URL(string: series[indexPath.row].image!))
        
//        cell.SeriesImage.sd_imageIndicator
//        cell.SeriesImage.sd_setIndicatorStyle(.white)
//        cell.SeriesImage.sd_setImage(with: URL(string: series[indexPath.row].image!))
        return cell
    }
    
}

extension FilmSeriesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
                        UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width / 5 - 20, height: self.collectionView.frame.size.height/2 + 30)
    }
    
}

extension FilmSeriesViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let popupVC = storyboard.instantiateViewController(withIdentifier: "DetailsFilmViewController") as! DetailsFilmViewController
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        popupVC.FilmName = series[indexPath.row].name!
        popupVC.ImageUrl = series[indexPath.row].image!
//        popupVC.name = series[indexPath.row].name!
//        popupVC.image = series[indexPath.row].image!
//
        
//        let pVC = popupVC.popoverPresentationController
//        pVC?.sourceRect = CGRect(x: 100, y: 100, width: 1, height: 1)
        present(popupVC, animated: true, completion: nil)
    }
    
}

extension FilmSeriesViewController{
    
    func handleFilmSeriesData(series: [FilmSeries]) {
        self.loadingIndicator.stopAnimating()
        
        for data in series{
            image.append(data.image!)
      
        }
        self.series = series
        self.collectionView.reloadData()
    }
    
}
