//
//  ImageDetailView.swift
//  ImageGalleryApp
//
//  Created by Mukul on 27/09/24.
//

import SwiftUI

struct ImageDetailView: View {
    let image: ImageData
    let images: [ImageData]
    
    @State private var selectedImageIndex: Int = 0
    
    var body: some View {
        TabView(selection: $selectedImageIndex) {
            ForEach(images.indices, id: \.self) { index in
                VStack {
                    
                    AsyncImageView(url: images[index].url)
                        .aspectRatio(contentMode: .fit)
                        .padding()
                    
                    Text(images[index].title)
                        .font(.title)
                        .padding()
                }
                .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .onAppear {
            selectedImageIndex = images.firstIndex(where: { $0.id == image.id }) ?? 0
        }
    }
}
