import SwiftUI
import SwiftUIConvenience

public struct GalleryView<AppIcon: AppIconExportable>: View {
  
  @State var currentIcon: AppIcon = .default
  
  public init() { }
  
  public var body: some View {
    HStack {
      ScrollView {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100, maximum: 140), spacing: 12, alignment: .top)], spacing: 36) {
          ForEach(AppIcon.allCases, id: \.imageName) { icon in
            VStack {
              icon.view
                .scaleEffect(0.25)
                .frame(width: 80, height: 80)
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
        .frame(width: 512  + 32,
               height: 512)
    }
  }
}
