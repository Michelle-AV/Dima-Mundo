import SwiftUI
import AVKit

class SoundManager: NSObject, AVAudioPlayerDelegate {
    
    static let instance = SoundManager()
    
    private var players: [SoundOption: AVAudioPlayer] = [:]
    private var currentPlaybackTimes: [SoundOption: TimeInterval] = [:]
    private var activeSound: SoundOption?
    
    var dialogPlayer: AVAudioPlayer?
    
    enum SoundOption: String {
        case MainTheme
        case Exercise
        case ExerciseResult
        case ChallengeFinal
    }
    
    enum DialogOptionES: String {
        case Bienvenido
        case AE1
        case AE2
        case AE3
        case AE4
        case AT1
        case AT2
        case AP1
        case AP2
        case AC1
        case AC2
        case AC3
        case AP3
        case AT3
        case AR1
        case AR2
        case AR3
        case AR4
        case AR5
    }
    
    func setVolume(for sound: SoundOption, volume: Float) {
        guard let player = players[sound] else { return }
        player.volume = volume
    }

    
    func playSound(sound: SoundOption, loop: Bool = true) {
        if let currentPlayer = players[sound], currentPlayer.isPlaying {
            return
        }
        
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: "mp3") else { return }
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = loop ? -1 : 0
            player.currentTime = currentPlaybackTimes[sound] ?? 0
            player.volume = 0.5
            player.delegate = self
            players[sound] = player
            activeSound = sound
            player.play()
        } catch let error {
            print("Error playing sound. \(error.localizedDescription)")
        }
    }

    
    func playDialogES(sound: DialogOptionES, loop: Bool = false) {
        adjustMainThemeVolume(reduce: true)
        adjustExerciseThemeVolume(reduce: true)
        adjustChallengeThemeVolume(reduce: true)
        
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: "mp3") else { return }
        do {
            dialogPlayer = try AVAudioPlayer(contentsOf: url)
            dialogPlayer?.numberOfLoops = loop ? -1 : 0
            dialogPlayer?.volume = 1.8
            dialogPlayer?.delegate = self
            dialogPlayer?.play()
        } catch let error {
            print("Error playing dialog. \(error.localizedDescription)")
        }
    }
    
    func stopSound(for sound: SoundOption) {
        guard let player = players[sound] else { return }
        currentPlaybackTimes[sound] = player.currentTime
        player.stop()
    }
    
    func playSoundFromStart(sound: SoundOption, loop: Bool = true) {
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: "mp3") else { return }
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = loop ? -1 : 0
            player.delegate = self
            players[sound] = player
            activeSound = sound
            player.play()
        } catch let error {
            print("Error playing sound from start. \(error.localizedDescription)")
        }
    }
    
    func stopDialog() {
        dialogPlayer?.stop()
    }
    
    func pauseActiveSound() {
        if let activeSound = activeSound, let player = players[activeSound] {
            currentPlaybackTimes[activeSound] = player.currentTime
            player.pause()
        }
    }
    
    func resumeActiveSound() {
        if let activeSound = activeSound, let player = players[activeSound] {
            player.play()
        }
    }
    
    private func adjustMainThemeVolume(reduce: Bool) {
        players[.MainTheme]?.volume = reduce ? 0.2 : 1.0
    }
    
    private func adjustExerciseThemeVolume(reduce: Bool) {
        players[.Exercise]?.volume = reduce ? 0.2 : 1.0
    }
    
    private func adjustChallengeThemeVolume(reduce: Bool) {
        players[.ChallengeFinal]?.volume = reduce ? 0.2 : 1.0
    }
    
    func stopAllSounds() {
        players.forEach { $0.value.stop() }
        players.removeAll()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if player == dialogPlayer {
            adjustMainThemeVolume(reduce: false)
        }
    }
}

