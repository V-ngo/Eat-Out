/**
* PrefResultViewController: Displays list of restarestaurants based on user's preferences
*
* @author  Sai Swetha Chiguruvada
*/

import UIKit

class PrefResultViewController: UIViewController {
    
    @IBOutlet weak var filteredRestaurantImg: UIImageView!
    @IBOutlet weak var filteredRestaurantName: UITextView!
    @IBOutlet weak var filteredRestaurantAddress: UITextView!
    @IBOutlet weak var filteredFestaurantPrice: UITextView!
    @IBOutlet weak var filteredFestaurantRating: UITextView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var networking = Networking()
    var allRestaurant: [Result1] = []
    var openRestaurant: [Result1] = []
    var totalRestaurant = 0
    var indexed = 0
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.95, alpha: 1.00)
        super.viewDidLoad()
        Task {
            do {
                let result = try await networking.getRestaurantDataForFilters()
                allRestaurant = result
                
                //Get all opening now restaurants
                if (allRestaurant.count != 0) {
                    for x in allRestaurant {
                        if (x.openingHours?.openNow == true) {
                            openRestaurant.append(x)
                        }
                    }
                    
                    // Randomize restaurant array to get different order
                    openRestaurant = openRestaurant.shuffled()
                    
                    // Calculate numbers of restaurants and display result on screen
                    totalRestaurant = (openRestaurant.count)
                    print("Number of Restaurants:: \(totalRestaurant)")
                    
                    // If there is no restaurant matches preferences, print alert
                    if (totalRestaurant == 0) {
                        let alert = UIAlertController(title: "No open restaurants!!!", message: "There are no restaurants matching your search.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else if (totalRestaurant == 1) {
                        self.nextButton.isHidden = true
                        self.previousButton.isHidden = true
                        printResult(restaurantIndex: indexed, key: networking.keyAPI)
                    } else {
                        printResult(restaurantIndex: indexed, key: networking.keyAPI)
                    }
                    
                    await MainActor.run {}
                }
            } catch {
                print(error)
            }
        }
    }
    
    // Get result for the previous restaurant
    @IBAction func filteredPreviousButton(_ sender: Any) {
        if (indexed != 0) {
            indexed -= 1
            printResult(restaurantIndex: indexed, key: networking.keyAPI)
        } else {
            indexed = 0
        }
    }
    
    // Get result for the next restaurant
    @IBAction func filteredNextButton(_ sender: Any) {
        if (indexed < totalRestaurant - 1) {
            indexed += 1
            printResult(restaurantIndex: indexed, key: networking.keyAPI)
        }
    }
    
    // Get restaurant result
    func printResult(restaurantIndex: Int, key: String) {
        // Get image of restaurant for background picture
        var imgReference: String = ""
        if let photo: [Photo1] = openRestaurant[restaurantIndex].photos {
            for imgIndex in photo {
                imgReference = imgIndex.photoReference
            }
        }

        if !(imgReference.isEmpty) {
            let imgURL = URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=" +
                                     imgReference + "&key=" + key)

            filteredRestaurantImg.load(url: imgURL!)
            filteredRestaurantImg.fadeTransition(0.3)

        }

        // Get restaurant name
        DispatchQueue.main.async {
            self.filteredRestaurantName.text = self.openRestaurant[restaurantIndex].name
            self.filteredRestaurantName.textAlignment = NSTextAlignment.center
            self.filteredRestaurantName.textColor = UIColor(red: 0.29, green: 0.33, blue: 0.39, alpha: 1.00)
            self.filteredRestaurantName.font = UIFont(name: "Cochin-Bold", size: 25.0)
            self.filteredRestaurantName.textContainerInset = UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5)
            self.filteredRestaurantName.backgroundColor = .clear
            self.filteredRestaurantName.isEditable = false
            self.filteredRestaurantName.fadeTransition(0.3)
        }

        // Get restaurant adress
        DispatchQueue.main.async {
            self.filteredRestaurantAddress.text = self.openRestaurant[restaurantIndex].vicinity
            self.filteredRestaurantAddress.textAlignment = NSTextAlignment.center
            self.filteredRestaurantAddress.textColor = UIColor(red: 0.29, green: 0.33, blue: 0.39, alpha: 1.00)
            self.filteredRestaurantAddress.font = UIFont(name: "MuktaMahee-Regular", size: 20.0)
            self.filteredRestaurantAddress.textContainerInset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
            self.filteredRestaurantAddress.backgroundColor = .clear
            self.filteredRestaurantAddress.isEditable = false
            self.filteredRestaurantAddress.fadeTransition(0.3)
        }
        
        // Get restaurant rating
        if (openRestaurant[restaurantIndex].rating) != nil {
            DispatchQueue.main.async {
                self.filteredFestaurantRating.text = String((self.openRestaurant[restaurantIndex].userRatingsTotal)!) + " people tried this place and rate this restaurant " + String((self.openRestaurant[restaurantIndex].rating)!) + " out of 5 stars."
                
                self.filteredFestaurantRating.textAlignment = NSTextAlignment.center
                self.filteredFestaurantRating.textColor = UIColor(red: 0.29, green: 0.33, blue: 0.39, alpha: 1.00)
                self.filteredFestaurantRating.font = UIFont(name: "MuktaMahee-Regular", size: 20.0)
                self.filteredFestaurantRating.textContainerInset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
                self.filteredFestaurantRating.backgroundColor = .clear
                self.filteredFestaurantRating.isEditable = false
                self.filteredFestaurantRating.fadeTransition(0.3)
            }
        }

        // Get restaurant pricing level
        if (openRestaurant[restaurantIndex].priceLevel) != nil {
            DispatchQueue.main.async {
                self.filteredFestaurantPrice.text = "Price level: " + String((self.openRestaurant[restaurantIndex].priceLevel)!) +
                                        " / 5 \n (1-Lowest, 5-Highest)"
                self.filteredFestaurantPrice.textAlignment = NSTextAlignment.center
                self.filteredFestaurantPrice.textColor = UIColor(red: 0.29, green: 0.33, blue: 0.39, alpha: 1.00)
                self.filteredFestaurantPrice.font = UIFont(name: "MuktaMahee-Regular", size: 17.0)
                self.filteredFestaurantPrice.textContainerInset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
                self.filteredFestaurantPrice.backgroundColor = .clear
                self.filteredFestaurantPrice.isEditable = false
                self.filteredFestaurantPrice.fadeTransition(0.3)
            }
        } else {
            DispatchQueue.main.async {
                self.filteredFestaurantPrice.text = "There is no price information."
                self.filteredFestaurantPrice.textAlignment = NSTextAlignment.center
                self.filteredFestaurantPrice.textColor = UIColor(red: 0.29, green: 0.33, blue: 0.39, alpha: 1.00)
                self.filteredFestaurantPrice.font = UIFont(name: "MuktaMahee-Regular", size: 17.0)
                self.filteredFestaurantPrice.textContainerInset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
                self.filteredFestaurantPrice.backgroundColor = .clear
                self.filteredFestaurantPrice.isEditable = false
                self.filteredFestaurantPrice.fadeTransition(0.3)
            }
        }
    }
    
}
