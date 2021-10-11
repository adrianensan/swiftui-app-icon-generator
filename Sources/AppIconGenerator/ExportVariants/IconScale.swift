import Foundation

struct IconScale: Equatable {
  
  enum Purpose: String {
    case iphone, ipad
    case iosMarketing = "ios-marketing"
  }
  
  var size: Double
  var scaleFactor: Int
  var purpose: Purpose
}
