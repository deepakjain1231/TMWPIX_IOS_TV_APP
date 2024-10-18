//
//  MoviePlayerViewController.swift
//  TMWPIX
//
//  Created by Apple on 03/08/2022.
//

import Foundation
import AVKit
import AVFoundation
import UIKit
import PlayKit


class MoviePlayerViewController: TMWViewController, AVPlayerViewControllerDelegate, delegateChange_Language {
    
    
    
    var Channeltext:String?
    var ImageUrl:String?
    var VideoURl:String?
    var name: String?
    var desc: String?
    
    @IBOutlet weak var MediaView: PlayerView!
    
    //Temp//@IBOutlet weak var playheadSlider: UISlider!
    @IBOutlet weak var ivPlay: UIImageView!
    @IBOutlet weak var ivStop: UIImageView!
    @IBOutlet weak var ivSubtitles: UIImageView!
    @IBOutlet weak var ivResolution: UIImageView!
    @IBOutlet weak var ivMinimize: UIImageView!
    
    var playerController = AVPlayerViewController()
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var mLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var mRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mBottomConstraint: NSLayoutConstraint!
    
    var player: Player! // Created in the viewDidLoad
    
    var vplayer: AVPlayer! // Created in the viewDidLoad
    var playerItem:AVPlayerItem?

    var audio_Tracks: [Track] = []
    var selectedTracks: [Track] = []

    enum State {
        case idle, playing, paused, ended
    }

    var state: State = .idle {
          didSet {
              switch state {
              case .idle:
                  ivPlay.image = UIImage(systemName: "play.fill")
              case .playing:
                  ivPlay.image = UIImage(systemName: "pause.fill")
              case .paused:
                  ivPlay.image = UIImage(systemName: "play.fill")
              case .ended:
                  ivPlay.image = UIImage(systemName: "play.fill")
              }
            }
        }
    
    enum MiniState {
        case full, rect
    }
    var miniState: MiniState = .full {
        didSet {
            switch miniState {
            case .full:
                ivMinimize.image = UIImage(systemName: "dot.viewfinder")
            case .rect:
                ivMinimize.image = UIImage(systemName: "viewfinder")
            }
          }
      }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadingIndicator.startAnimating()
        
        try! AVAudioSession.sharedInstance().setCategory(.playback)

        // Video Streaming
//        VideoURl = "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8"
//        guard let url = URL(string: VideoURl!) else{
//            return
//        }
        // Video Streaming
//        player = PlayKitManager.shared.loadPlayer(pluginConfig: nil)
//        handleTracks()
//        handlePlaybackInfo()
//        handlePlayheadUpdate()
//
//        preparePlayer()
//
//        player.addObserver(self, events: [PlayerEvent.canPlay]) { event in
//            self.player.play()
//        }
        
        //Temp//playheadSlider.minimumValue = 0
        
//        VideoURl = "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8"
        
        guard let url = URL(string: VideoURl ?? "") else{
            return
        }
//        vplayer = AVPlayer(url: url)
//
//        let playerLayer = AVPlayerLayer(player: vplayer)
//        view.layer.addSublayer(playerLayer)
//        playerLayer.frame =  view.frame
//        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        //
        let asset = AVURLAsset(url: url, options: nil)
        let playerItem = AVPlayerItem(asset: asset)
        vplayer = AVPlayer(playerItem: playerItem)
        vplayer?.addObserver(self, forKeyPath: "status", options: [], context: nil)
        // listen the current time of playing video
        vplayer?.addPeriodicTimeObserver(forInterval: CMTime(seconds: Double(1), preferredTimescale: 2), queue: DispatchQueue.main) { [weak self] (sec) in
            guard let self = self else { return }
            let seconds = CMTimeGetSeconds(sec)
            let (_, _, _) = self.getHoursMinutesSecondsFrom(seconds: seconds)
        }
        vplayer?.volume = 1.0
        
        
        let layer: AVPlayerLayer = AVPlayerLayer(player: vplayer)
        layer.backgroundColor = UIColor.white.cgColor
        layer.frame = MediaView.bounds
        layer.videoGravity = .resize
        MediaView.layer.sublayers?
            .filter { $0 is AVPlayerLayer }
            .forEach { $0.removeFromSuperlayer() }
        MediaView.layer.addSublayer(layer)

