import Foundation

struct IconScale: Equatable {
  
  enum Purpose: String {
    case iphone, ipad
    case iosMarketing = "ios-marketing"
  }
  
  var size: CGFloat
  var scaleFactor: Int
  var purpose: Purpose
}
