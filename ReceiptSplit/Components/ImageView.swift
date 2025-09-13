//
//  ImageView.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/13/25.
//

import SwiftUI

struct ImageView: View {
    var image: Image?
    var body: some View {
        GeometryReader { geometry in
            if let image = image {
                image
                    .resizable()
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
}

#Preview {
    ImageView()
}
