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
    private lazy var trackNameLabel = UILabel()
    private lazy var playtButton = UIButton()
    private lazy var stopButton = UIButton()
    private lazy var nextButton = UIButton()
    private lazy var previousButton = UIButton()
    private let playList: [String] = ["Queen", "Noize_MC_-_Vsjo_kak_u_lyudejj", "maks_korzh_-_amsterdam", "lone_-_ey_bro", "Каста - Выходи Гулять"]
    private lazy var nomberOfTrack: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setuptrackNameLabel()
        setupPlayButton()
        setupStopButton()
        setupNextButton()
        setupPreviousButton()
        playSound(index: nomberOfTrack)
    }

    private func setuptrackNameLabel() {
        trackNameLabel.translatesAutoresizingMaskIntoConstraints = false
        trackNameLabel.numberOfLines = 1
        trackNameLabel.textAlignment = .left

        self.view.addSubview(trackNameLabel)

        NSLayoutConstraint.activate([
            self.trackNameLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            self.trackNameLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            self.trackNameLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            self.trackNameLabel.heightAnchor.constraint(equalToConstant: 32)
                ])
    }

    private func setupPlayButton() {
        playtButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playtButton.translatesAutoresizingMaskIntoConstraints = false
        playtButton.addTarget(self, action:  #selector(playButtonDidTap), for: .touchUpInside)

        self.view.addSubview(playtButton)

        NSLayoutConstraint.activate([
            self.playtButton.topAnchor.constraint(equalTo: self.trackNameLabel.bottomAnchor, constant: 16),
            self.playtButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            self.playtButton.heightAnchor.constraint(equalToConstant: 20),
            self.playtButton.widthAnchor.constraint(equalToConstant: 20)
        ])
    }

    private func setupStopButton() {
        stopButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        stopButton.addTarget(self, action:  #selector(stopButtonDidTap), for: .touchUpInside)

        self.view.addSubview(stopButton)

        NSLayoutConstraint.activate([
            self.stopButton.topAnchor.constraint(equalTo: self.trackNameLabel.bottomAnchor, constant: 16),
            self.stopButton.leadingAnchor.constraint(equalTo: playtButton.trailingAnchor, constant: 16),
            self.stopButton.heightAnchor.constraint(equalToConstant: 20),
            self.stopButton.widthAnchor.constraint(equalToConstant: 20)
        ])
    }

    private func setupNextButton() {
        previousButton.setImage(UIImage(systemName: "backward.fill"), for: .normal)
        previousButton.translatesAutoresizingMaskIntoConstraints = false
        previousButton.addTarget(self, action:  #selector(previousButtonDidTap), for: .touchUpInside)

        self.view.addSubview(previousButton)

        NSLayoutConstraint.activate([
            self.previousButton.topAnchor.constraint(equalTo: self.trackNameLabel.bottomAnchor, constant: 16),
            self.previousButton.leadingAnchor.constraint(equalTo: stopButton.trailingAnchor, constant: 16),
            self.previousButton.heightAnchor.constraint(equalToConstant: 20),
            self.previousButton.widthAnchor.constraint(equalToConstant: 20)
        ])
    }

    private func setupPreviousButton() {
        nextButton.setImage(UIImage(systemName: "forward.fill"), for: .normal)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.addTarget(self, action:  #selector(nextButtonDidTap), for: .touchUpInside)

        self.view.addSubview(nextButton)

        NSLayoutConstraint.activate([
            self.nextButton.topAnchor.constraint(equalTo: self.trackNameLabel.bottomAnchor, constant: 16),
            self.nextButton.leadingAnchor.constraint(equalTo: previousButton.trailingAnchor, constant: 16),
            self.nextButton.heightAnchor.constraint(equalToConstant: 20),
            self.nextButton.widthAnchor.constraint(equalToConstant: 20)
        ])
    }

    private func playSound( index: Int) {
        do {
            Player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: playList[index], ofType: "mp3")!))
            Player.prepareToPlay()
            trackNameLabel.text = playList[index]
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
        if nomberOfTrack < playList.count - 1 {
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
