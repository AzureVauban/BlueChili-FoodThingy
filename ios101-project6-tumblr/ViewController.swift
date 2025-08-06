//
//  ViewController.swift
//  ios101-project6-tumblr
//

import UIKit
import Nuke


struct Recipe: Codable {
    let id: Int
    let title: String
    let image: String
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
        let apiKey = Bundle.main.infoDictionary?["SPOONACULAR_API_KEY"] as? String ?? ""
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
                print(String(data: data, encoding: .utf8) ?? "No string output") // Debug print
                let response = try JSONDecoder().decode(RecipeSearchResponse.self, from: data)
                let filteredResults = response.results.filter { !$0.image.contains("667704") } // Add other known bad image IDs if needed
                DispatchQueue.main.async {
                    self?.recipes = filteredResults
                    self?.tableView.reloadData()
                }
            } catch {
                print("❌ Decoding error: \(error.localizedDescription)")
                if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) {
                    print("⚠️ Fallback JSON: \(jsonObject)")
                }
            }
        }.resume()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        let recipe = recipes[indexPath.row]

        // Set the title
        cell.summaryLabel.text = recipe.title

        // Clear previous image
        cell.postImageView.image = nil

        // Attempt to load image
        if let imageUrl = URL(string: recipe.image), recipe.image.lowercased().hasSuffix(".jpg") {
            print("🔍 Trying to load image from: \(imageUrl.absoluteString)")
            let request = ImageRequest(url: imageUrl)

            Nuke.ImagePipeline.shared.loadImage(with: request) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        cell.postImageView.image = response.image
                    case .failure(let error):
                        print("⚠️ Image load error: \(error)")
                        cell.postImageView.image = UIImage(named: "fallback") // Add fallback image to Assets
                    }
                }
            }
        } else {
            print("⚠️ Invalid or unsupported image URL: \(recipe.image)")
            cell.postImageView.image = UIImage(named: "fallback")
        }

        return cell
    }
}
