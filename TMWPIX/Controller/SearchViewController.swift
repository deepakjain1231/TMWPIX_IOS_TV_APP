//
//  SearchViewController.swift
//  TMWPIX
//
//  Created by Apple on 05/08/2022.
//

import Foundation

import UIKit

class SearchViewController: TMWViewController, UITextFieldDelegate {
    
    var str_search_Text = ""
    @IBOutlet weak var searchView: FilmView!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var lbl_search_Text: UILabel!
    @IBOutlet weak var selectBtn: UIButton!
    
    var categoryID = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        
        self.searchBar.delegate = self
        self.searchBar.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        self.searchView.layer.borderWidth = 2
        self.searchView.layer.borderColor = UIColor(red:0/255, green:0/255, blue:10/255, alpha: 1).cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchBar.becomeFirstResponder()
    }
    
    
    @IBAction func viewDismissed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func selectCategoryTapped(_ sender: Any) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let popupVC = storyboard.instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        let pVC = popupVC.popoverPresentationController
        pVC?.sourceRect = CGRect(x: 100, y: 100, width: 1, height: 1)
        present(popupVC, animated: true, completion: nil)
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
    
    @IBAction func searchBtnTapped(_ sender: Any) {
        self.search_action()
    }
    
    func search_action() {
        let seriesViewController = self.presentingViewController as! SeriesViewController
        if self.searchBar.text != "" || self.categoryID != -1 {
            self.dismiss(animated: true) {
                seriesViewController.searchSeriesData(txt: self.searchBar.text!, cat_id: self.categoryID)
            }
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.lbl_search_Text.textColor = .black
        self.lbl_search_Text.text = textField.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //self.search_action()
        textField.resignFirstResponder()
        return true
    }
    
    
    override func shouldUpdateFocus(in context: UIFocusUpdateContext) -> Bool {
        // Condition
        return true
    }
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        // Condition
        debugPrint(context)
    }

}
