//
//  TMWViewController.swift
//  TMWPIX
//
//  Created by Apple on 01/09/2022.
//

import UIKit

class TMWViewController: UIViewController {
#if TARGET_OS_IOS
    
    override public var shouldAutorotate: Bool {
        return false
      }
      override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
      }
      override public var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeLeft
      }
#endif
    
    var loadingIndicator: UIActivityIndicatorView!
    var allButtons: [UIButton] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        loadingIndicator = self.activityIndicator(style: .whiteLarge,
                                                  center: self.view.center)
        self.view.addSubview(loadingIndicator)
        
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.stopAnimating()
        
        allButtons = []
        self.setAllButtons(view: self.view)
        
        _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            for child in self.allButtons {
                child.isEnabled = !self.loadingIndicator.isAnimating
            }
            if !self.loadingIndicator.isAnimating {
                timer.invalidate()
            }
//            print("Timer fired!")
        }

    }

    private func activityIndicator(style: UIActivityIndicatorView.Style = .medium,
                                   frame: CGRect? = nil,
                                   center: CGPoint? = nil) -> UIActivityIndicatorView {
        
        let activityIndicatorView = UIActivityIndicatorView(style: style)
        
        if let frame = frame {
            activityIndicatorView.frame = frame
        }
        
        if let center = center {
            activityIndicatorView.center = center
        }
        
        return activityIndicatorView
    }

    func setAllButtons(view: UIView)  {

        for insideView in view.subviews {
            if insideView.subviews.count > 0 {
                self.setAllButtons(view: insideView)
            }
            else if (insideView.isKind(of: UIButton.self)) {
                print("existing")
                allButtons.append(insideView as! UIButton)
            }
        }
    }
}


