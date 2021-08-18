import SwiftUI

public protocol AppIconExportable {

  static var `default`: Self { get }
  
  static var allCases: [Self] { get }
  
  var name: String { get }
  
  var displayName: String { get }
  
  func view(for size: CGFloat) -> AnyView
}
