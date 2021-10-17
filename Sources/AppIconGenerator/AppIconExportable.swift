import SwiftUI

public protocol AppIconExportable {

  static var `default`: Self { get }
  
  static var allCases: [Self] { get }
  
  var imageName: String { get }
  
  var displayName: String { get }
  
  var view: AnyView { get }
}
