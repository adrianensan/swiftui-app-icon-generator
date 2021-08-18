import Foundation

enum WatchOSAppIconScale: CaseIterable {
  case _24_2x
  case _27_5_2x
  case _29_2x
  case _29_3x
  case _40_2x
  case _44_2x
  case _50_2x
  case _86_2x
  case _98_2x
  case _108_2x
  case _1024_1x
  
  var scaleValue: Int {
    switch self {
    case ._29_3x: return 3
    case ._1024_1x: return 1
    default: return 2
    }
  }
  
  var size: CGFloat {
    switch self {
    case ._24_2x: return 24
    case ._27_5_2x: return 27.5
    case ._29_2x, ._29_3x: return 29
    case ._40_2x: return 40
    case ._44_2x: return 44
    case ._50_2x: return 50
    case ._86_2x: return 86
    case ._98_2x: return 98
    case ._108_2x: return 108
    case ._1024_1x: return 1024
    }
  }
}
