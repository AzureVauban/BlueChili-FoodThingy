//
//  ViewController.swift
//  ios101-project6-tumblr
//

import UIKit


struct FoodItem: Codable {
    let description: String
    let fdcId: Int
}

struct FoodSearchResponse: Codable {
    let foods: [FoodItem]
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var foodItems: [FoodItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        fetchFoods(query: "apple")
    }

    func fetchFoods(query: String) {
        let apiKey = "vnAcplRkdIwfthG2GLBytFzKwcX2ibR6DVk4wmgq"
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let urlString = "https://api.nal.usda.gov/fdc/v1/foods/search?query=\(encodedQuery)&api_key=\(apiKey)"

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("❌ No data")
                return
            }

            do {
                let response = try JSONDecoder().decode(FoodSearchResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.foodItems = response.foods
                    self?.tableView.reloadData()
                }
            } catch {
                print("❌ Decoding error: \(error.localizedDescription)")
            }
        }.resume()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        cell.textLabel?.text = foodItems[indexPath.row].description
        return cell
    }
}
