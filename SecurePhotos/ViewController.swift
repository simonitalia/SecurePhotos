//
//  ViewController.swift
//  SecurePhotos
//
//  Created by Simon Italia on 4/4/19.
//  Copyright © 2019 SDI Group Inc. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //
    var photos = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Set VC title
        title = "Secure Photos"
        
    }
    
    //Set number of items to show
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return photos.count
    }
    
    //Create image picker so user can choose / add photos from camera roll
    @IBAction func addButtonPressed(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        
        //Allow user to crop selected image
        imagePicker.delegate = self
        present(imagePicker, animated: true)
        
    }
    
    
    
    


    
    


}

