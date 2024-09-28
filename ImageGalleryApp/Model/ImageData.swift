//
//  ImageData.swift
//  ImageGalleryApp
//
//  Created by Mukul on 27/09/24.
//

import Foundation

struct ImageData: Identifiable, Codable {
    let id = UUID() // Unique ID for SwiftUI to use in a list
    let albumId: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}
