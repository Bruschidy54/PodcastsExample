//
//  PlayerDetailsView.swift
//  PodcastsExample
//
//  Created by Dylan Bruschi on 8/12/18.
//  Copyright © 2018 Dylan Bruschi. All rights reserved.
//

import UIKit
import AVKit

class PlayerDetailsView: UIView {
    
    // TO DO: Create extension to factor out gesture code
    
    var episode: Episode! {
        didSet {
            miniTitleLabel.text = episode.title
            titleLabel.text = episode.title
            authorLabel.text = episode.author
            
            playEpisode()
            
            guard let url = URL(string: episode.imageUrl ?? "") else { return }
            episodeImageView.sd_setImage(with: url, completed: nil)
            miniEpisodeImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    var panGesture: UIPanGestureRecognizer!
    
    private let shrunkenTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    fileprivate func observePlayerCurrentTime() {
        let interval = CMTimeMake(1, 2)
        
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self]  (time) in
            
            self?.currentTimeLabel.text = time.toDisplayString()
            let durationTime = self?.player.currentItem?.duration
            self?.durationLabel.text = durationTime?.toDisplayString()
            
            self?.updateCurrentTimeSlider()
        }
    }
    
    private func updateCurrentTimeSlider() {
       let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
       let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(1, 1))
        let percentage = currentTimeSeconds / durationSeconds
        
        currentTimeSlider.value = Float(percentage)
    }
    
    fileprivate func setupGestures() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximize)))
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        miniPlayerView.addGestureRecognizer(panGesture)
        
        maximizedStackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismissalPan)))
    }
    
    @objc func handleDismissalPan(gesture: UIPanGestureRecognizer) {
        if gesture.state == .changed {
            let translation = gesture.translation(in: superview)
            maximizedStackView.transform = CGAffineTransform(translationX: 0, y: translation.y)
        } else if gesture.state == .ended {
            let translation = gesture.translation(in: superview)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.maximizedStackView.transform = .identity
            })
            
            if translation.y > 50 {
                UIApplication.mainTabBarController()?.minimizePlayerDetails()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        

        setupGestures()
        
        observePlayerCurrentTime()
        
        let time = CMTimeMake(1, 3)
        let times = [NSValue(time: time)]
        
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            //To prevent retain cycle
            self?.enlargeEpisodeImageView()
        }
    }
    
    fileprivate func handlePanEnded(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.transform = .identity
            
            if translation.y < -200 || velocity.y < -500 {
                UIApplication.mainTabBarController()?.maximizePlayerDetails(episode: nil)
            } else {
                self.miniPlayerView.alpha = 1
                self.maximizedStackView.alpha = 0
            }
        })
    }
    
    fileprivate func handlePanChanged(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        
        self.miniPlayerView.alpha = 1 + (translation.y / 200)
        self.maximizedStackView.alpha = -translation.y / 200
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        if gesture.state == .changed {
            handlePanChanged(gesture)
        } else if gesture.state == .ended {
            handlePanEnded(gesture)
        }
    }
    
    @objc func handleTapMaximize() {
        UIApplication.mainTabBarController()?.maximizePlayerDetails(episode: nil)
    }
    
    static func initFromNib() -> PlayerDetailsView {
        return Bundle.main.loadNibNamed("PlayerDetailsView", owner: self, options: nil)?.first as! PlayerDetailsView
        
    }
    
    //MARK:- IBActions and Outlets
    
    @IBOutlet weak var miniEpisodeImageView: UIImageView!
    
    @IBOutlet weak var miniTitleLabel: UILabel!
    
    @IBOutlet weak var miniPausePlayButton: UIButton! {
        didSet {
            miniPausePlayButton.imageEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
            miniPausePlayButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    
    
    @IBOutlet weak var miniFastForwardButton: UIButton! {
        didSet {
            miniFastForwardButton.imageEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
        }
    }
    
    @IBOutlet weak var miniPlayerView: UIView!
    
    @IBOutlet weak var maximizedStackView: UIStackView!
    
    @IBOutlet weak var currentTimeSlider: UISlider!
    
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    
    @IBAction func handleDismiss(_ sender: Any) {
        UIApplication.mainTabBarController()?.minimizePlayerDetails()
    }

    @IBOutlet weak var playPauseButton: UIButton! {
        didSet {
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            playPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    
    @objc func handlePlayPause() {
        
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            miniPausePlayButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            enlargeEpisodeImageView()
        } else {
            player.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            miniPausePlayButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            shrinkEpisodeImageView()
        }
    }
    
    
    @IBOutlet weak var episodeImageView: UIImageView! {
        didSet {
            episodeImageView.layer.cornerRadius = 5
            episodeImageView.clipsToBounds = true
            episodeImageView.transform = shrunkenTransform
            
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet{
            titleLabel.numberOfLines = 2
        }
    }
    
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBAction func handleCurrentTimeSliderChange(_ sender: Any) {
        let percentage = currentTimeSlider.value
        
        guard let duration = player.currentItem?.duration else { return }
        
        let durationInSeconds = CMTimeGetSeconds(duration)
        
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, Int32(NSEC_PER_SEC))
        player.seek(to: seekTime)
    }
    
    @IBAction func handleRewind(_ sender: Any) {
       seekToTime(delta: -15)
    }
    
    @IBAction func handleFastForward(_ sender: Any) {
        seekToTime(delta: 15)
    }
    
    private func seekToTime(delta: Int64) {
        let seconds = CMTimeMake(delta, 1)
        let seekTime = CMTimeAdd(player.currentTime(), seconds)
        player.seek(to: seekTime)
    }
    
    @IBAction func handleVolumeChange(_ sender: UISlider) {
        player.volume = sender.value
    }
    
    
    private func playEpisode() {
        
       guard let url = URL(string: episode.streamUrl) else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    private func enlargeEpisodeImageView() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.episodeImageView.transform = .identity
            
        }, completion: nil)
    }
    
    private func shrinkEpisodeImageView() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.episodeImageView.transform = self.shrunkenTransform
            
        }, completion: nil)
    }
    
}
