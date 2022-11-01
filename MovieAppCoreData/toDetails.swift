
import UIKit
import CoreData

class toDetails: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var txtYear: UITextField!
    
    @IBOutlet weak var txtDirector: UITextField!
    
    var didImageSelected = false
    
    
    var chosenMovie = ""
    var chosenMovieID : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        imageView.isUserInteractionEnabled = true
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(CloseKeyboard))
        let recognizerImage = UITapGestureRecognizer(target: self, action: #selector(SelectImage))
        
        imageView.addGestureRecognizer(recognizerImage)
       view.addGestureRecognizer(recognizer)
        
        LoadMovieInfo()
       
    }
    
    func LoadMovieInfo(){
        
        if chosenMovie != ""{
            
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Movies")
            let idString = chosenMovieID?.uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
            fetchRequest.returnsObjectsAsFaults = false
            
            do{
             
                let results =  try context.fetch(fetchRequest)
                if results.count>0{
                    for result in results as! [NSManagedObject]{
                        if let name = result.value(forKey: "movieName") as? String{
                            txtName.text = name
                        }
                        
                        if let year = result.value(forKey: "year") as? Int{
                            txtYear.text = String(year)
                        }
                        
                        if let director = result.value(forKey: "director") as? String{
                            txtDirector.text = director
                        }
                        
                        if let imageData = result.value(forKey: "image") as? Data{
                            let image = UIImage(data: imageData)
                            imageView.image = image
                        }
                    }
                }
                    
                
            }
            
            catch{

            }
            
            
        }
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
                
                WeMadeIt()
            }
            catch{
               
                AlertMessageBuilder(Message: error as! String)
                
            }
        }
        else{
           
           
            AlertMessageBuilder(Message: "Please select an image")
        }
     
        
        func WeMadeIt(){
            
            AlertMessageBuilder(Message: "\(txtName.text!) movie added to list!")
            txtName.text=""
            txtDirector.text=""
            txtYear.text=""
            imageView.image = UIImage(named: "selectImage")
            
            NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
                 
        
        }
        
        func AlertMessageBuilder(Message:String){
            let alert = UIAlertController(title: "Warning", message: Message, preferredStyle: .alert)
            let OK = UIAlertAction(title: "OK", style: .default)
            alert.addAction(OK)
            self.present(alert, animated: true)
            
        }
 
        
    }
    
}
