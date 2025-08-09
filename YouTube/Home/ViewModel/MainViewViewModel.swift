//
//  MainViewViewModel.swift
//  YouTube
//
//  Created by Алексей Авер on 04.08.2025.
//

import Foundation

final class MainViewViewModel {
    private let videoUseCase: VideoUseCase
    
    private(set) var videos: [Video] = []
    private(set) var shorts: [ShortVideo] = []
    
    init(videoUseCase: VideoUseCase) {
        self.videoUseCase = videoUseCase
        load()
    }
    
    private func load() {
        videos = videoUseCase.fetchFeedVideos()
        shorts = videoUseCase.fetchShorts()
    }
}
