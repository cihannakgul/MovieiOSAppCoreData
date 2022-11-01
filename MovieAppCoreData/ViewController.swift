

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var nameArray = [String]()
    var idArray = [UUID]()
    
    
    var selectedMovie = ""
    var selectedMovieID : UUID?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
      
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(TopRightButton))
        
        getData()
    }
    
   @objc func getData(){
       nameArray.removeAll(keepingCapacity: false)
       idArray.removeAll(keepingCapacity: false)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Movies")
        
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
             let results = try context.fetch(fetchRequest)
            
            if results.count > 0{
                for result in results as! [NSManagedObject]{
                    
                    if let name = result.value(forKey: "movieName") as? String{
                    self.nameArray.append(name)
                    }
                    
                    if let id = result.value(forKey: "id") as? UUID{
                    self.idArray.append(id)
                    }
                    
                    self.tableView.reloadData()
                    
                }
            }
          
        }
        
        catch{
            
            print ("error : \(error)")
        }
        
    }
    
  
    @objc func TopRightButton(){
        
        selectedMovie = ""
        performSegue(withIdentifier: "toDetailsVC", sender:nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newData"), object: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = nameArray[indexPath.row]
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedMovie = nameArray[indexPath.row]
        selectedMovieID = idArray[indexPath.row]
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDetailsVC"{
            let dest = segue.destination as! toDetails
            dest.chosenMovie = selectedMovie
            dest.chosenMovieID = selectedMovieID

            
        }
    }
 

}

