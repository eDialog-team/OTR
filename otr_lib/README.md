# otr_lib

Companion library for OTRs projets

A Flutter lib that contains the UI and state management for OTR applications.

## Goals for this lib
* Be importable into OTR implementations, no copy/paste!
* Show use of [`Provider`](https://pub.dev/packages/provider) for providing an immutable value to a UI subtree
* Show use of many flutter Widget.

## The important bits
### [`lib/common/projects.dart`](lib/common/projects.dart)
Here the user sets up the Application name, Theming and baseURL.

### [`lib/route_generator.dart`](lib/route_generator.dart)
When a new page is push through flutter [`Navigator.push`](https://flutter.dev/docs/cookbook/navigation/navigation-basics),
this class gets called and returns a new [`MaterialPageRoute`](https://api.flutter.dev/flutter/material/MaterialPageRoute-class.html).

### [`lib/models/*`](lib/models/)
This directory contains the model classes that flow through the app.  
These classes represent the app state and API result that are mostly generated code from
[json_to_dart](https://javiercbk.github.io/json_to_dart/).

Event tho the models are object, I like to keep the business logic outside of them.

### [`lib/screens/*`](lib/screens/)
This directory contains high-level widgets used to construct the UI of the app.
These widgets have access to the current state through the
[`Provider`](https://pub.dev/packages/provider) dependency injection and state
management library.

### [`lib/screens/widgets*`](lib/screens/widgets)
This directory contains the widgets that describe sub elements of the UI.

### [`lib/services/*`](lib/services/)
This directory contains the business logic related to fetching data from the
memberz's API.  
Data processing/filtering should be placed along the http call definition.

For a clearer and more maintainable package, services should always return an
[Either](https://pub.dev/packages/either_option). The different possible types
of the Either should be the success result of the API content OR loading/error
states defined in `lib/models/states.dart`.

I'm very bad at naming stuff, if the files located in the above directories
aren't clear to you, feel free to rename them!

## Tips / Style
- Format your code with the official formater (fmt): [Code formatting](https://flutter.dev/docs/development/tools/formatting)  
- null check using [the dart null-aware operators](https://stackoverflow.com/questions/17006664/what-is-the-dart-null-checking-idiom-or-best-practice)
- Always check if you aren't doing unnecessary redraw (one `notifyListeners` can
    be the cause!)  
- Don't use global variable!  
- Don't abuse ternary operator (If you want write code for computer (and not human), do assembly,
    I won't blame you.)  
- Don't use [`StatefulWidget`](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)! Data must me share through Provider.  
- PLEASEEE, Don't make a `otr_lib` for each project, find solution that doesn't require copying this
library.  
- Don't abuse methods in objects. Prefer functions for data processing.
- Don't use null or undefined objects (Yes, it's possible).
