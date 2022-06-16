/**
* PreferenceViewController: This screen has preference options which user can select to get restaurants based on his/her preferences
*
* @author  Sai Swetha Chiguruvada
*/

import Foundation
import UIKit

class CellClass: UITableViewCell {}

//Declaring default values for maximum, minimum price range, rating level, radius so that it can be used in Networking struct to check if user has chosen values
var max: Int = -1
var min: Int = -1
var rating: Int = -1
var radiusVal: Int = 0

class PreferenceViewController: UIViewController {
    
    @IBOutlet weak var maximumPriceButton: UIButton!
    @IBOutlet weak var minimumPriceButton: UIButton!
    @IBOutlet weak var radiusButton: UIButton!
    @IBOutlet weak var ratingButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var getRestaurantsButton: UIButton!
    
    let transparentView = UIView()
    let subTableView = UITableView()
    var selectedButton = UIButton()
    var options = [String]()
    var optionLevels:[String:Int] = ["Most affordable - 1":0, "Affordable - 2":1, "Neutral - 3":2, "Expensive - 4":3, "Most Expensive - 5":4]

    @IBAction func getRestaurants(_ sender: UIButton) {
        let maximumPrice = maximumPriceButton.currentTitle
        let minimumPrice = minimumPriceButton.currentTitle
        let ratingLevel = ratingButton.currentTitle
        let radius = radiusButton.currentTitle
        
        // Print error if nothing is selected
        if ((maximumPrice == nil && minimumPrice == nil && ratingLevel == nil  && radius == nil) || (maximumPrice == "Select maximum price range" && minimumPrice == "Select minimum price range" && ratingLevel == "Select rating level"  && radius == "Select radius (in metres)")) {
            let alert = UIAlertController(title: "Missing preference!!!", message: "Please choose your preference to get restaurants.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        // Set maximum price
        if (maximumPrice != nil && maximumPrice != "Select maximum price range") {
            max = optionLevels[maximumPrice!]!
        }
        // Set minimum price
        if (minimumPrice != nil && minimumPrice != "Select minimum price range") {
            min = optionLevels[minimumPrice!]!
        }
        //Set rating level
        if (ratingLevel != nil && ratingLevel != "Select rating level") {
            rating = Int(ratingLevel!)!
        }
        // Set radius
        if (radius != nil && radius != "Select radius (in metres)"){
           radiusVal = Int(radius!)!
        }
        
    }
    
    
    // Reset button
    @IBAction func resetAction(_ sender: UIButton) {
        minimumPriceButton.setTitle("Select minimum price range", for: .normal)
        maximumPriceButton.setTitle("Select maximum price range", for: .normal)
        radiusButton.setTitle("Select radius (in metres)", for: .normal)
        ratingButton.setTitle("Select rating level", for: .normal)
        max = -1
        min = -1
        rating = -1
    }
    
    // Select maximum pricing options
    @IBAction func maxPriceAction(_ sender: Any) {
        self.options = ["Most Expensive - 5", "Expensive - 4", "Neutral - 3"] //2,3,4
        selectedButton = maximumPriceButton
        addTransparentView(frames: maximumPriceButton.frame)
    }
    
    // Select minimum pricing options
    @IBAction func minPriceAction(_ sender: Any) {
        self.options = ["Most affordable - 1", "Affordable - 2", "Neutral - 3"] //0,1,2
        selectedButton = minimumPriceButton
        addTransparentView(frames: minimumPriceButton.frame)
    }
    
    //Selecting rating level
    @IBAction func ratingAction(_ sender: Any) {
        self.options = [ "5", "4", "3", "2", "1"]
        selectedButton = ratingButton
        addTransparentView(frames: ratingButton.frame)
    }
    
    // Select radius options
    @IBAction func radiusAction(_ sender: Any) {
        self.options = [ "500", "1000", "2000", "5000"]
        selectedButton = radiusButton
        addTransparentView(frames: radiusButton.frame)
    }
    
    // Gets list of options as a dropdown menu
    func addTransparentView(frames: CGRect) {
        let window = UIApplication.shared.keyWindow
        transparentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentView)
        subTableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width , height: 0.0)
        self.view.addSubview(subTableView)
        subTableView.layer.cornerRadius = 5
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        subTableView.reloadData()
        
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapgesture)
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0,  options: .curveEaseOut, animations: {
            self.transparentView.alpha = 0.5
            self.subTableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width , height: CGFloat(self.options.count * 50))
        }, completion: nil)
    }
    
    // Removes dropdown menu after user has selected
    @objc func removeTransparentView() {
        let frames = selectedButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0,  options: .curveEaseOut, animations: {
            self.transparentView.alpha = 0
            self.subTableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width , height: 0)
        }, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.resetButton.layer.cornerRadius = 5
        self.getRestaurantsButton.layer.cornerRadius = 5
        self.maximumPriceButton.layer.cornerRadius = 25
        self.minimumPriceButton.layer.cornerRadius = 25
        self.ratingButton.layer.cornerRadius = 25
        self.radiusButton.layer.cornerRadius = 25
        self.titleLabel.font = UIFont(name: "GillSans-Light", size: 30.0)
        self.view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.95, alpha: 1.00)
        subTableView.delegate = self
        subTableView.dataSource = self
        subTableView.register(CellClass.self, forCellReuseIdentifier: "CellClass")
    }
    
}

extension PreferenceViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellClass", for: indexPath)
        cell.textLabel?.text = options[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedButton.setTitle(options[indexPath.row], for:.normal)
        removeTransparentView()
    }
}



