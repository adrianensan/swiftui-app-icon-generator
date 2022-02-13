import SwiftUI
import SwiftConvenience
import SwiftUIConvenience

public struct GalleryView<AppIcon: HelloAppIcon>: View {
  
  @State var currentIcon: AppIcon = AppIcon.defaultIcon
  
  public init() { }
  
  public var body: some View {
    HStack {
      ScrollView {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 60, maximum: 60), spacing: 12, alignment: .top)], spacing: 16) {
          ForEach(AppIcon.allIcons) { icon in
            VStack {
              icon.view
                .frame(width: 60, height: 60)
                .clipShape(AppIconShape())
                .onTapGesture {
                  currentIcon = icon
                }
              Text(icon.displayName)
                .multilineTextAlignment(.center)
            }.id(icon.imageName)
          }
        }
        .padding(16)
      }.frame(maxWidth: .infinity, maxHeight: .infinity)
      currentIcon.view
        .clipShape(AppIconShape())
        .frame(width: 512, height: 512)
        .padding(16)
    }
  }
}
