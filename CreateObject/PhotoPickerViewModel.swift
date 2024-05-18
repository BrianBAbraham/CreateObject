//
//  PhotoPickerViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 17/05/2024.
//

import Foundation
import PhotosUI
import SwiftUI


@MainActor
final class PhotoPickerViewModel: ObservableObject {
    
    @Published private (set) var selectedImage: UIImage? = nil
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            setImage(from: imageSelection)
        }
    }
    @Published var isLoading: Bool = false

    private func setImage(from selection: PhotosPickerItem?) {
            guard let selection else { return }
            
        isLoading = true
        
        Task {
            if let data = try? await selection.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
               
                        self.selectedImage = uiImage
                        self.isLoading = false
                 
                } else {
                        self.isLoading = false
                }
            } else {
                    self.isLoading = false
                }
        }
    }
}
