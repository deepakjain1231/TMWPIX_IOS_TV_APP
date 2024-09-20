//
//  MediaViewController.swift
//  TMWPIX
//
//  Created by Apple on 03/08/2022.
//

import Foundation
import AVKit
import AVFoundation
import UIKit
import PlayKit
//import GoSwiftyM3U8

class MediaViewController: TMWViewController, AVPlayerViewControllerDelegate, delegateChange_Language, delegate_channelSelect {
    
    var superVC = UIViewController()
    var arr_channels : [Channel] = []
    
    var counter = 10
    //var is_openinfo = false
    var current_focusItemHint: String?
    @IBOutlet weak var MediaView: PlayerView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var titleView: UIView!
    
    @IBOutlet weak var btn_Back: UIButton!
    
    @IBOutlet weak var indicate_1: UIButton!
    @IBOutlet weak var indicate_2: UIButton!
    @IBOutlet weak var indicate_3: UIButton!
    @IBOutlet weak var indicate_4: UIView!
    
    @IBOutlet weak var channelNumber: UILabel!
    @IBOutlet weak var channelImage: UIImageView!
    @IBOutlet weak var channelTitle: UILabel!
    @IBOutlet weak var channelName: UILabel!
    @IBOutlet weak var channelDesc: UILabel!
    
    @IBOutlet weak var Indicator_view: UIActivityIndicatorView!
    
    var selected_Indx = 0
    
    var Channeltext:String?
    var ImageUrl:String?
    var VideoURl:String?
    var name: String?
    var desc: String?
    var channelID: String?

    var player: Player! // Created in the viewDidLoad
    var audio_Tracks: [Track] = []
    var selectedTracks: [Track] = []
    var is_epg = false
    var timerr: Timer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.footerView.isHidden = true
        self.titleView.accessibilityHint = "titleView"
        self.indicate_1.accessibilityHint = "indicate_1"
        self.indicate_2.accessibilityHint = "indicate_2"
        self.indicate_3.accessibilityHint = "indicate_3"
        self.indicate_4.accessibilityHint = "indicate_4"

        self.setupFocusButton("titleView")
        
        
        self.loadingIndicator.startAnimating()
        ChannelAPI.getChannelData(delegate: self)
        
//        self.setupInitialSetup()
//        
//        self.setupPlayer()
        
        /*
        channelImage.sd_setImage(with: URL(string: ImageUrl!))
        channelNumber.text = Channeltext
        channelName.text = name
        
        self.Indicator_view.isHidden = false
        
        if channelID != nil {
            ChannelAPI.getNowPlayingData(id: channelID!, delegate: self)
        }

        // Video Streaming
        player = PlayKitManager.shared.loadPlayer(pluginConfig: nil)
        handleTracks()
        handlePlaybackInfo()
        handlePlayheadUpdate()

        preparePlayer()

        player.addObserver(self, events: [PlayerEvent.canPlay]) { event in
            self.player.play()
            self.startTimer()
        }
        */
        
//        let tap_up = UITapGestureRecognizer(target: self, action: #selector(self.tapped_upClick(gesture:)))
//        tap_up.allowedTouchTypes = [NSNumber(value: UIPress.PressType.upArrow.rawValue)]
//        self.view.addGestureRecognizer(tap_up)
//        
//        let tap_down = UITapGestureRecognizer(target: self, action: #selector(self.tapped_downClick(gesture:)))
//        tap_down.allowedTouchTypes = [NSNumber(value: UIPress.PressType.downArrow.rawValue)]
//        self.view.addGestureRecognizer(tap_down)
        
//        let tap_left = UITapGestureRecognizer(target: self, action: #selector(self.tapped_leftClick(gesture:)))
//        tap_left.allowedTouchTypes = [NSNumber(value: UIPress.PressType.leftArrow.rawValue)]
//        self.view.addGestureRecognizer(tap_left)
        
//        let tap_right = UITapGestureRecognizer(target: self, action: #selector(self.tapped_rightClick(gesture:)))
//        tap_right.allowedTouchTypes = [NSNumber(value: UIPress.PressType.rightArrow.rawValue)]
//        self.view.addGestureRecognizer(tap_right)
        
