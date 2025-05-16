# glossika-video-player

GlossikaVideoPlayer — 一款基於 AVPlayer 的影片播放 App

專案簡介:
影片列表、播放／暫停/快進/倒退/重播、全螢幕切換、自動隱藏控制列、播放結束偵測與重播等。

功能列表:
1. 影片列表：橫向縮圖＋標題＋描述
2. 播放器：播放、暫停、快退／快進、重播
3. 全螢幕／直向切換
4. 自動隱藏控制列（3 秒）
5. 播放結束時顯示控制列與重播按鈕

使用 Combine + SwiftUI + Kingfisher

專案結構:

GlossikaVideoPlayer/  
├── GlossikaVideoPlayer.xcodeproj  
├── GlossikaVideoPlayer/  
│   ├── Info.plist  
│   ├── App/  
│   │   ├── GlossikaVideoPlayerApp.swift  
│   │   └── AppDelegate.swift  
│   ├── Utilities/  
│   │   ├── Extensions/  
│   │   │   ├── ViewExtensions.swift  
│   │   │   ├── AnyAnyTransitionExtensions.swift  
│   │   │   └── AppError.swift  
│   │   └── Components/  
│   │       └── DeviceRotationViewModifier.swift  
│   └── Features/  
│       ├── VideoPlayer/  
│       │   ├── Services/  
│       │   │   └── PlayerService.swift  
│       │   ├── ViewModels/  
│       │   │   └── PlayerContainerViewModel.swift  
│       │   └── Views/  
│       │       ├── PlayerContainerView.swift  
│       │       └── Components/  
│       │           ├── AVPlayerUIView.swift  
│       │           ├── VideoPlayerView.swift  
│       │           ├── PlaybackOverlayView.swift  
│       │           ├── PlayerControlsView.swift  
│       │           ├── PlayerControlsViewBase.swift  
│       │           └── PlayerSlider.swift  
│       └── VideoList/  
│           ├── Models/  
│           │   ├── VideoSource.swift  
│           │   └── VideoItem.swift  
│           ├── ViewModels/  
│           │   └── VideoListViewModel.swift  
│           └── Views/  
│               ├── VideoListView.swift  
│               └── Components/  
│                   └── VideoListCell.swift  
│  
├── Assets.xcassets/  
│   └── AppIcon.appiconset  
└── Preview Content/  
    └── Preview Assets.xcassets  

Package Dependencies:  
└── Kingfisher 7.12.0  

