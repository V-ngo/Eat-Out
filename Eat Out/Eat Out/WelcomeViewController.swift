/**
* WelcomeViewController: First screen on the API
*
* @author  Sai Swetha Chiguruvada
*/

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var tapView: UIView!
        
    @IBOutlet weak var welcomeNavigationItem: UINavigationItem!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var welcomeMsg: UILabel!
    
    @IBAction func didTapSender(_ sender: UITapGestureRecognizer) {
        //print("Tap")
        let location = sender.location(in: tapView)
        //print(location)
        performSegue(withIdentifier: "LocationSegue", sender: location)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.95, alpha: 1.00)
   }
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.95, alpha: 1.00)
        super.viewDidLoad()
        let screenSize: CGRect = UIScreen.main.bounds
        imageView.frame = CGRect(x: self.view.viewWidth()/2-150, y: 0, width: 300, height: (screenSize.height / 2))
        imageView.contentMode = .center
        welcomeMsg.text = "E A T    O U T !"
        welcomeMsg.textColor = UIColor(red: 0.29, green: 0.33, blue: 0.39, alpha: 1.00)
        welcomeMsg.font = UIFont(name: "Cochin", size: 40.0)
    }

}


