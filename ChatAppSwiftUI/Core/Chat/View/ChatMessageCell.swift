//
//  ChatMessageCell.swift
//  ChatAppSwiftUI
//
//  Created by omar thamri on 17/3/2024.
//

import SwiftUI
import Kingfisher
import AVKit
import Firebase

struct ChatMessageCell: View {
    let message: Message
    @StateObject private var soundManager = SoundManager()
    var body: some View {
        HStack {
            if message.isFromCurrentUser {
                Spacer()
                VStack(alignment: .leading,spacing: message.isImage == true || message.isVideo == true || message.isAudio == true ? 0 : -15) {
                    if let isImage = message.isImage, isImage {
                        KFImage(URL(string: message.messageText))
                                                           .resizable()
                                                           .frame(width: 100, height: 180)
                                                           .scaledToFill()
                                                           .padding(.top,6)
                                                           .padding(.horizontal)
                                                           .clipShape(RoundedRectangle(cornerRadius: 15))
                    } else if let isVideo = message.isVideo, isVideo {
                        if let url = URL(string: message.messageText) {
                            VideoPlayer(player: AVPlayer(url: url))
                                .frame(width: 150, height: 150)
                                .padding(.top,6)
                                .padding(.horizontal)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .allowsHitTesting(true)
                        }
                    } else if let isAudio = message.isAudio, isAudio {
                            Button {
                                Task { try await playAudio() }
                            } label: {
                                Image("voice")
                                    .resizable()
                                    .frame(width: 100, height: 20)
                                    .scaledToFill()
                                    .padding(.leading)
                            }
                    } else {
                        Text(message.messageText)
                    }
                    HStack {
                        if message.isImage == true {
                            Spacer().frame(width: 99)
                        } else if message.isVideo == true {
                            Spacer().frame(width: 148)
                        } else if message.isAudio == true {
                            Spacer().frame(width: 94)
                        } else {
                            Text(message.messageText)
                                .foregroundStyle(.clear)
                        }
                        Text(message.timeString)
                            .foregroundStyle(.gray)
                            .font(.footnote)
                    }
                }
                    .font(.subheadline)
                    .padding(message.isImage == true || message.isVideo  == true || message.isAudio == true ? 1 : 12)
                    .background(Color("Peach"))
                    .foregroundStyle(.black)
                    .clipShape(ChatBubble(isFromCurrentUser: message.isFromCurrentUser))
                    .frame(maxWidth: UIScreen.main.bounds.width / 1.5, alignment: .trailing)
            } else {
                HStack(alignment: .bottom, spacing: 8) {
                    ZStack {
                        CircularProfileImageView(user: message.user, size: .xxSmall)
                        KFImage(URL(string: message.user?.profileImageUrl ?? ""))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 28, height: 28)
                            .foregroundStyle(Color(.systemGray4))
                            .clipShape(Circle())
                    }
                    VStack(alignment: .leading,spacing: message.isImage == true || message.isVideo == true || message.isAudio == true ? 0 : -15) {
                        if let isImage = message.isImage, isImage {
                            KFImage(URL(string: message.messageText))
                                                               .resizable()
                                                               .frame(width: 100, height: 180)
                                                               .scaledToFill()
                                                               .padding(.top,6)
                                                               .padding(.horizontal)
                                                               .clipShape(RoundedRectangle(cornerRadius: 15))
                        } else if let isVideo = message.isVideo, isVideo {
                            if let url = URL(string: message.messageText) {
                                VideoPlayer(player: AVPlayer(url: url))
                                    .frame(width: 150, height: 150)
                                    .padding(.top,6)
                                    .padding(.horizontal)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                            }
                        } else if let isAudio = message.isAudio, isAudio {
                            if let url = URL(string: message.messageText) {
                                Button {
                                    Task { try await playAudio() }
                                } label: {
                                    Image("voice")
                                        .resizable()
                                        .frame(width: 100, height: 20)
                                        .scaledToFill()
                                        .padding(.horizontal)
                                }

                            }
                        } else {
                            Text(message.messageText)
                        }
                        HStack {
                            if message.isImage == true {
                                Spacer().frame(width: 99)
                            } else if message.isVideo == true {
                                Spacer().frame(width: 148)
                            } else if message.isAudio == true {
                                Spacer().frame(width: 94)
                            } else {
                                Text(message.messageText)
                                    .foregroundStyle(.clear)
                            }
                            Text(message.timeString)
                                .foregroundStyle(.gray)
                                .font(.footnote)
                                .padding(.trailing,message.isImage == true || message.isVideo == true || message.isAudio == true ? 5 : 0)
                        }
                    }
                        .font(.subheadline)
                        .padding(message.isImage == true || message.isVideo == true || message.isAudio == true ? 1 : 12)
                        .background(.white)
                        .foregroundStyle(.black)
                        .clipShape(ChatBubble(isFromCurrentUser: message.isFromCurrentUser))
                        .frame(maxWidth: UIScreen.main.bounds.width / 1.5, alignment: .leading)
                    Spacer()
                }
            }
        }
        .padding(.horizontal,8)
    }
    
    
    
    func playAudio() async throws {
        guard let audioURL = URL(string: message.messageText) else {
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
}



class SoundManager: ObservableObject {
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
