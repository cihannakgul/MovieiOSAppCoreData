

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("git test")
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(TopRightButton))
    }
    
  
    @objc func TopRightButton(){
        
        performSegue(withIdentifier: "toDetailsVC", sender:nil)
    }
    

    
 

}

