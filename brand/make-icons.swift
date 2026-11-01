// PrivaSuite app icons, drawn from scratch with Core Graphics (no SF Symbols, whose license
// excludes app icons). One family: a two-stop vertical gradient, a white glyph, the same
// geometry for every app.
//
//   swift brand/make-icons.swift [--preview <dir>]
//
// Writes each app's AppIcon.appiconset in the sibling repos (macOS sizes with the standard
// macOS inset and shadow; one opaque, full-bleed 1024 for iOS/iPadOS, which App Store Connect
// requires to have no alpha), plus the website's 256 px images.

import CoreGraphics
import Foundation
import ImageIO
import UniformTypeIdentifiers

struct RGB { let r, g, b: CGFloat
    init(_ hex: UInt32) { r = CGFloat((hex >> 16) & 0xff) / 255; g = CGFloat((hex >> 8) & 0xff) / 255; b = CGFloat(hex & 0xff) / 255 }
    var cg: CGColor { CGColor(srgbRed: r, green: g, blue: b, alpha: 1) }
}

struct AppIcon {
    let slug: String
    let iconset: String      // path relative to ~/Documents/GitHub
    let hasIOS: Bool
    let top: RGB
    let bottom: RGB
    let glyph: (CGContext, RGB) -> Void   // draws in a unit square, y down
}

let white = CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1)

func strokeStyle(_ c: CGContext, _ width: CGFloat) {
    c.setStrokeColor(white); c.setLineWidth(width); c.setLineCap(.round); c.setLineJoin(.round)
}
func line(_ c: CGContext, _ x0: CGFloat, _ y0: CGFloat, _ x1: CGFloat, _ y1: CGFloat) {
    c.move(to: CGPoint(x: x0, y: y0)); c.addLine(to: CGPoint(x: x1, y: y1)); c.strokePath()
}
func sparkle(_ c: CGContext, center p: CGPoint, radius r: CGFloat) {
    let k: CGFloat = 0.18
    c.move(to: CGPoint(x: p.x, y: p.y - r))
    c.addQuadCurve(to: CGPoint(x: p.x + r, y: p.y), control: CGPoint(x: p.x + r * k, y: p.y - r * k))
    c.addQuadCurve(to: CGPoint(x: p.x, y: p.y + r), control: CGPoint(x: p.x + r * k, y: p.y + r * k))
    c.addQuadCurve(to: CGPoint(x: p.x - r, y: p.y), control: CGPoint(x: p.x - r * k, y: p.y + r * k))
    c.addQuadCurve(to: CGPoint(x: p.x, y: p.y - r), control: CGPoint(x: p.x - r * k, y: p.y - r * k))
    c.closePath(); c.setFillColor(white); c.fillPath()
}