        /*
        //Temp//
        if let videoPlayer = vplayer {
            playheadSlider.minimumValue = 0.0
            if let duration = videoPlayer.currentItem?.asset.duration {
                let seconds = CMTimeGetSeconds(duration)
                playheadSlider.maximumValue = Float(seconds)
                playheadSlider.isHidden = false
            }
        } else {
            playheadSlider.isHidden = true
        }
        */

//        playerItem = AVPlayerItem(url: url)
//        vplayer = AVPlayer(playerItem: playerItem)
//
//        vplayer.play()
//        vplayer.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
//
//        let playerLayer = AVPlayerLayer(player: vplayer!)
//        playerLayer.frame=CGRect(x:0, y:0, width:MediaView.frame.width, height:MediaView.frame.height)
//        self.MediaView.layer.addSublayer(playerLayer)
//
//        // Add playback slider
//
//        playheadSlider.minimumValue = 0
//
//        let duration : CMTime = playerItem!.asset.duration
//        let seconds : Float64 = CMTimeGetSeconds(duration)
//
//        playheadSlider.maximumValue = Float(seconds)
//        playheadSlider.isContinuous = true

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.vplayer != nil {
            self.vplayer.pause()
            self.vplayer = nil
        }
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let player = object as? AVPlayer, player == vplayer, keyPath == "status" {
            if player.status == .readyToPlay {
                vplayer?.play()
                self.loadingIndicator.stopAnimating()
            } else if player.status == .failed {
//                stopBtnPressed(UIButton())
            }
        }

//        if keyPath == "timeControlStatus", let change = change, let newValue = change[NSKeyValueChangeKey.newKey] as? Int, let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
//            if #available(iOS 10.0, *) {
//                let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
//                let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
//                if newStatus != oldStatus {
//                    DispatchQueue.main.async {[weak self] in
//                        if newStatus == .playing || newStatus == .paused {
//                            self!.loadingIndicator.stopAnimating()
//
//                            let seconds = CMTimeGetSeconds(self!.playerItem!.asset.duration)
//                            self!.playheadSlider.maximumValue = Float(seconds)
//
//                        } else {
//                            self!.loadingIndicator.startAnimating()
//                        }
//                    }
//                }
//            } else {
//                // Fallback on earlier versions
//                self.loadingIndicator.stopAnimating()
//            }
//        }
    }
    
    //MARK: Functions
    
    func selectTrack(_ track: Track) {
        player.selectTrack(trackId: track.id)
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
            self?.loadingIndicator.stopAnimating()
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
        self.player?.addPeriodicObserver(interval: 0.2, observeOn: DispatchQueue.main, using: { (pos) in
            //Temp//self.playheadSlider.value = Float(pos)
//            self.positionLabel.text = format(pos)
        })
        // Observe duration
        self.player?.addObserver(self, events: [PlayerEvent.durationChanged], block: { (event) in
            if let e = event as? PlayerEvent.DurationChanged, let d = e.duration as? TimeInterval {
                //Temp//self.playheadSlider.maximumValue = Float(d)
//                self.durationLabel.text = format(d)
            }
        })

        player.addObserver(self, events: [PlayerEvent.play, PlayerEvent.ended, PlayerEvent.pause], block: { (event) in
            switch event {
            case is PlayerEvent.Play, is PlayerEvent.Playing:
                self.state = .playing
                
            case is PlayerEvent.Pause:
                self.state = .paused
                
            case is PlayerEvent.Ended:
                self.state = .ended
                
            default:
                break
            }
        })

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
    
    private func getHoursMinutesSecondsFrom(seconds: Double) -> (hours: Int, minutes: Int, seconds: Int) {
        let secs = Int(seconds)
        let hours = secs / 3600
        let minutes = (secs % 3600) / 60
        let seconds = (secs % 3600) % 60
        return (hours, minutes, seconds)
    }

    // MARK: - IBAction

    @IBAction func playTapped(_ sender: Any) {
        guard let player = self.vplayer else {
            print("player is not set")
            return
        }

        switch state {
        case .playing:
           player.pause()
            state = .paused
        case .idle:
            player.play()
            state = .playing
        case .paused:
            player.play()
            state = .playing
        case .ended:
            vplayer!.seek(to: CMTimeMake(value: 0, timescale: 1))
//            player.seek(to: 0)
            player.play()
            state = .playing
        }
    }

    @IBAction func stopTapped(_ sender: Any) {
        //Temp//playheadSlider.setValue(0, animated: true)
//        player.seek(to: 0)
//        player.pause()
        vplayer!.seek(to: CMTimeMake(value: 0, timescale: 1))
        vplayer.pause()
        state = .ended
    }

    @IBAction func resolutionTapped(_ sender: Any) {
        
    }

    @IBAction func minimizeTapped(_ sender: Any) {
        if miniState == .full {
            miniState = .rect
            mLeadingConstraint.constant = 16
            mRightConstraint.constant = 16
            mBottomConstraint.constant = 0
            
        } else {
            miniState = .full
            mLeadingConstraint.constant = -60
            mRightConstraint.constant = -60
            mBottomConstraint.constant = -22
        }
    }

    @IBAction func openChangeAudioTapped(_ sender: Any) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let popupVC = storyboard.instantiateViewController(withIdentifier: "AudioViewController") as! AudioViewController
        popupVC.delegate = self
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        popupVC.selectedTracks = self.selectedTracks
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
    
    @IBAction func ViewDismissed(_ sender: Any) {
        if self.vplayer != nil {
            self.vplayer.pause()
            self.vplayer = nil
    //            self.player.stop()
        }
        dismiss(animated: true)
    }
    
    @IBAction func playerSliderChanged(_ sender: Any) {
//        player.seek(to: TimeInterval(playheadSlider.value))
        
        vplayer?.pause()
        //Temp//let value = playheadSlider.value
        // seek the seconds for video
        //Temp//vplayer?.currentItem?.seek(to: CMTime(seconds: Double(value), preferredTimescale: 60000), completionHandler: { [weak self] (success) in
        //Temp//    self?.vplayer?.play()
        //Temp//})

        
//        let targetTime = CMTimeMake(value: Int64(playheadSlider.value), timescale: 1)
//        vplayer!.seek(to: targetTime)
//
//        if vplayer!.rate == 0
//        {
//            vplayer?.play()
//        }
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

    
    func did_changeLanguage(changed_track: PlayKit.Track) {
        self.selectTrack(changed_track)
    }
}
