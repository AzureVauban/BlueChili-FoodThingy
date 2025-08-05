//
//  ViewController.swift
//  ios101-project6-tumblr
//

import UIKit


struct Recipe: Codable {
    let id: Int
    let title: String
}

struct RecipeSearchResponse: Codable {
    let results: [Recipe]
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var recipes: [Recipe] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        fetchRecipes(query: "pasta")
    }

    func fetchRecipes(query: String) {
        let apiKey = "YOUR_SPOONACULAR_API_KEY"
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let urlString = "https://api.spoonacular.com/recipes/complexSearch?query=\(encodedQuery)&apiKey=\(apiKey)"

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
                let response = try JSONDecoder().decode(RecipeSearchResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.recipes = response.results
                    self?.tableView.reloadData()
                }
            } catch {
                print("❌ Decoding error: \(error.localizedDescription)")
            }
        }.resume()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        cell.summaryLabel.text = recipes[indexPath.row].title
        return cell
    }
}