let apps: [AppIcon] = [
    AppIcon(slug: "privaassist", iconset: "LocalAssistant/PrivaAssist/Resources/Assets.xcassets/AppIcon.appiconset",
            hasIOS: false, top: RGB(0x6E66F0), bottom: RGB(0x3B33B0)) { c, _ in
        // A Mac window with an assistant sparkle.
        strokeStyle(c, 0.05)
        c.addPath(CGPath(roundedRect: CGRect(x: 0.20, y: 0.24, width: 0.60, height: 0.52), cornerWidth: 0.09, cornerHeight: 0.09, transform: nil))
        c.strokePath()
        line(c, 0.20, 0.37, 0.80, 0.37)
        c.setFillColor(white)
        for x in [0.285, 0.34, 0.395] as [CGFloat] { c.fillEllipse(in: CGRect(x: x - 0.019, y: 0.305 - 0.019, width: 0.038, height: 0.038)) }
        sparkle(c, center: CGPoint(x: 0.50, y: 0.565), radius: 0.15)
    },
    AppIcon(slug: "privapage", iconset: "PrivaPage/PrivaPage/Assets.xcassets/AppIcon.appiconset",
            hasIOS: true, top: RGB(0x23A39B), bottom: RGB(0x0E615C)) { c, _ in
        // A page with a folded corner, read aloud.
        strokeStyle(c, 0.05)
        let l: CGFloat = 0.22, r: CGFloat = 0.58, t: CGFloat = 0.21, b: CGFloat = 0.79, f: CGFloat = 0.11
        c.move(to: CGPoint(x: l, y: t + 0.05)); c.addQuadCurve(to: CGPoint(x: l + 0.05, y: t), control: CGPoint(x: l, y: t))
        c.addLine(to: CGPoint(x: r - f, y: t)); c.addLine(to: CGPoint(x: r, y: t + f))
        c.addLine(to: CGPoint(x: r, y: b - 0.05)); c.addQuadCurve(to: CGPoint(x: r - 0.05, y: b), control: CGPoint(x: r, y: b))
        c.addLine(to: CGPoint(x: l + 0.05, y: b)); c.addQuadCurve(to: CGPoint(x: l, y: b - 0.05), control: CGPoint(x: l, y: b))
        c.closePath(); c.strokePath()
        c.move(to: CGPoint(x: r - f, y: t)); c.addLine(to: CGPoint(x: r - f, y: t + f)); c.addLine(to: CGPoint(x: r, y: t + f)); c.strokePath()
        line(c, 0.31, 0.44, 0.49, 0.44); line(c, 0.31, 0.54, 0.49, 0.54); line(c, 0.31, 0.64, 0.43, 0.64)
        for radius in [0.12, 0.21] as [CGFloat] {
            c.addArc(center: CGPoint(x: 0.60, y: 0.54), radius: radius, startAngle: -.pi / 5, endAngle: .pi / 5, clockwise: false)
            c.strokePath()
        }
    },
    AppIcon(slug: "privameet", iconset: "PrivaMeet/PrivaMeet/Assets.xcassets/AppIcon.appiconset",
            hasIOS: true, top: RGB(0xFF7A59), bottom: RGB(0xC2412A)) { c, _ in
        // A voice waveform becoming transcript lines.
        strokeStyle(c, 0.055)
        let heights: [CGFloat] = [0.08, 0.18, 0.30, 0.40, 0.30, 0.18, 0.08]
        for (i, h) in heights.enumerated() {
            let x = 0.26 + CGFloat(i) * 0.08
            line(c, x, 0.42 - h / 2, x, 0.42 + h / 2)
        }
        line(c, 0.26, 0.69, 0.74, 0.69); line(c, 0.26, 0.79, 0.58, 0.79)
    },
    AppIcon(slug: "privastudy", iconset: "PrivaStudy/PrivaStudy/Assets.xcassets/AppIcon.appiconset",
            hasIOS: true, top: RGB(0xD85A93), bottom: RGB(0x8C2A5E)) { c, accent in
        // Stacked flashcards, the front one checked.
        c.saveGState()
        c.translateBy(x: 0.45, y: 0.42); c.rotate(by: -0.16)
        c.setFillColor(CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 0.42))
        c.addPath(CGPath(roundedRect: CGRect(x: -0.24, y: -0.16, width: 0.48, height: 0.32), cornerWidth: 0.06, cornerHeight: 0.06, transform: nil))
        c.fillPath(); c.restoreGState()
        c.setFillColor(white)
        c.addPath(CGPath(roundedRect: CGRect(x: 0.30, y: 0.42, width: 0.48, height: 0.32), cornerWidth: 0.06, cornerHeight: 0.06, transform: nil))
        c.fillPath()
        c.setStrokeColor(accent.cg); c.setLineWidth(0.05); c.setLineCap(.round); c.setLineJoin(.round)
        c.move(to: CGPoint(x: 0.44, y: 0.585)); c.addLine(to: CGPoint(x: 0.515, y: 0.655)); c.addLine(to: CGPoint(x: 0.65, y: 0.51)); c.strokePath()
    },
]

enum Style { case mac, ios }

