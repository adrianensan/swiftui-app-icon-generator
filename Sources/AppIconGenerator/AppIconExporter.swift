import SwiftUI

public struct AppIconExporter<AppIcon: AppIconExportable> {
  
  public init() { }
  
  var baseExportPath: URL? { FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first?.appendingPathComponent("SolitaireIcons") }
  
  public func exportWatchOSIcons() {
    let screenSale = NSScreen.main!.backingScaleFactor
    guard let exportPath = baseExportPath?.appendingPathComponent("watchOS") else { return }
    try? FileManager.default.createDirectory(at: exportPath, withIntermediateDirectories: true, attributes: [:])
    let iconView = NSHostingView(rootView: AppIcon.default.view(for: 1024 / screenSale))
    iconView.frame = CGRect(origin: .zero, size: CGSize(width: 1024 / screenSale, height: 1024 / screenSale))
    for scale in WatchOSAppIconScale.allCases {
      let scaleString = scale.size.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", scale.size) : "\(scale.size)"
      save(view: iconView, size: Int(scale.size * CGFloat(scale.scaleValue)), to: exportPath.appendingPathComponent("app-icon-\(scaleString)@\(scale.scaleValue)x.png"))
    }
  }
  
  public func exportIOSIcons() {
    let screenSale = NSScreen.main!.backingScaleFactor
    guard let exportPath = baseExportPath?.appendingPathComponent("ios") else { return }
    try? FileManager.default.createDirectory(at: exportPath, withIntermediateDirectories: true, attributes: [:])
    
    for icon in AppIcon.allCases {
      let iconExportPath = exportPath.appendingPathComponent("\(icon.name).appiconset")
      try? FileManager.default.createDirectory(at: iconExportPath, withIntermediateDirectories: true, attributes: [:])
      let view = NSHostingView(rootView: icon.view(for: 1024 / screenSale))
      view.frame = CGRect(origin: .zero, size: CGSize(width: 1024 / screenSale, height: 1024 / screenSale))
      let scales = icon.name == AppIcon.default.name ? mainAppIconScales : alternateAppIconScales
      var contentsJsonFile = contentsJsonFilePrefix
      for scale in scales {
        save(view: view, size: Int(scale.size * CGFloat(scale.scaleFactor)),
             to: iconExportPath.appendingPathComponent(fileName(for: scale)))
        contentsJsonFile += contentsJsonEntry(for: scale, isLast: scale == scales.last)
      }
      contentsJsonFile += contentsJsonFileSuffix
      try? contentsJsonFile.write(to: iconExportPath.appendingPathComponent("Contents.json"), atomically: true, encoding: .utf8)
    }
  }
  
  func save(view: NSView, size: Int, to path: URL) {
    let screenSale = NSScreen.main!.backingScaleFactor
    let targetSize = NSSize(width: CGFloat(size) / screenSale, height: CGFloat(size) / screenSale)
    guard let imageRepresentation = view.bitmapImageRepForCachingDisplay(in: view.frame),
          let newImage = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: size, pixelsHigh: size, bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .calibratedRGB, bytesPerRow: 0, bitsPerPixel: 0) else { return }

    view.cacheDisplay(in: view.frame, to: imageRepresentation)
    newImage.size = targetSize
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: newImage)
    NSGraphicsContext.current?.imageInterpolation = .high
    imageRepresentation.draw(in: NSRect(origin: .zero, size: targetSize))
    NSGraphicsContext.restoreGraphicsState()
    
    try? newImage.representation(using: .png, properties: [.compressionFactor: 0.9])?
      .write(to: path)
  }
  
  func sizeString(for size: CGFloat) -> String {
    size.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", size) : "\(size)"
  }
  
  func fileName(for scale: IconScale) -> String {
    "app-icon-\(sizeString(for: scale.size))@\(scale.scaleFactor)x.png"
  }
  
  func contentsJsonEntry(for scale: IconScale, isLast: Bool) -> String {
    """
    {
      "filename" : "\(fileName(for: scale))",
      "idiom" : "\(scale.purpose.rawValue)",
      "scale" : "\(scale.scaleFactor)x",
      "size" : "\(sizeString(for: scale.size))x\(sizeString(for: scale.size))"
    }\(isLast ? "" : ",")
    """
  }

  var contentsJsonFilePrefix: String {
    """
    {
    "images" : [
    """
  }
  
  var contentsJsonFileSuffix: String {
    """
    ],
    "info" : {
    "author" : "xcode",
    "version" : 1
    }
    }
    """
  }
}
