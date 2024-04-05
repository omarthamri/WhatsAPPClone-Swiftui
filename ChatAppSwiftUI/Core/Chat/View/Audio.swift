import SwiftUI
import AVFoundation
import Firebase
import FirebaseStorage

struct AudioView: View {
    @State private var isRecording = false
    @State private var audioRecorder: AVAudioRecorder!
    @State private var recordingURL: URL?
    @State private var audioURL: URL?
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isPlaying = false
    let audioPlayerDelegate = AudioPlayerDelegate()
    @State var song1 = false
    @StateObject private var soundManager = SoundManager()

    var body: some View {
        VStack {
            if !isRecording {
                Button(action: {
                    startRecording()
                }) {
                    Text("Start Recording")
                }
            } else {
                Button(action: {
                    stopRecording()
                }) {
                    Text("Stop Recording")
                }
            }

            Button(action: {
                Task { try await playAudio() }
            }) {
                Text("Play Audio")
            }
        }
    }
    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()

        do {
            try audioSession.setCategory(.record, mode: .default)
            try audioSession.setActive(true)

            let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
            let settings: [String: Any] = [
                AVFormatIDKey: kAudioFormatMPEG4AAC,
                AVSampleRateKey: 44100.0,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]

            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.record()

            isRecording = true
            recordingURL = audioFilename
        } catch {
            print("Error starting recording: \(error.localizedDescription)")
        }
    }

    func stopRecording() {
        audioRecorder.stop()
        isRecording = false
        uploadRecording()
    }

    func uploadRecording() {
        guard let recordingURL = recordingURL else {
            print("Recording not found")
            return
        }

        let storage = Storage.storage()
        let storageRef = storage.reference()
        let metadata = StorageMetadata()
        metadata.contentType = "audio/m4a"
        let audioRef = storageRef.child("audios/\(UUID().uuidString).m4a")

        audioRef.putFile(from: recordingURL, metadata: metadata) { metadata, error in
            if let error = error {
                print("Error uploading recording: \(error.localizedDescription)")
            } else {
                print("Recording uploaded successfully")
                // Once uploaded, get the download URL and save it to Firestore
                audioRef.downloadURL { url, error in
                    if let error = error {
                        print("Error getting download URL: \(error.localizedDescription)")
                    } else {
                        // Save audio download URL to Firestore
                        let db = Firestore.firestore()
                        db.collection("audios").addDocument(data: ["audioURL": url?.absoluteString ?? ""]) { error in
                            if let error = error {
                                print("Error adding document: \(error.localizedDescription)")
                            } else {
                                print("Document added ")
                            }
                        }
                    }
                }
            }
        }
    }
    
    func playAudio() async throws {
        let snapshot = try await Firestore.firestore().collection("audios").getDocuments()
        let posts = try snapshot.documents.compactMap({ try $0.data(as: Audio.self) })
        guard let audioURLString = posts.first?.audioURL,
              let audioURL = URL(string: audioURLString) else {
            print("Audio URL not found or invalid")
            return
        }
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let localURL = documentsURL.appendingPathComponent(audioURL.lastPathComponent)

        // Check if the file already exists locally
        if FileManager.default.fileExists(atPath: localURL.path) {
            // If the file exists locally, play it
            soundManager.playSound(sound: localURL.path)
        } else {
            // If the file doesn't exist locally, download it
            let downloadTask = URLSession.shared.downloadTask(with: audioURL) { (tempURL, _, error) in
                guard let tempURL = tempURL, error == nil else {
                    print("Error downloading audio: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                do {
                    // Move the downloaded file to the local URL
                    try FileManager.default.moveItem(at: tempURL, to: localURL)
                    // Play the downloaded audio file
                    DispatchQueue.main.async {
                        soundManager.playSound(sound: localURL.path)
                    }
                } catch {
                    print("Error moving file: \(error.localizedDescription)")
                }
            }
            downloadTask.resume()
        }
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

class AudioPlayerDelegate: NSObject, AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // Handle audio playback completion here
    }
}


struct Audio: Codable,Identifiable,Hashable {
    
    var id: String {
        return UUID().uuidString
    }
    var audioURL: String
}

/*class SoundManager: ObservableObject {
    var audioPlayer: AVAudioPlayer?

    func playSound(sound: String) {
        guard let url = URL(string: sound) else {
            print("Invalid URL for audio file")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error playing audio: \(error.localizedDescription)")
        }
    }
}
*/