func render(_ app: AppIcon, size: Int, style: Style) -> CGImage {
    let s = CGFloat(size)
    let space = CGColorSpace(name: CGColorSpace.sRGB)!
    let alpha: CGImageAlphaInfo = style == .ios ? .noneSkipLast : .premultipliedLast
    let c = CGContext(data: nil, width: size, height: size, bitsPerComponent: 8, bytesPerRow: 0,
                      space: space, bitmapInfo: alpha.rawValue)!
    c.interpolationQuality = .high
    c.setShouldAntialias(true)
    // Work top-down.
    c.translateBy(x: 0, y: s); c.scaleBy(x: 1, y: -1)

    let body: CGRect
    let shape: CGPath
    switch style {
    case .ios:
        body = CGRect(x: 0, y: 0, width: s, height: s)
        shape = CGPath(rect: body, transform: nil)
    case .mac:
        // Apple's macOS icon grid: an 824 pt body inset 100 pt on a 1024 canvas.
        let inset = s * 100 / 1024
        body = CGRect(x: inset, y: inset, width: s - inset * 2, height: s - inset * 2)
        let radius = body.width * 0.225
        shape = CGPath(roundedRect: body, cornerWidth: radius, cornerHeight: radius, transform: nil)
        if size >= 64 {
            c.saveGState()
            c.setShadow(offset: CGSize(width: 0, height: s * 0.012), blur: s * 0.03,
                        color: CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 0.32))
            c.addPath(shape); c.setFillColor(app.bottom.cg); c.fillPath()
            c.restoreGState()
        }
    }

    c.saveGState()
    c.addPath(shape); c.clip()
    let gradient = CGGradient(colorsSpace: space, colors: [app.top.cg, app.bottom.cg] as CFArray, locations: [0, 1])!
    c.drawLinearGradient(gradient, start: CGPoint(x: body.midX, y: body.minY), end: CGPoint(x: body.midX, y: body.maxY), options: [])
    // A soft sheen across the top so the flat gradient reads as a surface.
    let sheen = CGGradient(colorsSpace: space, colors: [CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 0.16), CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 0)] as CFArray, locations: [0, 1])!
    c.drawLinearGradient(sheen, start: CGPoint(x: body.midX, y: body.minY), end: CGPoint(x: body.midX, y: body.midY), options: [])
    // Glyph in the body's unit square.
    c.translateBy(x: body.minX, y: body.minY); c.scaleBy(x: body.width, y: body.height)
    app.glyph(c, app.top)
    c.restoreGState()
    return c.makeImage()!
}

func write(_ image: CGImage, to url: URL) {
    let dest = CGImageDestinationCreateWithURL(url as CFURL, UTType.png.identifier as CFString, 1, nil)!
    CGImageDestinationAddImage(dest, image, nil)
    guard CGImageDestinationFinalize(dest) else { fatalError("could not write \(url.path)") }
}

let scriptDir = URL(fileURLWithPath: CommandLine.arguments[0]).deletingLastPathComponent()
let siteRoot = scriptDir.deletingLastPathComponent()
let github = siteRoot.deletingLastPathComponent()
var previewDir: URL? = nil
if let i = CommandLine.arguments.firstIndex(of: "--preview"), i + 1 < CommandLine.arguments.count {
    previewDir = URL(fileURLWithPath: CommandLine.arguments[i + 1])
}

let macSizes: [(points: Int, scale: Int)] = [(16, 1), (16, 2), (32, 1), (32, 2), (128, 1), (128, 2), (256, 1), (256, 2), (512, 1), (512, 2)]

for app in apps {
    if let preview = previewDir {
        try? FileManager.default.createDirectory(at: preview, withIntermediateDirectories: true)
        write(render(app, size: 1024, style: .mac), to: preview.appendingPathComponent("\(app.slug)-mac.png"))
        write(render(app, size: 1024, style: .ios), to: preview.appendingPathComponent("\(app.slug)-ios.png"))
        continue
    }
    let dir = github.appendingPathComponent(app.iconset)
    let fm = FileManager.default
    // Replace the set wholesale so no stale file is left behind.
    for name in (try? fm.contentsOfDirectory(atPath: dir.path)) ?? [] where name.hasSuffix(".png") {
        try fm.removeItem(at: dir.appendingPathComponent(name))
    }
    // File names follow the AppIcon-<pixels>.png / AppIcon-iOS-1024.png convention that
    // PrivaMeet's distribution-preflight.sh checks; 16@2x and 32@1x share one 32 px file.
    var images: [[String: String]] = []
    var written = Set<Int>()
    for (points, scale) in macSizes {
        let pixels = points * scale
        let name = "AppIcon-\(pixels).png"
        if written.insert(pixels).inserted {
            write(render(app, size: pixels, style: .mac), to: dir.appendingPathComponent(name))
        }
        images.append(["filename": name, "idiom": "mac", "scale": "\(scale)x", "size": "\(points)x\(points)"])
    }
    if app.hasIOS {
        write(render(app, size: 1024, style: .ios), to: dir.appendingPathComponent("AppIcon-iOS-1024.png"))
        images.append(["filename": "AppIcon-iOS-1024.png", "idiom": "universal", "platform": "ios", "size": "1024x1024"])
    }
    let contents: [String: Any] = ["images": images, "info": ["author": "xcode", "version": 1]]
    let json = try JSONSerialization.data(withJSONObject: contents, options: [.prettyPrinted, .sortedKeys])
    try json.write(to: dir.appendingPathComponent("Contents.json"))
    write(render(app, size: 256, style: .mac), to: siteRoot.appendingPathComponent("assets/img/\(app.slug)-256.png"))
    print("wrote \(app.iconset)")
}
