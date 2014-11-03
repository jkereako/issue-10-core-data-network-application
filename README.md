# Issue 10: Core data network application
This is a simple app which downloads JSON data via NSURLSession, stores it in a managed object context in a background thread, and then synces the background managed object context with another that runs on the UI thread. It is a great example of concurrent programming with core data.

# Changes from original repository
This app now runs out-of-the-box, no extra configuration is required on your end. Clone it, build it and run it.

This repository downloads data directly from [CocoaPods.org's search API](http://blog.cocoapods.org/Search-API-Version-1/ "Search API Version 1") allowing developers to build and run this project without any configuration. The original repository queried data from a local webserver written in Ruby.

The project has been updated to compile (in hard-mode) in XCode 6 targeting iOS 8.1. Alot of unecessary code was removed in attempt to make the code clear and simple.
