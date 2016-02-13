import UIKit

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded profile")
        self.view.backgroundColor = UIColor.whiteColor()
        
    }
    
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}