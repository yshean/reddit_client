# reddit_client

A Reddit client built with Flutter using Streams and BLoC pattern. I'm using this as a practice to build my understanding on BLoC. Suggestions, issues and PRs are welcomed!

![Frontpage](screenshots/screenshot_1.png =200x)
![Details](screenshots/screenshot_2.png =200x)
![Drawer](screenshots/screenshot_3.png =200x)
![Profile](screenshots/screenshot_4.png =200x)
## Get started

To run this app, you need to create an app in [Reddit preferences](https://www.reddit.com/prefs/apps/). Make sure you choose `installed app`. Take note of the token - you need to put it into `secrets.example.dart`, then rename the file to `secrets.dart`.

## Roadmap

- [x] A subreddit feed view
- [ ] Display frontpage
    - [x] Infinite scrolling
    - [ ] Card layout for each post on the feed
        - [x] Basic info
        - [ ] Display badges
        - [x] Refine link preview to look like what's on Reddit
    - [x] Feed switching between different sortings/filters
    - [x] Pull to refresh
    - [x] Search
        - [x] Search a subreddit
        - [x] Search a post
        - [x] Search autocomplete
    - [ ] Keep track of what has been read
- [ ] Settings
- [ ] Create a post
- [ ] Inbox
    - [ ] View messages
    - [ ] Send messages
- [ ] Post details
    - [x] View post details
    - [x] Pull to refresh details
    - [x] Upvote/downvote a post
    - [x] Save a post
    - [ ] Comments
        - [x] View comments
        - [x] Collapse comments
        - [x] Pull to refresh comments
        - [ ] Post a comment / reply to a comment
        - [x] Upvote/downvote/save a comment
        - [x] Expand comments
        - [x] Refine comment layout
- [ ] Authentication
    - [x] Login
    - [x] Logout
    - [ ] Profile
        - [x] Basic info - Karma, Cake day
        - [ ] Comments
        - [x] Posts
        - [x] Upvoted
        - [x] Downvoted
        - [x] Hidden
        - [x] Saved
        - [ ] Sort for each profile section
        - [ ] Show saved comments
    - [x] Persists credentials on device
- [x] Splash screen
- [ ] Dark mode
- [ ] Tap on image or video for quick preview
- [x] Launch link in a webview
- [x] Swipe to go back
- [ ] Open reddit links with the app
- [ ] Shows error if connection timeout
- [ ] Realtime Reddit feed
- [ ] Share buttons

### Special credit

Thanks to [Gloumy/diaporama](https://github.com/Gloumy/diaporama) for open sourcing the app. I learned a lot and also shamelessly _referred_ some of the codes from there.