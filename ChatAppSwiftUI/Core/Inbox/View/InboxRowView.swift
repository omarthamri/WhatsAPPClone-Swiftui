//
//  InboxRowView.swift
//  ChatAppSwiftUI
//
//  Created by omar thamri on 11/3/2024.
//

import SwiftUI
import Kingfisher

struct InboxRowView: View {
    let message: Message
    var body: some View {
        HStack(alignment: .top,spacing: 12) {
            ZStack {
                CircularProfileImageView(user: message.user, size: .medium)
                KFImage(URL(string: message.user?.profileImageUrl ?? ""))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 56, height: 56)
                    .foregroundStyle(Color(.systemGray4))
                    .clipShape(Circle())
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(message.user?.fullName ?? "")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                if let isImage = message.isImage, isImage {
                    Text("Sent picture")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .lineLimit(2)
                        .frame(maxWidth: UIScreen.main.bounds.width - 100, alignment: .leading)
                } else if let isVideo = message.isVideo, isVideo {
                    Text("Sent video")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .lineLimit(2)
                        .frame(maxWidth: UIScreen.main.bounds.width - 100, alignment: .leading)
                } else if let isAudio = message.isAudio, isAudio {
                    Text("Sent voice message")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .lineLimit(2)
                        .frame(maxWidth: UIScreen.main.bounds.width - 100, alignment: .leading)
                } else {
                    Text(message.messageText)
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .lineLimit(2)
                        .frame(maxWidth: UIScreen.main.bounds.width - 100, alignment: .leading)
                }
            }
            HStack {
                Text(message.timestampString)
                Image(systemName: "chevron.right")
            }
            .font(.footnote)
            .foregroundStyle(.gray)
        }
        .frame(height: 72)
    }
}
