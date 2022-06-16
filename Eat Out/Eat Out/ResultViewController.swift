/**
* ResultViewController: Displays list of restarestaurants based on user's location
*
* @author  Vy Ngo
*/

import UIKit

var openRestaurant: ResultConfig?
var savedList: [Int] = []

class ResultViewController: UIViewController {
    
    @IBOutlet weak var restaurantImg: UIImageView!
    @IBOutlet weak var restaurantName: UITextView!
    @IBOutlet weak var restaurantAddress: UITextView!
    @IBOutlet weak var restaurantPrice: UITextView!
    @IBOutlet weak var restaurantRating: UITextView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func saveAction(_ sender: Any) {
        if (!savedList.contains(saved)) {
            savedList.append(saved)
            print("savedList: \(savedList)")
        }
    }
    @IBAction func removeAction(_ sender: Any) {
        savedList.remove(at: saved)
        print("savedList: \(savedList)")
    }
    @IBAction func previousButton(_ sender: Any) {
        if (indexed != 0) {
            indexed -= 1
            printResult(restaurantIndex: indexed, key: networking.keyAPI)
        } else {
            indexed = 0
        }
    }
    @IBAction func nextButton(_ sender: Any) {
        if (indexed < totalRestaurant - 1) {
            indexed += 1
            printResult(restaurantIndex: indexed, key: networking.keyAPI)
        } else {
            indexed = 0
        }
    }
    
    let networking = Networking()
    var allRestaurant: ResultConfig?
    var totalRestaurant = 0
    var indexed = 0
    var saved = 0
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.95, alpha: 1.00)
        super.viewDidLoad()
        
        Task {
            do {
                let result = try await networking.getRestaurantData()
                allRestaurant = result
                
                //Get all opening now restaurants
                for (index, _) in ((allRestaurant?.results)!).enumerated() {
                    if (allRestaurant?.results[index].openingHours?.openNow) != nil {
                        if (allRestaurant?.results[index].openingHours?.openNow)! == true {
                            openRestaurant = allRestaurant
                        }
                    }
                }
                
                // Calculate numbers of restaurants and display result on screen
                totalRestaurant = (openRestaurant?.results.count)!
                
                if (totalRestaurant == 1) {
                    previousButton.isHidden = true
                    nextButton.isHidden = true
                    printResult(restaurantIndex: indexed, key: networking.keyAPI)
                } else {
                    printResult(restaurantIndex: indexed, key: networking.keyAPI)
                }
               
                await MainActor.run {}
            } catch {
                print(error)
            }
        }
    }
    
    // Get restaurant result
    func printResult(restaurantIndex: Int, key: String) {
        // Get favorite restaurant data
        saved = restaurantIndex
        print("Inside printResult \(saved)")
        
        // Get image of restaurant for background picture
        var imgReference: String = ""
        if let photo: [Photo] = openRestaurant?.results[restaurantIndex].photos {
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
            self.restaurantName.text = openRestaurant?.results[restaurantIndex].name
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
            self.restaurantAddress.text = openRestaurant?.results[restaurantIndex].vicinity
            self.restaurantAddress.textAlignment = NSTextAlignment.center
            self.restaurantAddress.textColor = UIColor(red: 0.29, green: 0.33, blue: 0.39, alpha: 1.00)
            self.restaurantAddress.font = UIFont(name: "MuktaMahee-Regular", size: 20.0)
            self.restaurantAddress.textContainerInset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
            self.restaurantAddress.backgroundColor = .clear
            self.restaurantAddress.isEditable = false
            self.restaurantAddress.fadeTransition(0.3)
        }
        
        // Get restaurant rating
        if (openRestaurant?.results[restaurantIndex].rating) != nil {
            DispatchQueue.main.async {
                self.restaurantRating.text = String((openRestaurant?.results[restaurantIndex].userRatingsTotal)!) + " people tried this place and rate this restaurant " + String((openRestaurant?.results[restaurantIndex].rating)!) + " out of 5 stars."
                
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
        if (openRestaurant?.results[restaurantIndex].priceLevel) != nil {
            DispatchQueue.main.async {
                self.restaurantPrice.text = "Price level: " + String((openRestaurant?.results[restaurantIndex].priceLevel)!) +
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

// Display image on the screen
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        self?.contentMode = .scaleAspectFit
                    }
                }
            }
        }
    }
}

// Fade animation
extension UITextView {
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}

extension UIImageView {
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}
