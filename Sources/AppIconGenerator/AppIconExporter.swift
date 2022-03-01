import SwiftConvenience
import SwiftUIConvenience
import SwiftUI

public struct AppIconExporter {
  
  let appName: String
  
  public init(appName: String) {
    self.appName = appName
  }
  
  var baseExportPath: URL? { FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first?.appendingPathComponent(appName) }
  
  func baseImage<IconView: View>(for iconView: IconView) -> AnyView {
    guard let imageData = ImageRenderer.renderData(view: iconView,
                                                   size: CGSize(width: 1024, height: 1024),
                                                   sizeIsPixels: true),
          let nsImage = NSImage(data: imageData)
    else { return AnyView(Color.clear) }
    
    return AnyView(Image(nsImage)
      .resizable()
      .aspectRatio(contentMode: .fill))
  }
  
  public func export<AppIcon: HelloAppIcon>(watchOSIcon icon: AppIcon) {
    guard let exportPath = baseExportPath?.appendingPathComponent("watchOS") else { return }
    let iconExportPath = exportPath.appendingPathComponent("\(icon.imageName).appiconset")
    try? FileManager.default.createDirectory(at: iconExportPath, withIntermediateDirectories: true, attributes: [:])
    
    let imageView = baseImage(for: icon.view)
    
    for scale in IconScale.watchOSIconScales {
      save(view: imageView, size: scale.size * CGFloat(scale.scaleFactor),
           to: iconExportPath.appendingPathComponent(AppiconsetContentsGenerator.fileName(appIconName: icon.imageName, scale: scale)))
      try? AppiconsetContentsGenerator.contentsFile(for: icon.imageName, with: IconScale.watchOSIconScales)
        .write(to: iconExportPath.appendingPathComponent("Contents.json"), atomically: true, encoding: .utf8)
    }
  }
  
  public func export<AppIcon: HelloAppIcon>(IOSIcons icons: [AppIcon]) {
    guard let exportPath = baseExportPath?.appendingPathComponent("ios") else { return }
    for icon in AppIcon.allCases {
      let iconExportPath = exportPath.appendingPathComponent("\(icon.imageName).appiconset")
      try? FileManager.default.createDirectory(at: iconExportPath, withIntermediateDirectories: true, attributes: [:])
      
      let imageView = baseImage(for: icon.view)
      
      // Main App Icon
      let scales = icon.imageName == AppIcon.defaultIcon.imageName ? IconScale.iOSMainIconScales : IconScale.iOSAlternateIconScales
      for scale in scales {
        save(view: imageView, size: scale.size * CGFloat(scale.scaleFactor),
             to: iconExportPath.appendingPathComponent(AppiconsetContentsGenerator.fileName(appIconName: icon.imageName, scale: scale)))
      }
      try? AppiconsetContentsGenerator.contentsFile(for: icon.imageName, with: scales)
        .write(to: iconExportPath.appendingPathComponent("Contents.json"), atomically: true, encoding: .utf8)
    }
  }
  
  public func export<AppIcon: HelloAppIcon>(macOSIcons icons: [AppIcon]) {
    guard let exportPath = baseExportPath?.appendingPathComponent("macOS") else { return }
    
    // Main App Icon
    let mainIconExportPath = exportPath.appendingPathComponent("AppIcon.appiconset")
    try? FileManager.default.createDirectory(at: mainIconExportPath, withIntermediateDirectories: true, attributes: [:])
    
    let imageView = baseImage(for:  MacAppIconWrapperView(icon: AppIcon.defaultIcon))
    
    // Main App Icon
    for scale in IconScale.macOSMainIconScales {
      save(view: imageView, size: scale.size * CGFloat(scale.scaleFactor),
           to: mainIconExportPath.appendingPathComponent(AppiconsetContentsGenerator.fileName(appIconName: AppIcon.defaultIcon.imageName, scale: scale)))
    }
    try? AppiconsetContentsGenerator.contentsFile(for: AppIcon.defaultIcon.imageName, with: IconScale.macOSMainIconScales)
      .write(to: mainIconExportPath.appendingPathComponent("Contents.json"), atomically: true, encoding: .utf8)
    
    for icon in AppIcon.allCases {
      try? FileManager.default.createDirectory(at: exportPath, withIntermediateDirectories: true, attributes: [:])
      
      save(view: baseImage(for: MacAppIconWrapperView(icon: icon)), size: 256,
           to: exportPath.appendingPathComponent(icon.imageName + ".png"))
    }
  }
  
  func save<Content: View>(view: Content, size: CGFloat, to path: URL) {
    try? ImageRenderer.renderData(view: view, size: CGSize(width: size, height: size), sizeIsPixels: true)?.write(to: path)
  }
}
