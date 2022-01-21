import Foundation

public struct IconScale: Equatable {
  
  public enum Purpose: String {
    case iphone, ipad
    case iosMarketing = "ios-marketing"
  }
  
  public var size: Double
  public var scaleFactor: Int
  public var purpose: Purpose
}
