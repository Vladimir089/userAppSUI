import SwiftUI
import UIKit

struct SegmentedPicker: UIViewRepresentable {
    @Binding var selectedSegment: String
    let segments: [String]

    func makeUIView(context: Context) -> UISegmentedControl {
        let control = UISegmentedControl(items: segments)
        control.selectedSegmentIndex = segments.firstIndex(of: selectedSegment) ?? 0
        control.addTarget(context.coordinator, action: #selector(Coordinator.segmentChanged(_:)), for: .valueChanged)

        // Настройка шрифта
        let normalFont = UIFont.systemFont(ofSize: 16, weight: .regular)
        let selectedFont = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        control.setTitleTextAttributes([NSAttributedString.Key.font: normalFont], for: .normal)
        control.setTitleTextAttributes([NSAttributedString.Key.font: selectedFont], for: .selected)

        return control
    }

    func updateUIView(_ uiView: UISegmentedControl, context: Context) {
        uiView.selectedSegmentIndex = segments.firstIndex(of: selectedSegment) ?? 0
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: SegmentedPicker

        init(_ parent: SegmentedPicker) {
            self.parent = parent
        }

        @objc func segmentChanged(_ sender: UISegmentedControl) {
            parent.selectedSegment = parent.segments[sender.selectedSegmentIndex]
        }
    }
}
