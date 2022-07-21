# Flow
An Instagram-like sample app using Combine, Firebase and MVVM pattern.

<img src="/Demo/demo.gif" width="240">   <img src="/Demo/home-screen.png" width="240">   <img src="/Demo/search-screen.png" width="240">

<img src="/Demo/profile-screen.png" width="240">   <img src="/Demo/login-screen.png" width="240">   <img src="/Demo/register-screen.png" width="240">   

See [Instructions](/README.md#instructions) below if you'd like to run the app for testing.

## Features
- Register and log in with email and password
- Upload photos with captions
- Interactions: like / bookmark / comment
- Instagram-like UI
- Dark mode

## Technologies
- Combine framework (iOS 13+)
- Compositional collection view (iOS 13+)
- Diffable data source (iOS 13+)
- Firebase (for authentication, uploading/fetching posts, comments and user data)
- CocoaPods
- MVVM design pattern
- Coordinator(flow controller) design pattern
- Custom UI without storyboard
- Dark mode

## Instructions
To run the app, you need to create and configure your own [Firebase](https://console.firebase.google.com/) project:
1. Register an iOS app with the bundle ID `com.yhchen.Flow` and download the `GoogleService-Info.plist` into the Xcode project directory `\Flow`
2. Enable Authentication (add Email/Password sign-in provider), Firestore, Storage with appropriate rules
3. Open `Flow.xcworkspace` and run the app

## Todo
- [ ] Edit posts/comments
- [ ] Notifications
- [ ] Search for users/posts
- [ ] Chatroom
- [ ] Storybooks
- [ ] Sliding menu