        let tap_up = UISwipeGestureRecognizer(target: self, action: #selector(self.tapped_upClick(gesture:)))
        tap_up.direction = .up
        self.view.addGestureRecognizer(tap_up)
        
        let tap_down = UISwipeGestureRecognizer(target: self, action: #selector(self.tapped_downClick(gesture:)))
        tap_down.direction = .down
        self.view.addGestureRecognizer(tap_down)
        
        let tap_left = UISwipeGestureRecognizer(target: self, action: #selector(self.tapped_leftClick(gesture:)))
        tap_left.direction = .left
        self.view.addGestureRecognizer(tap_left)
        
        let tap_right = UISwipeGestureRecognizer(target: self, action: #selector(self.tapped_rightClick(gesture:)))
        tap_right.direction = .right
        self.view.addGestureRecognizer(tap_right)
    }
    
    func setupFocusButton(_ current_focus: String) {
        self.current_focusItemHint = current_focus
        self.btn_Back.layer.borderWidth = 0.0
        self.indicate_1.layer.borderWidth = 0.0
        self.indicate_2.layer.borderWidth = 0.0
        self.indicate_3.layer.borderWidth = 0.0
        self.titleView.layer.borderWidth = 0.0
        self.btn_Back.layer.cornerRadius = 12
        self.indicate_1.layer.cornerRadius = 12
        self.indicate_2.layer.cornerRadius = 12
        self.indicate_3.layer.cornerRadius = 12
        self.btn_Back.layer.borderColor = UIColor.white.cgColor
        self.indicate_1.layer.borderColor = UIColor.white.cgColor
        self.indicate_2.layer.borderColor = UIColor.white.cgColor
        self.indicate_3.layer.borderColor = UIColor.white.cgColor
        self.titleView.layer.borderColor = UIColor.fromHex(hexString: "#DE003F").cgColor
        if current_focus == "titleView" {
            self.titleView.layer.borderWidth = 2.0
        }
        else if current_focus == "indicate_1" {
            self.indicate_1.layer.borderWidth = 2.0
        }
        else if current_focus == "indicate_2" {
            self.indicate_2.layer.borderWidth = 2.0
        }
        else if current_focus == "indicate_3" {
            self.indicate_3.layer.borderWidth = 2.0
        }
    }

    func setupPlayer() {
        // Video Streaming
        player = PlayKitManager.shared.loadPlayer(pluginConfig: nil)
        handleTracks()
        handlePlaybackInfo()
        handlePlayheadUpdate()

        preparePlayer()

        player.addObserver(self, events: [PlayerEvent.canPlay]) { event in
            self.player.play()
            self.startTimer()
        }
    }
    
    func setupInitialSetup() {
        self.loadingIndicator.startAnimating()
        
        if let str_channel = self.channelID, str_channel != "" {
            ChannelAPI.getNowPlayingData(id: str_channel, delegate: self)
        }
    }
    
//    override var preferredFocusedView: UIView? {
//        get {
//            return self.titleView
//        }
//    }
    
    func startTimer() {
        guard self.timerr == nil else { return }
        
        self.stopTimer()
        self.timerr = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCounter), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        self.counter = 10
        self.footerView.isHidden = false
        self.timerr?.invalidate()
        self.timerr = nil
    }
    
    @objc func updateCounter() {
        //example functionality
        debugPrint(counter)
        if counter > 0 {
            counter -= 1
        }
        else {
            self.footerView.isHidden = true
            self.timerr?.invalidate()
            self.timerr = nil
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopExistingPlayer()
    }
    
    func stopExistingPlayer() {
        if self.player != nil {
            self.player.stop()
            self.stopTimer()
        }
    }
    
    //MARK: Functions
    
    func selectTrack(_ track: Track) {
        player.selectTrack(trackId: track.id)
    }
    
    func reloadPlayer() {
        self.channelImage.sd_setImage(with: URL(string: ImageUrl!))
        self.channelNumber.text = Channeltext
        self.channelName.text = self.name

        ChannelAPI.getNowPlayingData(id: self.channelID!, delegate: self)
        self.player.stop()
        self.preparePlayer()
    }
    
    func preparePlayer() {
        // Setup the player's view
        player.view = self.MediaView
        MediaView.sendSubviewToBack(self.player.view!)
       
        // Uncomment the type of media needed
        let mediaEntry = getMediaWithInternalSubtitles()
        
        // Create media config
        let mediaConfig = MediaConfig(mediaEntry: mediaEntry)
        
        // Set if we want the player to auto select the subtitles.
        player.settings.trackSelection.textSelectionMode = .auto
        player.settings.trackSelection.textSelectionLanguage = "en"
        
        // Prepare the player
        player.prepare(mediaConfig)
    }

    func getMediaWithInternalSubtitles() -> PKMediaEntry {
        // Create media source and initialize a media entry with that source
        let entryId = "bipbop_16x9"
        let source = PKMediaSource(entryId, contentUrl: URL(string: VideoURl!), drmData: nil, mediaFormat: .hls)
        
        // Setup media entry
        let mediaEntry = PKMediaEntry(entryId, sources: [source], duration: -1)
        // If we set external subtitles, they will be ignored.
        
        return mediaEntry
    }

    func handleTracks() {
        player.addObserver(self, events: [PlayerEvent.tracksAvailable, PlayerEvent.textTrackChanged, PlayerEvent.audioTrackChanged], block: { [weak self] (event: PKEvent) in
            if type(of: event) == PlayerEvent.tracksAvailable {
                guard let this = self else { return }
                
//                this.loadingIndicator.stopAnimating()
                self?.Indicator_view.isHidden = true

                if let tracks = event.tracks?.audioTracks {
                    this.audio_Tracks = tracks
                    this.selectedTracks = this.audio_Tracks
                }
                
            } else if type(of: event) == PlayerEvent.textTrackChanged {
                print("selected text track: \(event.selectedTrack?.title ?? "")")
            } else if type(of: event) == PlayerEvent.audioTrackChanged {
                print("selected audio track: \(event.selectedTrack?.title ?? "")")
            }
        })
        player.addObserver(self, event: PlayerEvent.videoTrackChanged) { event in
            if type(of: event) == PlayerEvent.videoTrackChanged {
                if let _ = event.playbackInfo {
                    print("\(event.playbackInfo!)")
                }
            }
        }
    }
    
    func handlePlaybackInfo() {
        player.addObserver(self, event: PlayerEvent.playbackInfo) { event in
            if type(of: event) == PlayerEvent.playbackInfo {
                if let _ = event.playbackInfo {
                    print("\(event.playbackInfo!)")
                }
            }
        }
    }
    
    func handlePlayheadUpdate() {
        player.addObserver(self, event: PlayerEvent.playheadUpdate, block: { [weak self] (event) in
            guard let self = self else { return }
        })
    }
    
    
    
    @objc func tapped_downClick(gesture: UITapGestureRecognizer) {
            // do something
        debugPrint("Next Channel")
        self.stopTimer()
        self.selected_Indx += 1
        self.nextChannel()
    }
    
    @objc func tapped_upClick(gesture: UITapGestureRecognizer) {
            // do something
        debugPrint("Next Channel")
        self.selected_Indx -= 1
        self.nextChannel()
    }
    
    @objc func tapped_leftClick(gesture: UITapGestureRecognizer) {
        // do something
        debugPrint("Left Clicked")
        self.stopTimer()
        self.startTimer()
        if self.current_focusItemHint == "indicate_1" {
            self.setupFocusButton("indicate_2")
        }
        else if self.current_focusItemHint == "indicate_2" {
            self.setupFocusButton("indicate_3")
        }
        else if self.current_focusItemHint == "indicate_3" {
            self.setupFocusButton("titleView")
        }
    }

    @objc func tapped_rightClick(gesture: UITapGestureRecognizer) {
        // do something
        debugPrint("Right Clicked")
        self.stopTimer()
        self.startTimer()
        if self.current_focusItemHint == "titleView" {
            self.setupFocusButton("indicate_3")
        }
        else if self.current_focusItemHint == "indicate_3" {
            self.setupFocusButton("indicate_2")
        }
        else if self.current_focusItemHint == "indicate_2" {
            self.setupFocusButton("indicate_1")
        }
    }
    
    
    func movetochannel() {
        self.nextChannel()
    }
    
//    private func manageButtonClickEvent(click_type: String) {
//        if self.is_openinfo == false {
//            self.startTimer()
//            if click_type == "UIKeyInputUpArrow" {
//                //                if self.current_focusItemHint == "back" {
//                //
//                //                    debugPrint("Previous Channel")
//                //
//                //                    DispatchQueue.main.asyncDeduped(target: self, after: 0.75) { [weak self] in
//                //                        guard let self = self else { return }
//                //                        selected_Indx -= 1
//                //                        self.nextChannel()
//                //                    }
//                //
//                //                }
//                //else
//                if self.current_focusItemHint == "titleView" ||
//                    self.current_focusItemHint == "indicate_1" ||
//                    self.current_focusItemHint == "indicate_2" ||
//                    self.current_focusItemHint == "indicate_3" {
//                    self.selected_Indx -= 1
//                    self.nextChannel()
//                }
//            }
//            else if click_type == "UIKeyInputDownArrow" {
//                //                if self.current_focusItemHint == "back" {
//                //                    self.setupFocusButton("titleView")
//                //                }
//                //else
//                if self.current_focusItemHint == "titleView" ||
//                    self.current_focusItemHint == "indicate_1" ||
//                    self.current_focusItemHint == "indicate_2" ||
//                    self.current_focusItemHint == "indicate_3" {
//                    debugPrint("Next Channel")
//                    
//                    self.selected_Indx += 1
//                    self.nextChannel()
//                }
//            }
//            else if click_type == "UIKeyInputLeftArrow" {
//                if self.current_focusItemHint == "indicate_1" {
//                    self.setupFocusButton("indicate_2")
//                }
//                else if self.current_focusItemHint == "indicate_2" {
//                    self.setupFocusButton("indicate_3")
//                }
//                else if self.current_focusItemHint == "indicate_3" {
//                    self.setupFocusButton("titleView")
//                }
//            }
//            else if click_type == "UIKeyInputRightArrow" {
//                if self.current_focusItemHint == "titleView" {
//                    self.setupFocusButton("indicate_3")
//                }
//                else if self.current_focusItemHint == "indicate_3" {
//                    self.setupFocusButton("indicate_2")
//                }
//                else if self.current_focusItemHint == "indicate_2" {
//                    self.setupFocusButton("indicate_1")
//                }
//            }
//            else {
//                if click_type == "\r" {
//                    if self.current_focusItemHint == "back" {
//                        self.back_action()
//                    }
//                    else if self.current_focusItemHint == "indicate_3" {
//                        self.click_menu()
//                    }
//                    else if self.current_focusItemHint == "indicate_2" {
//                        self.click_info()
//                    }
//                    else if self.current_focusItemHint == "indicate_1" {
//                        self.change_audio()
//                    }
//                }
//            }
//        }
//        else {
//            if self.current_focusItemHint == "indicate_2" {
//                self.is_openinfo = false
//                self.presentedViewController?.dismiss(animated: true)
//            }
//        }
//        
//
//        
//        
//        
//
//        
////        if self.current_focusItemHint == "up" && anyPress?.key?.characters == "UIKeyInputUpArrow" {
////            DispatchQueue.main.asyncDeduped(target: self, after: 0.75) { [weak self] in
////                guard let self = self else { return }
////                
////                selected_Indx -= 1
////                self.nextChannel()
////            }
////            
////        }
////        else 
////        if self.current_focusItemHint == "bottom" && anyPress?.key?.characters == "UIKeyInputDownArrow" {
////            DispatchQueue.main.asyncDeduped(target: self, after: 0.75) { [weak self] in
////                guard let self = self else { return }
////                
////                selected_Indx += 1
////                self.nextChannel()
////            }
////            
////        }
//        
//    }
    
    func nextChannel () {
        if self.selected_Indx == -1 {
            self.selected_Indx = 0
            return
        }

        if (self.arr_channels.count - 1) >= self.selected_Indx {
            self.ImageUrl = self.arr_channels[self.selected_Indx].image ?? ""
            self.VideoURl = self.arr_channels[self.selected_Indx].url ?? ""
            self.name = self.arr_channels[self.selected_Indx].name ?? ""
            self.desc = self.arr_channels[self.selected_Indx].description ?? ""
            self.channelID = "\(self.arr_channels[self.selected_Indx].id ?? 0)"
            self.Channeltext = String(self.arr_channels[self.selected_Indx].number ?? 0)
            
            self.channelImage.sd_setImage(with: URL(string: ImageUrl ?? ""))
            self.channelNumber.text = Channeltext
            self.channelName.text = name
            
            DispatchQueue.main.asyncDeduped(target: self, after: 0.75) { [weak self] in
                guard let self = self else { return }
                self.setupScreenData()
            }
            //self.setupInitialSetup()
            //self.setupPlayer()
            //self.reloadPlayer()
        }
    }
    
    func change_audio() {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let popupVC = storyboard.instantiateViewController(withIdentifier: "AudioViewController") as! AudioViewController
        popupVC.delegate = self
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        popupVC.selectedTracks = self.selectedTracks
//        popupVC.currentTrack = self.player.currentAudioTrack!
        let pVC = popupVC.popoverPresentationController
        pVC?.sourceRect = CGRect(x: 100, y: 100, width: 1, height: 1)
        present(popupVC, animated: true, completion: nil)
    }
    
    func click_info() {
        //self.is_openinfo = true
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let popupVC = storyboard.instantiateViewController(withIdentifier: "InfoViewController") as! InfoViewController
        popupVC.desc = self.desc!
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        let pVC = popupVC.popoverPresentationController
        pVC?.sourceRect = CGRect(x: 100, y: 100, width: 1, height: 1)
        present(popupVC, animated: true, completion: nil)
    }
    
    func click_menu() {
//        if is_epg {
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChannelViewController") as! ChannelViewController
//            nextViewController.is_home = false
//            self.present(nextViewController, animated:true, completion:nil)
//        } else {
            if self.player != nil { self.player.stop() }

            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let popupVC = storyboard.instantiateViewController(withIdentifier: "ChannelViewController") as! ChannelViewController
            popupVC.channels = self.arr_channels
            popupVC.is_home = true
            popupVC.delegate = self
        popupVC.selected_channel = self.selected_Indx
                //self.navigationController?.pushViewController(popupVC, animated: true)

            popupVC.modalPresentationStyle = .fullScreen
            let pVC = popupVC.popoverPresentationController
            pVC?.sourceRect = CGRect(x: 100, y: 100, width: 1, height: 1)
            self.present(popupVC, animated: true, completion: nil)
            //}
            
                
        //}
    }
    
    func clickButton_Action() {
        if self.current_focusItemHint == "indicate_1" {
            self.change_audio()
        }
        else if self.current_focusItemHint == "indicate_2" {
            self.click_info()
        }
        else if self.current_focusItemHint == "indicate_3" {
            self.click_menu()
        }
    }
    

    // MARK: - IBAction
    @IBAction func openChangeAudioTapped(_ sender: Any) {
        self.clickButton_Action()
    }
    
    @IBAction func openInformationBoxTapped(_ sender: Any) {
        self.clickButton_Action()
    }
    
    @IBAction func menuClicked(_ sender: Any) {
        self.clickButton_Action()
    }
    
    func back_action() {
        self.dismiss(animated: true) {
            self.stopExistingPlayer()
        }
    }
    
    @IBAction func btn_Dismiss_Action(_ sender: Any) {
        self.back_action()
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

    
    func did_changeLanguage(changed_track: Track) {
        self.selectTrack(changed_track)
        self.startTimer()
    }
    
    func change_channel_selection(_ suucess: Bool, indx: Int) {
        if suucess {
            self.stopExistingPlayer()
            self.selected_Indx = indx
            self.nextChannel()
        }
    }
}


extension MediaViewController {
    func channelPlayingResponseHandler(playingData: [NowPlaying]){
        if playingData.count > 0 {
            channelDesc.text = "Atual: \(playingData[0].agoratitulo!)\nPróximo: \(playingData[0].depoistitulo!)"
            self.desc = playingData[0].descricao
        }
    }
}


//MARK: - API CALL and Handle Response
extension MediaViewController {
    func channelResponseHandler(ChannelData:[Channel]){
        self.loadingIndicator.stopAnimating()
        self.arr_channels = ChannelData
        self.footerView.isHidden = false
        
        if self.is_epg {
            self.stopExistingPlayer()
            if let indx = self.arr_channels.firstIndex(where: { dic_channel in
                return "\(dic_channel.id ?? 0)" == self.channelID
            }) {
                self.selected_Indx = indx
            }
            self.channelImage.sd_setImage(with: URL(string: ImageUrl ?? ""))
            self.channelNumber.text = self.Channeltext
            self.channelName.text = self.name
            self.setupScreenData()
        }
        else {
            self.open_firstChannel()
        }
    }
    
    func open_firstChannel() {
        if self.arr_channels.count != 0 {
            self.stopExistingPlayer()
            self.ImageUrl = self.arr_channels[0].image ?? ""
            self.VideoURl = self.arr_channels[0].url ?? ""
            self.name = self.arr_channels[0].name ?? ""
            self.desc = self.arr_channels[0].description ?? ""
            self.channelID = "\(self.arr_channels[0].id ?? 0)"
            self.Channeltext = String(self.arr_channels[0].number ?? 0)
            self.is_epg = false
            self.selected_Indx = 0
            
            self.channelImage.sd_setImage(with: URL(string: ImageUrl ?? ""))
            self.channelNumber.text = self.Channeltext
            self.channelName.text = self.name
            
            self.setupScreenData()
        }
    }
    
    func setupScreenData() {

        self.Indicator_view.isHidden = false
        
        if let str_channel_id = channelID, str_channel_id != "" {
            ChannelAPI.getNowPlayingData(id: str_channel_id, delegate: self)
        }

        // Video Streaming
        player = PlayKitManager.shared.loadPlayer(pluginConfig: nil)
        handleTracks()
        handlePlaybackInfo()
        handlePlayheadUpdate()

        preparePlayer()

        player.addObserver(self, events: [PlayerEvent.canPlay]) { event in
            self.player.play()
            self.startTimer()
        }
    }
}
