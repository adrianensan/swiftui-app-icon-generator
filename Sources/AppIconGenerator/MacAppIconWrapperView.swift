import SwiftUI
import SwiftConvenience
import SwiftUIConvenience

public struct MacAppIconWrapperView: View {
  
  var icon: any HelloAppIcon
  
  public var body: some View {
    GeometryReader { geometry in
      icon.view
        .clipShape(AppIconShape())
        .padding(0.05 * geometry.size.minSide)
    }
  }
}
