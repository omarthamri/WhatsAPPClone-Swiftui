//
//  VideoUploader.swift
//  ChatAppSwiftUI
//
//  Created by omar thamri on 2/4/2024.
//

import Foundation
import FirebaseStorage

struct VideoUploader {
    
    static func uploadVideo(data: Data) async throws -> String? {
        let fileName = UUID().uuidString
        let ref = Storage.storage().reference().child("/message_videos/\(fileName)")
        let metaData = StorageMetadata()
        metaData.contentType = "video/quicktime"
        do {
            let _ = try await ref.putDataAsync(data, metadata: metaData)
            let url = try await ref.downloadURL()
            return url.absoluteString
        } catch {
            print("failed to upload video")
            return nil
        }
    }
    
}

