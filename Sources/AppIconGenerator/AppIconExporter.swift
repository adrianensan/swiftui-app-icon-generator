import SwiftConvenience
import SwiftUIConvenience
import SwiftUI

public struct AppIconExporter {
  
  let appName: String
  
  public init(appName: String) {
    self.appName = appName
  }
  
  var baseExportPath: URL? { FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first?.appendingPathComponent(appName) }
  
  func baseImage<IconView: View>(for iconView: IconView, scale: IconScale) -> AnyView {
    guard let imageData = ImageRenderer.renderData(view: iconView,
                                                   size: CGSize(width: 1024 * scale.widthScale,
                                                                height: 1024 * scale.heightScale),
                                                   sizeIsPixels: true),
          let nsImage = NSImage(data: imageData)
    else { return AnyView(Color.clear) }
    
    return AnyView(Image(nsImage)
      .resizable()
      .aspectRatio(contentMode: .fill))
  }
  
  public func export<AppIcon: AppIconExportable>(watchOSIcon icon: AppIcon) {
    guard let exportPath = baseExportPath?.appendingPathComponent("watchOS") else { return }
    let iconExportPath = exportPath.appendingPathComponent("\(icon.imageName).appiconset")
    try? FileManager.default.createDirectory(at: iconExportPath, withIntermediateDirectories: true, attributes: [:])
    
    for scale in IconScale.watchOSIconScales {
      save(view: baseImage(for: icon.view, scale: scale), size: scale.size * CGFloat(scale.scaleFactor),
           to: iconExportPath.appendingPathComponent(AppiconsetContentsGenerator.fileName(appIconName: icon.imageName, scale: scale)))
      try? AppiconsetContentsGenerator.contentsFile(for: icon.imageName, with: IconScale.watchOSIconScales)
        .write(to: iconExportPath.appendingPathComponent("Contents.json"), atomically: true, encoding: .utf8)
    }
  }
  
  public func export<AppIcon: AppIconExportable>(iMessageIcon icon: AppIcon) {
    guard let exportPath = baseExportPath?.appendingPathComponent("iMessage") else { return }
    let iconExportPath = exportPath.appendingPathComponent("\(icon.imageName).stickersiconset")
    try? FileManager.default.createDirectory(at: iconExportPath, withIntermediateDirectories: true, attributes: [:])
    
    for scale in IconScale.iMessageIconScales {
      save(view: baseImage(for: icon.view, scale: scale), size: scale.size * CGFloat(scale.scaleFactor),
           to: iconExportPath.appendingPathComponent(AppiconsetContentsGenerator.fileName(appIconName: icon.imageName, scale: scale)))
      try? AppiconsetContentsGenerator.contentsFile(for: icon.imageName, with: IconScale.iMessageIconScales)
        .write(to: iconExportPath.appendingPathComponent("Contents.json"), atomically: true, encoding: .utf8)
    }
  }
  
  public func export<AppIcon: AppIconExportable>(IOSIcons icons: [AppIcon]) {
    guard let exportPath = baseExportPath?.appendingPathComponent("ios") else { return }
    for icon in AppIcon.allCases {
      let iconExportPath = exportPath.appendingPathComponent("\(icon.imageName).appiconset")
      try? FileManager.default.createDirectory(at: iconExportPath, withIntermediateDirectories: true, attributes: [:])
      
      // Main App Icon
      let scales = icon.imageName == AppIcon.defaultIcon.imageName ? IconScale.iOSMainIconScales : IconScale.iOSAlternateIconScales
      for scale in scales {
        save(view: baseImage(for: icon.view, scale: scale), size: scale.size * CGFloat(scale.scaleFactor),
             to: iconExportPath.appendingPathComponent(AppiconsetContentsGenerator.fileName(appIconName: icon.imageName, scale: scale)))
      }
      try? AppiconsetContentsGenerator.contentsFile(for: icon.imageName, with: scales)
        .write(to: iconExportPath.appendingPathComponent("Contents.json"), atomically: true, encoding: .utf8)
    }
  }
  
  public func export<AppIcon: AppIconExportable>(macOSIcons icons: [AppIcon]) {
    guard let exportPath = baseExportPath?.appendingPathComponent("macOS") else { return }
    
    // Main App Icon
    let mainIconExportPath = exportPath.appendingPathComponent("AppIcon.appiconset")
    try? FileManager.default.createDirectory(at: mainIconExportPath, withIntermediateDirectories: true, attributes: [:])
    
    // Main App Icon
    for scale in IconScale.macOSMainIconScales {
      save(view: baseImage(for: AppIcon.defaultIcon.view, scale: scale), size: scale.size * CGFloat(scale.scaleFactor),
           to: mainIconExportPath.appendingPathComponent(AppiconsetContentsGenerator.fileName(appIconName: AppIcon.defaultIcon.imageName, scale: scale)))
    }
    try? AppiconsetContentsGenerator.contentsFile(for: AppIcon.defaultIcon.imageName, with: IconScale.macOSMainIconScales)
      .write(to: mainIconExportPath.appendingPathComponent("Contents.json"), atomically: true, encoding: .utf8)
    
    for icon in AppIcon.allCases {
      try? FileManager.default.createDirectory(at: exportPath, withIntermediateDirectories: true, attributes: [:])
      
      save(view: baseImage(for: icon.view, scale: .init(size: CGSize(width: 256, height: 256), scaleFactor: 1, purpose: .mac)),
           size: CGSize(width: 256, height: 256),
           to: exportPath.appendingPathComponent("\(icon.imageName).png"))
    }
  }
  
  func save<Content: View>(view: Content, size: CGSize, to path: URL) {
    try? ImageRenderer.renderData(view: view, size: size, sizeIsPixels: true)?.write(to: path)
  }
}
