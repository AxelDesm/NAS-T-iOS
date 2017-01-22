//
//  CoverViewController.swift
//  NAS-T
//
//  Created by Axel on 30/11/16.
//  Copyright © 2016 Axel. All rights reserved.
//

import UIKit

class CoverViewController: UIViewController, UICollectionViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDataSource  {

    // MARK: Properties
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var libraryCollectionView: UICollectionView!
    
    let coverRepository = CoverRepository()
    var cover: Cover?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up views if editing an existing Cover.
        if let cover = cover {
            photoImageView.image = cover.thumbnail
            typeLabel.text = cover.type
            dateLabel.text = cover.stringDate()
        }
        
        libraryCollectionView.delegate = self
        libraryCollectionView.dataSource = self
        
        coverRepository.getDetail(cover: cover!) { gallery in
            self.cover?.gallery = gallery!
            self.libraryCollectionView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addImage(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet);
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }
        }))
       
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // Methods for ImagePicker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            coverRepository.addImage(cover: self.cover!, image: pickedImage) { isSuccess in
                if isSuccess {
                    self.cover?.gallery.append(pickedImage)
                    self.libraryCollectionView.reloadData()
                }
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    // Methods for CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.cover?.gallery.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = "cell"
        let cell = libraryCollectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ImageCellView
        
        cell.photoImageView.image = self.cover?.gallery[indexPath.row]
        
        return cell
    }
}
