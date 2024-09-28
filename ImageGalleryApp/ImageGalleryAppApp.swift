//
//  ImageGalleryAppApp.swift
//  ImageGalleryApp
//
//  Created by Mukul on 27/09/24.
//

import SwiftUI

@main
struct ImageGalleryAppApp: App {
    
    @StateObject private var viewModel = ImageViewModel()
    var body: some Scene {
        WindowGroup {
            ImageGridView()
                .environmentObject(viewModel)
        }
    }
}
