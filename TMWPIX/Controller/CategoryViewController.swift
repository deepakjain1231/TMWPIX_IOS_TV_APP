//
//  CategoryViewController.swift
//  TMWPIX
//
//  Created by Apple on 25/08/2022.
//

import Foundation

import UIKit


class CategoryViewController: TMWViewController {

    var categoryData : [Catagory] = []
    
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var categoryView: FilmView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingIndicator.startAnimating()
        FilmAPI.getFilmCategoryData(delegate: self)
        self.categoryView.layer.borderWidth = 5
        self.categoryView.layer.borderColor = UIColor(red:0/255, green:0/255, blue:10/255, alpha: 1).cgColor
        
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


extension CategoryViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryData.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CategoryViewCell
        cell.categoryName.text = categoryData[indexPath.row].nome!
        return cell
    }
    
}

extension CategoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
                        UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width - 20, height: self.collectionView.frame.size.height/8)
    }
    
}

extension CategoryViewController : UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = self.presentingViewController as? SearchViewController {
            vc.categoryID = self.categoryData[indexPath.row].id!
            vc.selectBtn.setTitle("Selecionar categoria: " + categoryData[indexPath.row].nome!, for: .normal)
        }
        self.dismiss(animated: true, completion: nil)
    }

}

extension CategoryViewController{

    func handleCategoryData(category: [Catagory]) {
        self.loadingIndicator.stopAnimating()

        self.categoryData = category
        self.collectionView.reloadData()
    }
    
}
