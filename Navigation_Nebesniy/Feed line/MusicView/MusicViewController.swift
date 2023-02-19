//
//  MusicViewController.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 17.02.2023.
//

import UIKit
import AVFoundation

class MusicViewController: UIViewController {

    var Player = AVAudioPlayer()
    private lazy var coverSong = UIImageView()
    private lazy var trackNameLabel = UILabel()
    private lazy var stackForButton = UIStackView()
    private lazy var playtButton = UIButton()
    private lazy var stopButton = UIButton()
    private lazy var nextButton = UIButton()
    private lazy var previousButton = UIButton()
    private lazy var nomberOfTrack: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setupCoverSong()
        setuptrackNameLabel()
        setupStackForButton()
        setupPlayButton()
        setupStopButton()
        setupPreviousButton()
        setupNextButton()
        playSound(index: nomberOfTrack)
    }

    private func setupCoverSong() {
        coverSong.translatesAutoresizingMaskIntoConstraints = false
        coverSong.clipsToBounds = true

        self.view.addSubview(coverSong)

        NSLayoutConstraint.activate([
            self.coverSong.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.coverSong.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -50),
            self.coverSong.heightAnchor.constraint(equalToConstant: 200),
            self.coverSong.widthAnchor.constraint(equalToConstant: 200),
            ])
    }

    private func setuptrackNameLabel() {
        trackNameLabel.translatesAutoresizingMaskIntoConstraints = false
        trackNameLabel.numberOfLines = 1
        trackNameLabel.textAlignment = .center

        self.view.addSubview(trackNameLabel)

        NSLayoutConstraint.activate([
            self.trackNameLabel.topAnchor.constraint(equalTo: self.coverSong.bottomAnchor, constant: 16),
            self.trackNameLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            self.trackNameLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            self.trackNameLabel.heightAnchor.constraint(equalToConstant: 32),
            ])
    }

    private func setupStackForButton() {
        stackForButton.axis = .horizontal
        stackForButton.spacing = 16
        stackForButton.distribution = .fillEqually
        stackForButton.clipsToBounds = true
        stackForButton.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(stackForButton)

        NSLayoutConstraint.activate([
            self.stackForButton.topAnchor.constraint(equalTo: self.trackNameLabel.bottomAnchor, constant: 16),
            self.stackForButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.stackForButton.heightAnchor.constraint(equalToConstant: 20),
                ])
    }

    private func setupPlayButton() {
        playtButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playtButton.translatesAutoresizingMaskIntoConstraints = false
        playtButton.addTarget(self, action:  #selector(playButtonDidTap), for: .touchUpInside)

        self.stackForButton.addArrangedSubview(playtButton)
    }

    private func setupStopButton() {
        stopButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        stopButton.addTarget(self, action:  #selector(stopButtonDidTap), for: .touchUpInside)

        self.stackForButton.addArrangedSubview(stopButton)
    }

    private func setupPreviousButton() {
        previousButton.setImage(UIImage(systemName: "backward.fill"), for: .normal)
        previousButton.translatesAutoresizingMaskIntoConstraints = false
        previousButton.addTarget(self, action:  #selector(previousButtonDidTap), for: .touchUpInside)

        self.stackForButton.addArrangedSubview(previousButton)
    }

    private func setupNextButton() {
        nextButton.setImage(UIImage(systemName: "forward.fill"), for: .normal)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.addTarget(self, action:  #selector(nextButtonDidTap), for: .touchUpInside)

        self.stackForButton.addArrangedSubview(nextButton)
    }

    private func playSound(index: Int) {
        do {
            Player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: Music[index].name, ofType: "mp3")!))
            Player.prepareToPlay()
            trackNameLabel.text = Music[index].text
            coverSong.image = Music[index].image
        }
        catch {
            print(error)
        }
    }

    @objc private func playButtonDidTap() {
        if Player.isPlaying {
            self.playtButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            Player.pause()
        } else {
            playtButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            Player.play()
        }
    }

    @objc private func stopButtonDidTap() {
        if Player.isPlaying {
            self.playtButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            Player.stop()
            Player.currentTime = 0
        }
        else {
            Player.currentTime = 0
            print("Already stopped!")
        }
    }

    @objc private func nextButtonDidTap() {
        if nomberOfTrack < Music.count - 1 {
            nomberOfTrack += 1
            playSound(index: nomberOfTrack)
            self.playtButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            Player.play()
        } else {
            print("It isn't next Sound!")
        }
    }

    @objc private func previousButtonDidTap() {
        if nomberOfTrack > 0 {
            nomberOfTrack -= 1
            playSound(index: nomberOfTrack)
            self.playtButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            Player.play()
        } else {
            print("It isn't previous Sound!")
        }
    }
}
