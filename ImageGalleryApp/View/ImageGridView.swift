//
//  ImageGridView.swift
//  ImageGalleryApp
//
//  Created by Mukul on 27/09/24.
//

import SwiftUI

struct ImageGridView: View {
    @StateObject var viewModel = ImageViewModel()
    @State private var selectedImage: ImageData?
    
    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(viewModel.images) { item in
                            Button(action: {
                                selectedImage = item
                            }) {
                                AsyncImageView(url: item.url)
                                    .aspectRatio(contentMode: .fill)
                                    .clipped()
                            }
                    }
                }
                .padding()
            }
            .navigationTitle("Image Gallery")
            .sheet(item: $selectedImage) { image in
                ImageDetailView(image: image, images: viewModel.images)
            }
        }
    }
}

struct AsyncImageView: View {
    @State private var loadedImage: UIImage?
    var url: String
    @EnvironmentObject var viewModel: ImageViewModel
    
    var body: some View {
        if let image = loadedImage {
            Image(uiImage: image)
                .resizable()
        } else {
            Color.gray // Placeholder
                .onAppear {
                    viewModel.loadImage(from: url) { image in
                        self.loadedImage = image
                    }
                }
        }
    }
}
