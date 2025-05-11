//
//  AddMovieViewController.swift
//  dya6 movie demo
//
//  Created by MacBook on 04/05/2025.
//

import UIKit

class AddMovieViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var genreTV: UITextView!
    @IBOutlet weak var movieImageV: UIImageView!
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var ratingTF: UITextField!
    @IBOutlet weak var titleTF: UITextField!

    var imageData:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = NSLocalizedString("addMovieNavTitle", comment: "Add Movie Navigation Title")
        let done = UIBarButtonItem(title: NSLocalizedString("doneBarBtn", comment: "Done Bar Button Item"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(onDone))
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(onCancel))
        self.navigationItem.rightBarButtonItem = done
        self.navigationItem.leftBarButtonItem = cancel
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.backgroundColor = .white
        datePicker.maximumDate = Date()
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelDatePicker))
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)

        dateTF.inputAccessoryView = toolbar
        dateTF.inputView = datePicker
    }
    

    @objc func onDone(){
//        let newMovie = Movie(title: titleTF.text ?? "", image: imageData ?? "", rating: Float(ratingTF.text ?? "0") ?? 0, releaseYear: Int(dateTF.text ?? "0") ?? 0, genre: genreTV.text.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) })

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newMovie = Movie(context: context)
        newMovie.title = titleTF.text ?? ""
        newMovie.image = imageData ?? ""
        newMovie.rating = ratingTF.text ?? "0"
        newMovie.releaseYear = dateTF.text ?? "0"
        newMovie.genre = genreTV.text ?? ""
        
        do{
            try context.save()
        } catch let error as NSError{
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        do{
            let moviesList = try context.fetch(Movie.fetchRequest())
            print("movies list count after insertion: \(moviesList.count)")
        }catch let error as NSError{
            print(error)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func onCancel(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func uploadImage(_ sender: Any) {
        let alert = UIAlertController(title: NSLocalizedString("uploadImgAlertTitle", comment: ""), message: NSLocalizedString("uploadImgAlertMsg", comment: ""), preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: NSLocalizedString("camera", comment: "Camera"), style: .default) { (action) in
            
            let imagePicker = UIImagePickerController()
            if(UIImagePickerController.isSourceTypeAvailable(.camera)){
                imagePicker.sourceType = .camera
                imagePicker.delegate = self
                self.present(imagePicker, animated: true)
            } else{
                
            }
            
        }
        
        let galleryAction = UIAlertAction(title: NSLocalizedString("gallery", comment: "Gallery"), style: .default) { (action) in
            
            let imagePicker = UIImagePickerController()
            if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
                imagePicker.sourceType = .photoLibrary
                imagePicker.delegate = self
                self.present(imagePicker, animated: true, completion: nil)
            } else{
                
            }
        }
        
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: "Cancel"), style: .cancel, handler: nil))
        self.present(alert, animated: true)
        
    }
    
    @objc func doneDatePicker() {
        if let datePicker = dateTF.inputView as? UIDatePicker {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy"
            dateTF.text = formatter.string(from: datePicker.date)
        }
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
         self.view.endEditing(true)
   }

}


extension AddMovieViewController : UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            movieImageV.image = image
            if let imageData = image.pngData() {
                self.imageData = imageData.base64EncodedString()
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
}
