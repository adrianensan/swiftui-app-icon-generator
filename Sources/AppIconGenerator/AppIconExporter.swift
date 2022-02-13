import SwiftConvenience
import SwiftUIConvenience
import SwiftUI

public struct AppIconExporter {
  
  let appName: String
  
  public init(appName: String) {
    self.appName = appName
  }
  
  var baseExportPath: URL? { FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first?.appendingPathComponent(appName) }
  
  func baseImage<AppIcon: HelloAppIcon>(for icon: AppIcon) -> AnyView {
    guard let imageData = ImageRenderer.renderData(view: icon.view,
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
    
    let imageView = baseImage(for: icon)
    
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
      
      let imageView = baseImage(for: icon)
      
      // Main App Icon
      let scales = icon.imageName == AppIcon.defaultIcon.imageName ? IconScale.iOSMainIconScales : IconScale.iOSAlternateIconScales
      for scale in scales {
        save(view: imageView, size: scale.size * CGFloat(scale.scaleFactor),
             to: iconExportPath.appendingPathComponent(AppiconsetContentsGenerator.fileName(appIconName: icon.imageName, scale: scale)))
      }
      try? AppiconsetContentsGenerator.contentsFile(for: icon.imageName, with: scales)
        .write(to: iconExportPath.appendingPathComponent("Contents.json"), atomically: true, encoding: .utf8)
      
      // App Icon Previews
//      guard let previewsExportPath = baseExportPath?.appendingPathComponent("ios-previews") else { return }
//      let previewIconExportPath = previewsExportPath.appendingPathComponent("\(icon.imageName)-preview.imageset")
//      try? FileManager.default.createDirectory(at: previewIconExportPath, withIntermediateDirectories: true, attributes: [:])
//      let previewScales = [IconScale(size: 60, scaleFactor: 2, purpose: .iphone),
//                           IconScale(size: 60, scaleFactor: 3, purpose: .iphone)]
//      for scale in previewScales {
//        save(view: icon.view, size: scale.size * CGFloat(scale.scaleFactor),
//             to: previewIconExportPath.appendingPathComponent(AppIconAssetContentsGenerator.fileName(appIconName: icon.imageName, scale: scale)))
//      }
//      try? AppIconAssetContentsGenerator.contentsFile(for: icon.imageName, with: previewScales)
//        .write(to: previewIconExportPath.appendingPathComponent("Contents.json"), atomically: true, encoding: .utf8)
    }
  }
  
  func save<Content: View>(view: Content, size: CGFloat, to path: URL) {
    try? ImageRenderer.renderData(view: view, size: CGSize(width: size, height: size), sizeIsPixels: true)?.write(to: path)
  }
}
