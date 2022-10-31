
import UIKit
import CoreData

class toDetails: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var txtYear: UITextField!
    
    @IBOutlet weak var txtDirector: UITextField!
    
    var didImageSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(CloseKeyboard))
        let recognizerImage = UITapGestureRecognizer(target: self, action: #selector(SelectImage))
        
        imageView.addGestureRecognizer(recognizerImage)
       view.addGestureRecognizer(recognizer)
       
    }
    
    @objc func SelectImage(){
        if !didImageSelected{
            
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            present(picker, animated:true, completion: nil)
            didImageSelected = true
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    @objc func CloseKeyboard()
    {
        view.endEditing(true)
    }

    @IBAction func Save(_ sender: Any) {
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newMovie = NSEntityDescription.insertNewObject(forEntityName: "Movies", into: context)
        
        newMovie.setValue(UUID(), forKey: "id")
        newMovie.setValue(txtName.text!, forKey: "movieName")
        if let year = Int(txtYear.text!){
            newMovie.setValue(year, forKey: "year")

        }
        newMovie.setValue(txtDirector.text!, forKey: "director")
        
        if didImageSelected{
            let data = imageView.image?.jpegData(compressionQuality: 0.5)
            newMovie.setValue(data, forKey: "image")
            
            do{
                try context.save()
            }
            catch{
               
                AlertMessageBuilder(Message: error as! String)
                
            }
        }
        else{
           
           
            AlertMessageBuilder(Message: "Please select an image")
        }
     
        
        func AlertMessageBuilder(Message:String){
            let alert = UIAlertController(title: "Warning", message: Message, preferredStyle: .alert)
            let OK = UIAlertAction(title: "OK", style: .default)
            alert.addAction(OK)
            self.present(alert, animated: true)
            
        }
 
        
    }
    
}
