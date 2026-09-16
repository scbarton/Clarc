import AppKit
import SwiftMath

/// Rasterizes LaTeX math into an `NSImage` using SwiftMath's `MTMathUILabel`.
enum MathRenderer {
    /// Renders `latex` to an image, or `nil` if the LaTeX fails to parse.
    static func renderImage(latex: String, fontSize: CGFloat, color: NSColor, display: Bool) -> NSImage? {
        let trimmed = latex.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        let label = MTMathUILabel()
        label.displayErrorInline = false
        label.fontSize = fontSize
        label.textColor = color
        label.labelMode = display ? .display : .text
        label.latex = trimmed
        guard label.error == nil else { return nil }

        let size = label.fittingSize
        guard size.width > 0.5, size.height > 0.5 else { return nil }

        label.frame = CGRect(origin: .zero, size: size)
        label.layout()

        return NSImage(size: size, flipped: false) { rect in
            label.draw(rect)
            return true
        }
    }
}
