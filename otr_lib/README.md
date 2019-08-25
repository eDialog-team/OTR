# otr_lib

Companion library for OTRs projets


A Flutter lib that contains the UI and state management for OTR applications.

## Goals for this lib

* Be importable into OTR implementation, no copy/paste of business logic/UI
* Show simple use of [`Provider`](https://pub.dev/packages/provider) for providing an immutable value to a subtree
* Show simple use of Widget.

## The important bits


### [`lib/common/projects.dart`](lib/common/projects.dart)
Here the app sets up the Application name, Theming and baseURL.


### [`lib/models/*`](lib/models/)
This directory contains the model classes that are provided through the app.  
These classes represent the app state and API result, mostly generated code from
[json_to_dart](https://javiercbk.github.io/json_to_dart/).

Event tho the models are object, they must not implement business logic code!

### [`lib/screens/*`](lib/screens/)
This directory contains high-level UI used to construct the UI of the app.
These widgets have access to the current state through the
[`Provider`](https://pub.dev/packages/provider) dependency injection and state
management library.

### [`lib/screens/widgets*`](lib/screens/widgets)
This directory the widgets that describe the view.

### [`lib/services/*`](lib/services/)
This directory contains the business logic related to fetching data from the
memberz's API.  
Data processing/filtering should be placed along the http call definition.

For a clearer and more maintainable package, services should always return an
[Either](https://pub.dev/packages/either_option). The different possible types
of the Either should be the success result of the API content OR loading/error
states defined in `lib/models/states.dart`.

## Tips / Style
- Format your code with the official formater (fmt): [Code formatting](https://flutter.dev/docs/development/tools/formatting)  
- null check using [the dart null-aware operators](https://stackoverflow.com/questions/17006664/what-is-the-dart-null-checking-idiom-or-best-practice)
- Always check if you aren't doing unnecessary redraw (one `notifyListeners` can
    be the cause!)
- Don't use global variable!  
- Don't use [`StatefulWidget`](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)! Data must me share through Provider.  
- Don't make a `otr_lib` for each project, find solution that doesn't require copying this
library.  
- Don't abuse methods in objects. Prefer functions for data processing.
- Don't use null or undefined objects.
