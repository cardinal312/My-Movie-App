//
//  YoutubeSearchResponse.swift
//  MyMovieApp
//
//  Created by Macbook on 5/5/24.
//

import Foundation

struct YoutubeSearchResponse: Decodable {
    
    let items: [VideoElement]
}

struct VideoElement: Decodable {
    
    let id: IdVideoElement
}

struct IdVideoElement: Decodable {
    
    let kind: String
    let videoId: String
}

