import Foundation

enum AppiconsetContentsGenerator {
  
  static func contentsFile(for appIconName: String, with scales: [IconScale]) -> String {
    var file = AppiconsetContentsGenerator.contentsJsonFilePrefix
    for scale in scales {
      file += AppiconsetContentsGenerator.contentsJsonEntry(for: scale, isLast: scale == scales.last)
    }
    file += AppiconsetContentsGenerator.contentsJsonFileSuffix
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
      "idiom" : "\(scale.purpose.rawValue)",
      "scale" : "\(scale.scaleFactor)x",
      "size" : "\(sizeString(for: scale.size))x\(sizeString(for: scale.size))"
    }\(isLast ? "" : ",")
    """
  }
  
  static var contentsJsonFilePrefix: String {
    """
    {
    "images" : [
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
