//
//  GoogleSignInFiltersView.swift
//  GoogleSignInTest
//
//  Created by user on 07.05.2025.
//

import SwiftUI
import Combine

struct GoogleSignInFiltersView: View {
    let publisher = PassthroughSubject<Void, Never>()
    
    private let originalImage: UIImage
    private let filters: [GoogleSignInFilter] = GoogleSignInFilter.allCases
    private let imageHandler = GoogleSignInImageHandler()
    
    @State private var currentImage: UIImage
    @State private var currentFilter = GoogleSignInFilter.origin
    @State private var buttonEnabled = true
    
    init(originalImage: UIImage) {
        self.currentImage = originalImage
        self.originalImage = originalImage
    }
    
    var body: some View {
        return VStack {
            Image(uiImage: self.currentImage)
                .resizable()
                .scaledToFill()
            
            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ForEach(self.filters, id: \.self) { filter in
                        Button(filter.filterName) {
                            self.buttonEnabled = false
                            self.currentFilter = filter
                            
                            Task {
                                let newImage = await self.imageHandler.filterImage(filter: filter, originalImage: self.originalImage)
                                self.currentImage = newImage ?? self.originalImage
                                self.buttonEnabled = true
                            }
                        }
                        .background(self.currentFilter == filter ? Color.green : nil)
                        .disabled(self.buttonEnabled == false)
                    }
                }
            }
            .frame(height: 50)
            .scrollIndicators(.hidden)
        }
        .safeAreaPadding()
        .navigationTitle("Apply any filter")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel", action: {
                    self.publisher.send(())
                })
            }
            ToolbarItem(placement: .topBarTrailing) {
                ShareLink(item: GoogleSignInShareImage(image: self.currentImage),
                          preview: SharePreview(GoogleSignInShareImage.fileName, image: Image(uiImage: self.currentImage)), label: {
                    Image(systemName: "square.and.arrow.up")
                })
            }
        }
    }
}
