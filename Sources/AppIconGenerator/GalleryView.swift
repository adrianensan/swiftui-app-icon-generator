import SwiftUI
import SelfUI

public struct GalleryView<AppIcon: AppIconExportable>: View {
  
  @State var currentIcon: AppIcon = .default
  
  public var body: some View {
    HStack {
      ScrollView {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100, maximum: 140), spacing: 12, alignment: .top)], spacing: 36) {
          ForEach(AppIcon.allCases, id: \.name) { icon in
            VStack {
              icon.view(for: 80 * 4)
                .scaleEffect(0.25)
                .frame(width: 80, height: 80)
                .clipShape(AppIconShape())
                .onTapGesture {
                  currentIcon = icon
                }
              Text(icon.displayName)
                .multilineTextAlignment(.center)
            }.id(icon.name)
          }
        }
        .padding(16)
      }.frame(maxWidth: .infinity, maxHeight: .infinity)
      currentIcon.view(for: 512)
        .clipShape(AppIconShape())
        .frame(width: 512  + 32,
               height: 512)
    }
  }
}
