//
//  GoogleSignInFilter.swift
//  GoogleSignInTest
//
//  Created by user on 07.05.2025.
//

import CoreImage
import CoreImage.CIFilterBuiltins


enum GoogleSignInFilter: String, Hashable, Equatable, CaseIterable {
    case origin
    case sepia
    case colorInvert
    
    var filterName: String {
        return self.rawValue.capitalized
    }
    
    func filter(inputImage: CIImage) -> CIFilter? {
        switch self {
        case .origin:
            return nil
            
        case .sepia:
            let sepiaTone = CIFilter.sepiaTone()
            sepiaTone.inputImage = inputImage
            sepiaTone.intensity = 1
            return sepiaTone
            
        case .colorInvert:
            let colorInvertFilter = CIFilter.colorInvert()
            colorInvertFilter.inputImage = inputImage
            return colorInvertFilter
        }
    }
}
