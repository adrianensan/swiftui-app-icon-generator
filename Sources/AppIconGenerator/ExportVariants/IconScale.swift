import Foundation

public struct IconScale: Equatable {
  
  public enum Purpose: String {
    case iphone, ipad, mac, watch
    case iosMarketing = "ios-marketing"
    case watchMarketing = "watch-marketing"
  }
  
  public enum Role: String {
    case appLauncher
    case quickLook
    case notificationCenter
    case companionSettings
  }
  
  public enum SubType: String {
    case watch38mm = "38mm"
    case watch40mm = "40mm"
    case watch41mm = "41mm"
    case watch42mm = "42mm"
    case watch44mm = "44mm"
    case watch45mm = "45mm"
  }
  
  public var size: Double
  public var scaleFactor: Int
  public var purpose: Purpose
  public var role: Role?
  public var subtype: SubType?
  
  public init(size: Double,
              scaleFactor: Int,
              purpose: Purpose,
              role: Role? = nil,
              subtype: SubType? = nil) {
    self.size = size
    self.scaleFactor = scaleFactor
    self.purpose = purpose
    self.role = role
    self.subtype = subtype
  }
}
