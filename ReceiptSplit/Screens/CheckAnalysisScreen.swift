//
//  CheckAnalysisScreen.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/13/25.
//

import SwiftUI
import Vision
import MaterialUIKit

struct CheckAnalysisScreen: View {
    let image: CIImage

    // Represents the current step in the analysis pipeline.
    private enum AnalysisPhase: Hashable {
        case detectingText
        case runningAIAnalysis
        case buildingCheckItems

        var displayTitle: String {
            switch self {
            case .detectingText: return "Detecting text"
            case .runningAIAnalysis: return "Running AI analysis"
            case .buildingCheckItems: return "Building check items"
            }
        }
    }

    @State private var currentPhase: AnalysisPhase = .detectingText

    var body: some View {
        NavigationContainer {
            HStack(spacing: MaterialUIKit.configuration.horizontalStackSpacing) {
                // Progress indicator and current phase
                VStack(spacing: MaterialUIKit.configuration.verticalStackSpacing) {
                    ProgressBar(lineWidth: 5)
                    Text(currentPhase.displayTitle)
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationContainerTopBar(title: "Analyzing Receipt", backButtonHidden: false, style: .inline)
        }
    }
}

#Preview {
    CheckAnalysisScreen(image: CIImage.empty())
}
