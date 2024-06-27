//
//  PhotoView.swift
//  CreateObject
//
//  Created by Brian Abraham on 17/05/2024.
//

import SwiftUI

import PhotosUI

//struct Photo: View {
//    @StateObject private var viewModel = PhotoPickerViewModel()
//    var body: some View {
//
//        if viewModel.isLoading {
//                        ProgressView()
//                            .frame(width: 200, height: 200)
//                    } else if let image = viewModel.selectedImage {
//                        Image(uiImage: image)
//                            .resizable()
//                            .scaledToFill()
//                            
//                    }
//                    
//                    PhotosPicker(selection: $viewModel.imageSelection, matching: .images) {
//                        Text("select plan")
//                    }
//
//      }
//}


struct Photo: View {
    @StateObject private var photoPickerVM = PhotoPickerViewModel()
    @State private var imageFrame: CGRect = .zero
    @State var frameSize = CGSize.zero
    @State var currentZoom: CGFloat = 0.0
    @State var lastCurrentZoom: CGFloat = 0.0
    private var  minimumZoom = 0.4
    private var maximimumZoom = 2.0
    
    
    func limitZoom (_ zoom: CGFloat) -> CGFloat {
        max(min(zoom, maximimumZoom),minimumZoom)
    }
    
    func getZoom() -> CGFloat {
        let zoom =
        limitZoom( (0.2 + currentZoom + lastCurrentZoom) )//* defaultScale/measurementScale)
        return zoom
    }
    
    var zoom: CGFloat {
        getZoom()
    }
    var body: some View {
        VStack {
            if photoPickerVM.isLoading {
                ProgressView()
                    .frame(width: 200, height: 200)
            } else if let image = photoPickerVM.selectedImage {
                ZStack{
                    
                    
                    GeometryReader { geometry in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                        
                            .onAppear {
                                frameSize = geometry.size
                            }
                            .onChange(of: geometry.size) { oldsSize, newSize in
                                frameSize = newSize
                            }
                            .modifier(
                                ForObjectDrag(
                                    frameSize: (width: frameSize.width, length: frameSize.height), active: true
                                )
                            )
                            .scaleEffect(zoom)
                            .gesture(MagnificationGesture()
                                .onChanged { value in
                                    currentZoom = (value - 1) * 0.3 //sensitivity
                                }
                                .onEnded { value in
                                    lastCurrentZoom += currentZoom
                                    currentZoom = 0.0
                                }
                            )
                    }
                }
            }
            
            PhotosPicker(selection: $photoPickerVM.imageSelection, matching: .images) {
                Text("Select Plan")
            }
        }
    }
}
