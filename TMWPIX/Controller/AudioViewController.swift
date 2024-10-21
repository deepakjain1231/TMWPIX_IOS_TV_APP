//
//  AudioViewController.swift
//  TMWPIX
//
//  Created by Apple on 22/08/2022.
//

protocol delegateChange_Language {
    func did_changeLanguage(changed_track: Track)
}

import Foundation
import PlayKit

import UIKit

class AudioViewController: TMWViewController {
    
    var delegate: delegateChange_Language?
    @IBOutlet weak var portuguesBtn: UIButton!
    @IBOutlet weak var inglesBtn: UIButton!
    @IBOutlet weak var btn_close: UIButton!
    
    var selectedTracks: [Track] = []
    var currentTrack = ""
    var is_selected = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        inglesBtn.isHidden = true
        
        if selectedTracks.count > 0 {
            if currentTrack == selectedTracks[0].id || selectedTracks.count == 1 {
                portuguesBtn.setTitleColor(UIColor.systemOrange, for: UIControl.State.normal)
            }
        }
        if selectedTracks.count == 1 {
            if selectedTracks[0].title == "English" {
                inglesBtn.isHidden = false
                inglesBtn.setTitleColor(UIColor.systemOrange, for: UIControl.State.normal)
            }
        }
        else if selectedTracks.count > 1 {
            inglesBtn.isHidden = false
            
            if selectedTracks.count == 2 {
                if currentTrack == selectedTracks[0].id {
                    portuguesBtn.setTitleColor(UIColor.systemOrange, for: UIControl.State.normal)
                }
                else {
                    inglesBtn.setTitleColor(UIColor.systemOrange, for: UIControl.State.normal)
                }
            }
        }
    }
    
    override var preferredFocusedView: UIView? {
        get {
            if self.is_selected == "portuguesBtn" {
                return self.portuguesBtn
            }
            else if self.is_selected == "inglesBtn" {
                return self.inglesBtn
            }
            return self.btn_close
        }
    }
    
    @IBAction func portuguesTapped(_ sender: Any) {
        portuguesBtn.setTitleColor(.systemOrange, for: .normal)
        inglesBtn.setTitleColor(.white, for: .normal)
        
        if self.selectedTracks.count > 0 {
            self.delegate?.did_changeLanguage(changed_track: self.selectedTracks[0])
        }
        self.dismiss(animated: true)
        
        dismiss(animated: true) {
            if let vc = self.presentingViewController as? MediaViewController {
                if self.selectedTracks.count > 0 {
                    vc.selectTrack(self.selectedTracks[0])
                }
            }
        }
    }
    
    @IBAction func inglesTapped(_ sender: Any) {
        portuguesBtn.setTitleColor(.white, for: .normal)
        inglesBtn.setTitleColor(.systemOrange, for: .normal)
        
        var changed_track = self.selectedTracks[0]
        if self.selectedTracks.count > 1 {
            changed_track = self.selectedTracks[1]
        } else if self.selectedTracks.count == 1 {
            changed_track = self.selectedTracks[0]
        }
        self.delegate?.did_changeLanguage(changed_track: changed_track)
        self.dismiss(animated: true)
        
        
        
        
        dismiss(animated: true) {
            if let vc = self.presentingViewController as? MediaViewController {
                if self.selectedTracks.count > 1 {
                    vc.selectTrack(self.selectedTracks[1])
                } else if self.selectedTracks.count == 1 {
                    vc.selectTrack(self.selectedTracks[0])
                }
            }
        }

    }
    
    @IBAction func viewDismissed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
