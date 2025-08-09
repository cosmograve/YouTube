//
//  VideoUseCase.swift
//  YouTube
//
//  Created by Алексей Авер on 02.08.2025.
//

import Foundation

protocol VideoUseCase {
    func fetchFeedVideos() -> [Video]
    func fetchShorts() -> [ShortVideo]
}
