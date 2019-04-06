//
//  ViewController.swift
//  SecurePhotos
//
//  Created by Simon Italia on 4/4/19.
//  Copyright © 2019 SDI Group Inc. All rights reserved.
//

import LocalAuthentication
import UIKit

class ViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //Property to store photo objects
    var photos = [Photo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        //Set VC title
        title = "Photos Locked 🔒"
        
        //Hide collectionView on load, until user authenticates
        collectionView.isHidden = true
        
        //Subscribe to notifications to be informed when user minimizes or triggers task / app switcher
        let notificationCenter = NotificationCenter.default
        
        //Trigger saving photo object when user hides app or switches to multitask mode
        notificationCenter.addObserver(self, selector: #selector(secureSave), name: UIApplication.willResignActiveNotification, object: nil)
        
        //Trigger user authentication
        authenticateUser()

    }
    
    //Set number of items to show
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return photos.count
    }
    
    //Create the cell object (data shown to user in collectionView)
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Create cell object. (Need to cast as PhotoCell since we have created a custom UICollectionView cell)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        
        //Get each photo object from photos array
        let photo = photos[indexPath.item]
        
        //Set cell label text property
        cell.label.text = photo.label
        
        //Set cell imageView to imageName saved in Docs directory
        let imageFilePath = getDocumentsDirectory().appendingPathComponent(photo.image)
        
        cell.imageView.image = UIImage(contentsOfFile: imageFilePath.path)

        return cell
        
    }
    
    //Handler for when user taps on a cell (photo) to enable editing via an Alert
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Pull out each photo object from photos array
        let photo = photos[indexPath.item]
        
        //if user taps label, run rename ac
        let ac = UIAlertController(title: "Add Label", message: nil, preferredStyle: .alert)
        
        //Add Text Field
        ac.addTextField()
        
        //Add Cancel action
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        //Add Insert new Label action, and assign new label entered by user
        ac.addAction(UIAlertAction(title: "OK", style: .default) {
            [unowned self, ac] _ in
            
            let newLabel = ac.textFields![0]
            photo.label = newLabel.text!
            
            self.collectionView?.reloadData()
            
            //Update saved data (photos array object) on disk
            //self.secureSave()
                //Commented out so the UIVC isn't hidden
        })
        
        //Add Delete Photo action
        ac.addAction(UIAlertAction(title: "Delete Photo", style: .default) {
            [unowned self] _ in
            
            self.photos.remove(at: indexPath.item)
            self.collectionView?.reloadData()
        })
        
        //Present alert to the user
        present(ac, animated: true)
    }

    //Trigger image picker when user taps 'add' Nav Bar button
    @IBAction func addButtonTapped(_ sender: Any) {
        
        //Check collectionView is not hidden
        
        //If hidden, call authenticateUser method
        if collectionView.isHidden {
            authenticateUser()
        
        //If not hidden, allow user to proceed.
        } else {
    
            //Create new image picker from camera roll
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            
            //Allow user to crop selected image
            imagePicker.delegate = self
            present(imagePicker, animated: true)
        }
    }
    
    //Get Document Directory helper method
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    //Add image chosen from album, or new photo taken, to photos array
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //Pull out the Image from the image Picker
        guard let image = info[.originalImage] as? UIImage else { return }

        //Create random file name using UUID to save the image
        let imageName = UUID().uuidString

        //Get path to store chosen image to disk (unsecurely)
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

        //Convert the UIImage contained in imageName to a Data Object (so it can be saved), then save it to disk (at imagePath)
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        //Create a new photo object (with photo selected by user from photo album)
        let photo = Photo(image: imageName, label: "Unlabelled")
        
        //Add new photo object to photos array object
        photos.append(photo)
        
        //Refresh collectionView to display new photo cell object
        collectionView?.reloadData()
        
        dismiss(animated: true)
        
        //Save photos array
        //secureSave()
            //commented out so the collectionView isn't hidden
    }

    //Trigger camera when user taps 'camera' Nav Bar button
    @IBAction func cameraButtonTapped(_ sender: Any) {
        
        //Check ViewController is not hidden
        
        //If locked, call authenticateUser method
        if collectionView.isHidden {
            authenticateUser()
            
        //If not hidden, allow user to proceed.
        } else {
        
            //If simulator, trigger alert since camera not available on simulator
            #if targetEnvironment(simulator)
            
                //Create an alert
                let ac = UIAlertController(title: "Simulator in use", message: "You can only use the camera on a real device", preferredStyle: .alert)

                //Create Dimiss Alert button
                ac.addAction(UIAlertAction(title: "OK", style: .default))

                //Present Alert
                present(ac, animated: true)

            //If real device, trigger camera app
            #else
            
                //Create new image picker from a photo taken by camera
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                //Set source as camera app
                imagePicker.sourceType = .camera
            
                //Present image Picker
                present(imagePicker, animated: true)
            
            #endif
        }
    }
    
    //Method to write photo objects to Keychain (triggered when user hides app or switches to multitask mode)
    @objc func secureSave() {
        
        //Ensure collectionView is not hidden first so we don't inadvertantly overwrite saved photos data
        if !collectionView.isHidden {
        
            //Convert photos array object to json data object, in readiness for saving to disk
            let jsonEncoder = JSONEncoder()
            if let savedPhotos = try? jsonEncoder.encode(photos) {
                _ = KeychainWrapper.standard.set(savedPhotos, forKey: "SecurePhotos")
                
            } else {
                print("Failed to save photos array")
            }
            
            //Hide the CollectionView so photos aren't visible in app switcher or when app is relaunched
            collectionView.isHidden = true
            title = "Photos Locked 🔒"
        }

    } // End secureSave() method

    
    //Method to load encrypted "Data Object" from Keychain (if any saved) and display in collectionView cell
    func loadSecurePhotos() {
        
        //Unhide UIView
        collectionView.isHidden = false
        title = "Photos Unlocked 🔓"
        
        //Set collectionView cell/s to saved photos
        if let savedPhotos = KeychainWrapper.standard.data(forKey: "SecurePhotos") {
            
            //Decode saved json Data object
            let jsonDecoder = JSONDecoder()
            
            do {
                photos = try jsonDecoder.decode([Photo].self, from: savedPhotos)
                
            } catch {
                print("Failed to load photos")
            }
        }
        
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    //Authenticate user on app load
    func authenticateUser() {
    
    //If physical device, start user authentication process
    #if !targetEnvironment(simulator)
    
        //Check device supports biometric authentication
        let context = LAContext()
        var error: NSError?
        
        //If device supports biometric authentication
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let authReason = "Authenticate to unlock Photos"
            
            //Request biometric system to start check now, with message advising user why auth is being requested
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: authReason) {
                [unowned self] (success, authenticationError) in
                
                //If user authentication successful, load photos
                DispatchQueue.main.async {
                    if success {
                    self.loadSecurePhotos()
                    
                    //Handle if user authentication fails
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified. Please try again", preferredStyle: .alert)
                        
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated: true)
                    }
                }
            }
        
        //Password fallback if device doesn't support biometric authentication
        } else {

            //Call password manager
            self.passwordFallBack()
        }
    
    //If simulator, fallback to password
    #else
        if true {
            DispatchQueue.main.async {
                if true {
                    self.passwordFallBack()
                }
            }
        }
    
    //End compiler directive
    #endif
    
    }//End authenticateUser() method
    
    //Authenticate user via password if device doesn't support biometrics
    func passwordFallBack() {
        
        //Check if password already exists
        if let _ = KeychainWrapper.standard.string(forKey: "SecurePassword") {
            
            //If password exists
            let alertController = UIAlertController(title: "Enter app password", message: nil, preferredStyle: .alert)
            alertController.addTextField { textField in
                textField.isSecureTextEntry = true
                
            }
            
            let submitAction = UIAlertAction(title: "Submit", style: .default) {
                [unowned self, alertController] (action: UIAlertAction) in
                
                //Check password entered matches saved password
                let text = alertController.textFields![0]
                let password = KeychainWrapper.standard.string(forKey: "SecurePassword")
                
                //If text entered matches saved password, open app
                if text.text! == password {
                    self.loadSecurePhotos()
                    
                } else {
                    
                    //Exit process
                    return
                }
                
            }
            
            //Present Alert
            alertController.addAction(submitAction)
            present(alertController, animated: true)
            
        //If password doesn't exist, create alert to prompt user to create new password
        } else {
            let alertController = UIAlertController(title: "Create app password", message: nil, preferredStyle: .alert)
            alertController.addTextField { textField in
                textField.isSecureTextEntry = true
                
            }
            
            let submitAction = UIAlertAction(title: "Submit", style: .default) {
                [unowned self, alertController] (action: UIAlertAction) in
                let text = alertController.textFields![0]
                
                //Once password set, open app
                self.loadSecurePhotos()
                
                //Save password to Keychain
                _ = KeychainWrapper.standard.set(text.text!, forKey: "SecurePassword")
            }
            
            //Present Alert
            alertController.addAction(submitAction)
            present(alertController, animated: true)
        }
        
    } //End passswordFallback() method

}

