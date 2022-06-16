/**
* Networking: Methods from this struct interacts with the Google API to get the list of restaurants.. Also restaurants are filtered based on preferences
*
* @author  Sai Swetha Chiguruvada and Vy Ngo
*/

import Foundation

struct Networking {
    
    // Get Google API URL
    var keyAPI = ""
    
    var baseURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location="
                    + currentLatitude + "," + currentLongitude
                    + "&radius=5000&type=restaurant"
    

    func getRestaurantData() async throws -> ResultConfig {
        let url = URL(string: "\(baseURL)&key=\(keyAPI)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        return try decoder.decode(ResultConfig.self, from: data)
    }
    
    func getRestaurantDataForFilters() async throws -> [Result1]  {
        print("\(radiusVal) \(min) \(max)")
        let decoder = JSONDecoder()
        var urlString :String = ""
        if (radiusVal != 0 && min == -1 && max == -1 ) {
            urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location="
            + currentLatitude + "," + currentLongitude
            + "&radius=\(radiusVal)" + "&type=restaurant"
            print("Only when user chose radius")
            let (data, _) = try await URLSession.shared.data(from: URL(string: "\(urlString)&key=\(keyAPI)")!)
            let result = try decoder.decode(PrefResultConfig.self, from: data)
            var dataResult: [Result1] = []
            for res in result.results {
                dataResult.append(res)
            }
            return dataResult
        } else if (radiusVal != 0) {
            urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location="
            + currentLatitude + "," + currentLongitude
            + "&radius=\(radiusVal)" + "&type=restaurant"
        } else {
            urlString = baseURL
        }
        let url = URL(string: "\(urlString)&key=\(keyAPI)")
        print(url?.absoluteString as Any)
        let (data, _) = try await URLSession.shared.data(from: url!)
        return filterData(try decoder.decode(PrefResultConfig.self, from: data), min, max, rating)
    }
    
    func filterData(_ result:PrefResultConfig, _ min:Int , _ max:Int, _ rating:Int) -> [Result1] {
        //print("Inside \(min) \(max) \(rating)")
        var dataResult: [Result1] = []
        for res in result.results {
            let dataRating = Int(res.rating ?? -4)
            let dataPrice = res.priceLevel ?? -4
            if (dataPrice != -4 && dataRating != -4) { //If unwrapped value is not nil
                if ((rating != -1 && dataRating == rating) && (dataPrice <= max && max != -1) && (min != -1 && dataPrice >= min)) { //If all options are chosen
                    print("Case 1: Satisfying all \(res.name)")
                    dataResult.append(res)
                }
                //Choose only max
                if (max != -1 && min == -1 && rating == -1) {
                    //print("Case 2: Only max \(res.name)")
                    if (dataPrice <= max) {
                        dataResult.append(res)
                    }
                }
                //Choose max & min
                if ((max != -1 && min != -1 && rating == -1) || (min != -1 && max != -1 && rating == -1)) {
                    //print("Case 3: Max & min \(res.name)")
                    if (dataPrice >= min && dataPrice <= max) {
                        dataResult.append(res)
                    }
                }
                //Only min
                if (min != -1 && max == -1 && rating == -1) {
                    //print("Case 4: Only min \(res.name)")
                    if (dataPrice >= min) {
                        dataResult.append(res)
                    }
                }
                if (rating != -1 && max == -1 && min == -1) {
                    //print("Case 6: Only rating \(res.name)")
                    if (dataRating == rating) {
                        dataResult.append(res)
                    }
                }
                //Max & rating
                if (rating != -1 && max != -1 && min == -1) {
                    //print("Case 7: Rating & max \(res.name)")
                    if (dataPrice <= max && dataRating == rating) {
                        dataResult.append(res)
                    }
                }
                //Min & rating
                if (rating != -1 && min != -1 && max == -1) {
                    // print("Case 8: Rating & min \(res.name)")
                    if (dataPrice >= min && dataRating == rating) {
                        dataResult.append(res)
                    }
                }
            }
        }
        return dataResult
    }
}
    


