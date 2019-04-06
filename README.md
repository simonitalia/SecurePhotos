# Application Name
Secure Photos

# Course
Hacking with Swift

# Education supplier
This iOS app is developed as a "self challenge" project in the iBook tutorial "Hacking with Swift" which forms part of the "Hacking with Swift" tutorial series, authored by Paul Hudson. Self challenges are apps developed from scratch, solo and un-assisted. The requirements are provided by the instructor in text base, list form. Some helpful hints are sometimes provided.

# Project Type
Self challenge

# Topics / milestones
- UICollectionView

- Custom UICollectionViewCell

- Custom Class (Data Model)

- UIImagePickerController()

- UUID().uuidString

- jpegData()

- picker.sourceType = .camera

- NSObject

- LocalAuthenticatin / LAContext (Biometric Authentication with Password fallback)

- secureTextEntry

- Codable (JSONEncoder / JSONDecoder to write and read json data from disk)

- KeychainWrapper (securely save data to keychain)

- NotificationCenter

- Compiler Directives (Check if simultaor or physical device)

- UIAlertController / UIAlertAction

- Git / Github

# Project goals / instructions

- Your final challenge is to create a private photos app – think Mission Impossible, or at least as close as you can get to it in a programming tutorial! The Notes app for iOS has the ability to lock certain notes so that Touch ID must be used to reveal the note, and your mission is to create something similar for a photo library.

- At its most basic, you’re going to want to start your app with something like project 10: a collection view, plus the ability to load images. 
- In the wrap up for that chapter, I mentioned using picker.sourceType = .camera, and here’s your chance to use it so that users can take photos straight to their private library.
- Once you have the collection view working, go to project 12 to add support for NSCoding so that you can write data to disk.
- Finally, jump to project 28 to add support for Touch ID. If you wanted to be really fancy, you could prompt the user for a fallback password for times when Touch ID wasn’t working – using a UIAlertController similar to project 5 ought to do the trick.


</br> <strong> Additional hints: </strong> </br>
- One tip before we’re done: we’ve been using addTextField() without parameters to add text fields to a UIAlertController, but if you want to configure the text field you can provide a configuration closure.
- This closure gets passed the new UITextField as its only parameter so that you can configure it however you want. For example, if you wanted to let the user set a backup password in case Touch ID failed, you could use an alert controller with a text field, then ask iOS to mask out the text as the user types.


# Stretch goals
Some features included are not part of the guided project, but are added as stretch goals. Stretch goals apply learned knowledge to accomplish and are completed unassisted. Stretch goals may either be suggested by the teaching instructor or self imposed. Strecth goals / features implemented (if any) will be listed here.

- Add compiler directives run different code depending if app is running on device or physical device (suggested)

- Save data securely in Keychain (self-imposed)

- Support password fallback for devices that don't support biometric authentication (or if xCode simulator is in use) 

- Support adding new photos taken from camaera app (suggested)

- Support secure text entry in Alert to mask user input for when creating or enyering app password to unlock app (suggested)

- Hide app contents when useer minimizes app or switches apps (suggested)

- Source control with git (local) / github (remote) (self imposed)

# Completed
April, 2019

# Deployment information
- <strong>Deployment Target (iOS version): </strong>12.0 and higher
- <strong>Supported Devices: </strong>Universal
- <strong>Optimized for: </strong>iPhone

