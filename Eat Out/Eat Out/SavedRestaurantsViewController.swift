/**
* SavedRestaurantsViewController: Displays restarestaurants which are saved by the user
*
* @author  Sai Swetha Chiguruvada and Vy Ngo
*/

import UIKit

class SavedRestaurantsViewController: UIViewController {

    @IBOutlet weak var restaurantImg: UIImageView!
    @IBOutlet weak var restaurantName: UITextView!
    @IBOutlet weak var restaurantAddress: UITextView!
    @IBOutlet weak var restaurantPrice: UITextView!
    @IBOutlet weak var restaurantRating: UITextView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBAction func previousButtonAction(_ sender: Any) {
        if (indexed != 0) {
            indexed -= 1
            printResult(restaurantIndex: indexed, key: networking.keyAPI)
        } else {
            indexed = 0
        }
    }
    @IBAction func nextButtonAction(_ sender: Any) {
        if (indexed < savedRestaurants.count - 1) {
            indexed += 1
            printResult(restaurantIndex: indexed, key: networking.keyAPI)
        }
    }
    
    let networking = Networking()
    var savedRestaurants: [Result] = []
    var indexed = 0
    var saved = 0
    
    func getSavedRestaurants() {
        for save in savedList {
            savedRestaurants.append((openRestaurant?.results[save])!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if openRestaurant == nil {
            let alert = UIAlertController(title: "There are no saved restaurants", message: "Please save your favourite restaurants.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
        } else {
            getSavedRestaurants()
            print("Result \(savedRestaurants.count)")
            if (savedRestaurants.count == 1) {
                previousButton.isHidden = true
                nextButton.isHidden = true
                printResult(restaurantIndex: indexed, key: networking.keyAPI)
                
            }
             else if (savedRestaurants.count > 1) {
                printResult(restaurantIndex: indexed, key: networking.keyAPI)
            }
            else {
                let alert = UIAlertController(title: "There are no saved restaurants", message: "Please save your favourite restaurants.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func printResult(restaurantIndex: Int, key: String) {
        saved = restaurantIndex
        
        // Get image of restaurant for background picture
        var imgReference: String = ""
        if let photo: [Photo] = savedRestaurants[restaurantIndex].photos {
            for imgIndex in photo {
                imgReference = imgIndex.photoReference
            }
        }
        
        if !(imgReference.isEmpty) {
            let imgURL = URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=" +
                                     imgReference + "&key=" + key)
            
            restaurantImg.load(url: imgURL!)
            restaurantImg.fadeTransition(0.3)
        }
        
        // Get restaurant name
        DispatchQueue.main.async {
            self.restaurantName.text = self.savedRestaurants[restaurantIndex].name
            self.restaurantName.textAlignment = NSTextAlignment.center
            self.restaurantName.textColor = UIColor(red: 0.29, green: 0.33, blue: 0.39, alpha: 1.00)
            self.restaurantName.font = UIFont(name: "Cochin-Bold", size: 25.0)
            self.restaurantName.textContainerInset = UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5)
            self.restaurantName.backgroundColor = .clear
            self.restaurantName.isEditable = false
            self.restaurantName.fadeTransition(0.3)
        }
        
        // Get restaurant adress
        DispatchQueue.main.async {
            self.restaurantAddress.text = self.savedRestaurants[restaurantIndex].vicinity
            self.restaurantAddress.textAlignment = NSTextAlignment.center
            self.restaurantAddress.textColor = UIColor(red: 0.29, green: 0.33, blue: 0.39, alpha: 1.00)
            self.restaurantAddress.font = UIFont(name: "MuktaMahee-Regular", size: 20.0)
            self.restaurantAddress.textContainerInset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
            self.restaurantAddress.backgroundColor = .clear
            self.restaurantAddress.isEditable = false
            self.restaurantAddress.fadeTransition(0.3)
        }
        
        // Get restaurant rating
        if (self.savedRestaurants[restaurantIndex].rating) != nil {
            DispatchQueue.main.async {
                self.restaurantRating.text = String((self.savedRestaurants[restaurantIndex].userRatingsTotal)!) + " people tried this place and rate this restaurant " + String((self.savedRestaurants[restaurantIndex].rating)!) + " out of 5 stars."
                
                self.restaurantRating.textAlignment = NSTextAlignment.center
                self.restaurantRating.textColor = UIColor(red: 0.29, green: 0.33, blue: 0.39, alpha: 1.00)
                self.restaurantRating.font = UIFont(name: "MuktaMahee-Regular", size: 20.0)
                self.restaurantRating.textContainerInset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
                self.restaurantRating.backgroundColor = .clear
                self.restaurantRating.isEditable = false
                self.restaurantRating.fadeTransition(0.3)
            }
        }
        
        // Get restaurant pricing level
        if (self.savedRestaurants[restaurantIndex].priceLevel) != nil {
            DispatchQueue.main.async {
                self.restaurantPrice.text = "Price level: " + String((self.savedRestaurants[restaurantIndex].priceLevel)!) +
                                        " / 5 \n (1-Lowest, 5-Highest)"
                self.restaurantPrice.textAlignment = NSTextAlignment.center
                self.restaurantPrice.textColor = UIColor(red: 0.29, green: 0.33, blue: 0.39, alpha: 1.00)
                self.restaurantPrice.font = UIFont(name: "MuktaMahee-Regular", size: 17.0)
                self.restaurantPrice.textContainerInset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
                self.restaurantPrice.backgroundColor = .clear
                self.restaurantPrice.isEditable = false
                self.restaurantPrice.fadeTransition(0.3)
            }
        } else {
            DispatchQueue.main.async {
                self.restaurantPrice.text = "There is no price information."
                self.restaurantPrice.textAlignment = NSTextAlignment.center
                self.restaurantPrice.textColor = UIColor(red: 0.29, green: 0.33, blue: 0.39, alpha: 1.00)
                self.restaurantPrice.font = UIFont(name: "MuktaMahee-Regular", size: 17.0)
                self.restaurantPrice.textContainerInset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
                self.restaurantPrice.backgroundColor = .clear
                self.restaurantPrice.isEditable = false
                self.restaurantPrice.fadeTransition(0.3)
            }
        }
    }
}


