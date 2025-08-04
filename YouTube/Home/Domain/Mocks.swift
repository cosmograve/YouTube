//
//  Mocks.swift
//  YouTube
//
//  Created by Алексей Авер on 02.08.2025.
//

import Foundation

import Foundation

final class MockVideoRepository: VideoUseCase {
    func fetchFeedVideos() -> [Video] {
        return [
            Video(
                id: 1,
                title: "How to Build an App in 2025",
                subtitle: "CodeWithAlex • 1M views • 2 days ago",
                thumbnailURL: "video",
                avatarURL: "video",
            ),
            Video(
                id: 2,
                title: "iOS Dev Portfolio Review",
                subtitle: "DevJobs • 870K views • 3 days ago",
                thumbnailURL: "video",
                avatarURL: "video",
            )
        ]
    }

    func fetchShorts() -> [ShortVideo] {
        return [
            ShortVideo(id: 1,
                      title: "DIY Toys | Satisfying And Relaxing | DIY Tiktok Compilation..",
                      views: "100M",
                      imageName: "1"),
            ShortVideo(id: 2,
                      title: "DIY Toys | Satisfying And Relaxing | DIY Tiktok Compilation..",
                      views: "10M",
                      imageName: "1"),
            ShortVideo(id: 3,
                      title: "DIY Toys | Satisfying And Relaxing | DIY Tiktok Compilation..",
                      views: "500M",
                      imageName: "1"),
            
        ]
    }
}
