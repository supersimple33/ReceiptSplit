//
//  CaptureScreen.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/12/25.
//

import SwiftUI
import PhotosUI
import MaterialUIKit

struct CaptureScreen: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var image: Image?

    var body: some View {
        NavigationContainer {
            HStack {
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images) {
                        IconButton(systemImage: "photo", style: .filled) {
                            Void()
                        }.allowsHitTesting(false)
                    }
                if let image {
                    image
                        .resizable()
                        .frame(width: 200, height: 200)
                }
            }
        }.onChange(of: selectedItem) { prevItem, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    if let uiImage = UIImage(data: data) {
                        image = Image(uiImage: uiImage)
                    }
                }
            }
        }
    }
}

#Preview {
    CaptureScreen()
}
