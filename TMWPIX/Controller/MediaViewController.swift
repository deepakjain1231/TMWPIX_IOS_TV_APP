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

class MediaViewController: TMWViewController, AVPlayerViewControllerDelegate, delegateChange_Language {
    
    var counter = 5
    @IBOutlet weak var MediaView: PlayerView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var channelNumber: UILabel!
    @IBOutlet weak var channelImage: UIImageView!
    @IBOutlet weak var channelTitle: UILabel!
    @IBOutlet weak var channelName: UILabel!
    @IBOutlet weak var channelDesc: UILabel!
    
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
        channelImage.sd_setImage(with: URL(string: ImageUrl!))
        channelNumber.text = Channeltext
        channelName.text = name
        
        self.loadingIndicator.startAnimating()
        
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
        
    }
    
    func startTimer() {
        self.stopTimer()
        self.timerr = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCounter), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        self.counter = 5
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
                
                this.loadingIndicator.stopAnimating()

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
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view != self.footerView {
            self.footerView.isHidden = false
            self.startTimer()
        }
    }
    
    
    

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        self.startTimer()
    }
    

    // MARK: - IBAction

    @IBAction func openChangeAudioTapped(_ sender: Any) {
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
    
    
    @IBAction func openInformationBoxTapped(_ sender: Any) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let popupVC = storyboard.instantiateViewController(withIdentifier: "InfoViewController") as! InfoViewController
        popupVC.desc = self.desc!
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        let pVC = popupVC.popoverPresentationController
        pVC?.sourceRect = CGRect(x: 100, y: 100, width: 1, height: 1)
        present(popupVC, animated: true, completion: nil)
    }
    
//    @IBAction func goToMoveChannel(_ sender: Any) {
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChannelViewController") as! ChannelViewController
//
//        self.present(nextViewController, animated:true, completion:nil)
//    }
    @IBAction func ViewDismissed(_ sender: Any) {
        if self.player != nil {
            self.player.stop()
            self.stopTimer()
        }
        dismiss(animated: true)
    }
    
    @IBAction func menuClicked(_ sender: Any) {
        if is_epg {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChannelViewController") as! ChannelViewController
            nextViewController.is_home = false
            self.present(nextViewController, animated:true, completion:nil)
        } else {
            if self.player != nil { self.player.stop() }
            dismiss(animated: true)
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

    
    func did_changeLanguage(changed_track: Track) {
        self.selectTrack(changed_track)
        self.startTimer()
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
