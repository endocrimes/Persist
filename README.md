# Persist

Persist is a simple, reusable Core Data stack written in Swift.
It also provides some lightweight helpers for common actions such as creating
entities, and querying.

It supports iOS 8+, watchOS 2.0, and Mac OS 10.9+.

## Architecture

Persist uses a simple parent/child Core Data stack, with a private writer
context attached directly to the NSPersistentStoreCoordinator, with a main
queue context that is exposed to the user as it's child.

   ┌─────────────────────────────────────────────────────────────────────────┐
   │ ┌─────────────────────────────────┐                                     │
   │ │  Persistent Store Coordinator   │                                     │
   │ └────────────────┬────────────────┘                                     │
   │                  │                                                      │
   │                  │                                                      │
   │ ┌────────────────▼────────────────┐                                     │
   │ │      Private Queue Context      │                                     │
   │ └────────────────┬────────────────┘                                     │
   │                  │                                                      │
   │                  │                                                      │
   │ ┌────────────────▼────────────────┐         ┌─────────────────┐         │
   │ │       Main Queue Context        ├─────────▶  User Interface │         │
   │ └────────────────┬────────────────┘         └─────────────────┘         │
   │                  │                                                      │
   │                  │                                                      │
   │                  │                                                      │
   │                  │                                                      │
   │                  │                                                      │
   │ ┌────────────────▼────────────────┐         ┌────────────────────────┐  │
   │ │ Temporary Private Queue Context ◀─────────┤     Writes/Updates     │  │
   │ └─────────────────────────────────┘         └────────────────────────┘  │
   └─────────────────────────────────────────────────────────────────────────┘

## Usage

### Stack setup

Persist gives you full access to the configuration of it's underlying stores
via the StoreType enum, providing safe construction of InMemory, SQLite, and
Binary store types, and allows you to also provide a custom store type.

Creating an in memory store would look like this:

```swift
import Persist

let bundle = NSBundle.mainBundle()
let modelPath = bundle.pathForResource("MyModel", ofType: "momd")!
let modelURL = NSURL(fileURLWithPath: modelPath)

let persist = try! Persist(storeType: .InMemory, modelURL: modelURL)
```

You can see more examples in PersistTests/PersistStoreBasedTests.swift

### Helpers

To opt your NSManagedObject subclasses into the helpers, annotate them with the
ManagedObjectType protocol like so:

```swift
@objc(Person)
class Person: ManagedObjectType {
}
```
If you don't provide an objective-c name for your class, or update your model
configuration to support module namespaces, you will need to provide your own
implementation of `static func entityName() -> String`.

## Adding to your project:

### Carthage:

1. Add `github "DanielTomlinson/Persist"` to your Cartfile
2. Run `$ carthage update`
3. Add the frameworks to your project.

### Cocoapods:

1. Add `pod "Persist"` to your podfile
2. Run `$ pod install`

## Contributing

### Issues
Issues and feature requests are welcome, although the intention is to keep Latch lightweight.

### Submitting Pull Requests
1. Fork it ( http://github.com/DanielTomlinson/Latch/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
