//
//  GoogleSignInImageHandler.swift
//  GoogleSignInTest
//
//  Created by user on 07.05.2025.
//

import UIKit

/// Применяет указанный фильтр к изображению.
/// В случае ошибки возвращает nil.
actor GoogleSignInImageHandler {
    private let ciContext = CIContext()
    
    func filterImage(filter: GoogleSignInFilter, originalImage: UIImage) -> UIImage? {
        if let inputImage = CIImage(image: originalImage), let filter = filter.filter(inputImage: inputImage) {
            let scale = originalImage.scale
            let imageOrientation = originalImage.imageOrientation
            
            if let outputImage = filter.outputImage,
               let cgImage = self.ciContext.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
            }
        }
        return nil
    }
}
