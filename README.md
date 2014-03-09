# ArcBUS

[<img src="http://i.imgur.com/kpsgS7y.png" alt="" width="100px" />](https://itunes.apple.com/us/app/arcbus/id829910677?mt=8)

[ArcBUS](https://itunes.apple.com/us/app/arcbus/id829910677?mt=8) is an free application serving anyone using buses under the [Massachusetts Bay Transportation Authority](http://mbta.com/) ([MBTA](http://mbta.com/)). Using GPS and route information provided by [nextbus](http://www.nextbus.com/), ArcBUS is able to derive highly reliable information about nearby bus routes and expected arrival times.

[ArcBUS](https://itunes.apple.com/us/app/arcbus/id829910677?mt=8) is an open-source project developed by [Arcus Solutions](http://arcussolutions.com) as a means of giving back to the community we call our home. We hope the source of the application can provide valuable insight into some fundamental software design practices, and we welcome any contributions from the GitHub community.

## Installation

In order to simply the file system and leverage 3rd party plugins, ArcBUS uses [CocoaPods](http://cocoapods.org/) for dependency management.  This means that setting up your environment for running the ArcBUS application through xcode involves one very crucial step.

1. Run pod install
2. Open ArcBUS.xcworkspace

## Data Abstraction Layer

[ArcBUS](https://itunes.apple.com/us/app/arcbus/id829910677?mt=8) implements a platform independent structure for managing data and communicating with remote APIs. This abstraction layer lies in the "DAL" folder of the project and contains a series of objects that serve a variety of purposes unrelated to iOS development specifically.  

### Repositories

TODO: Add content here

### Models

TODO: Add content here

### Parsers

TODO: Add content here

### Data Services

TODO: Add content here

### Utilities

TODO: Add content here
