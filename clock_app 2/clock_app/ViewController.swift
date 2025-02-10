//
//  ViewController.swift
//  clock_app
//
//  Created by user269556 on 2/8/25.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var time_remaining: UILabel!
    @IBOutlet weak var timer_click: UIButton!
    @IBOutlet weak var time_picker: UIDatePicker!
    @IBOutlet weak var liveClock: UILabel!
    
    var countdownTimer: Timer?
    var timeLeft : Int?
    var clockTime: Timer?
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        time_picker.datePickerMode = .countDownTimer
        time_picker.countDownDuration = 0
     
        timeLeft = 0
        updateTimeLeft()
        
        timer_click.setTitle("Start Timer", for: .normal)
        
        startLiveClock()
    }
    func startLiveClock() {
        clockTime = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateLiveClock), userInfo: nil, repeats: true)
        updateLiveClock()
    }
    
    @objc func updateLiveClock() {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss"
        liveClock.text = formatter.string(from: Date())
        
        // Change background based on AM/PM
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 {
            view.backgroundColor = UIColor.systemBlue // AM Background
        } else {
            view.backgroundColor = UIColor.systemOrange // PM Background
        }
    }
    @IBAction func pick_time(_ sender: UIDatePicker) {
        // select time
        timeLeft = Int(sender.countDownDuration) //get time in seconds
        updateTimeLeft()
    }
    
    @IBAction func timer_music(_ sender: UIButton) {
        if countdownTimer == nil {
            startTimer()
            sender.setTitle("Stop Timer", for: .normal)
        } else {
            stopTimer()
            sender.setTitle("Start Timer", for: .normal)
        }
    }
    
    func startTimer() {
        guard let timeLeft = timeLeft, timeLeft > 0 else {return}
        countdownTimer?.invalidate()
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
        
    }
    
    func stopTimer() {
        countdownTimer?.invalidate()
        countdownTimer = nil
       timeLeft = nil
        if !isMusicPlaying {
                timer_click.setTitle("Start Timer", for: .normal)
            }
        updateTimeLeft()
            }
    
    var isMusicPlaying = false

    @objc func updateCountdown() {
        guard var remainingTime = timeLeft, remainingTime > 0 else {
            stopTimer()
            playMusic() // Play music when timer ends
            isMusicPlaying = true
            if timer_click.titleLabel?.text != "Stop Music" {
                     timer_click.setTitle("Stop Music", for: .normal)
                 }
                 return
             }
        
        remainingTime -= 1
        timeLeft = remainingTime
        updateTimeLeft()
    }
    func updateTimeLeft() {
        guard let timeLeft = timeLeft else {
            time_remaining.text = "Time Remaining: 00:00:00" // default
            return
        }
        
        let hours = timeLeft / 3600
        let minutes = (timeLeft % 3600) / 60
        let seconds = timeLeft % 60
        time_remaining.text = String(format: "Time Remaining: %02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func playMusic() {
        guard let soundURL = Bundle.main.url(forResource: "alarm_sound", withExtension: "wav") else { return }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error)")
        }
    }
    
    @IBAction func stopMusicButtonPressed(_ sender: UIButton) {
        if audioPlayer?.isPlaying == true {
            audioPlayer?.stop()
            
        if isMusicPlaying {
            timer_click.setTitle("Start Timer", for: .normal)
            isMusicPlaying = false
                   }
            
        }
    }
    }

    
    



