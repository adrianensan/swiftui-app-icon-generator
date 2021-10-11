import Foundation

enum AppIconAssetContentsGenerator {
  
  static func contentsFile(for appIconName: String, with scales: [IconScale]) -> String {
    var file = AppIconAssetContentsGenerator.contentsJsonFilePrefix
    for scale in scales {
      file += AppIconAssetContentsGenerator.contentsJsonEntry(for: scale, isLast: scale == scales.last)
    }
    file += AppIconAssetContentsGenerator.contentsJsonFileSuffix
    return file
  }
  
  static func sizeString(for size: Double) -> String {
    size.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", size) : "\(size)"
  }
  
  static func fileName(for scale: IconScale) -> String {
    "app-icon-\(sizeString(for: scale.size))@\(scale.scaleFactor)x.png"
  }
  
  static func contentsJsonEntry(for scale: IconScale, isLast: Bool) -> String {
    """
    {
      "filename" : "\(fileName(for: scale))",
      "idiom" : "universal",
      "scale" : "\(scale.scaleFactor)x"
    }\(isLast ? "" : ",")
    """
  }
  
  static var contentsJsonFilePrefix: String {
    """
    {
    "images" : [
    {
      "idiom" : "universal",
      "scale" : "1x"
    },
    """
  }
  
  static var contentsJsonFileSuffix: String {
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
