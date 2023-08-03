//
//  ViewController.swift
//  Users
//
//  Created by Edgar Sargsyan on 21.07.23.

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var users: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsers { [weak self] users in
            if let users = users {
                DispatchQueue.main.async {
                    self?.users = users
                    self?.tableView.reloadData()
                }
            }
        }
    }

    func fetchUsers(completion: @escaping ([User]?) -> Void) {
        let url = URL(string: "https://randomuser.me/api?results=50")!

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Ошибка при выполнении запроса: \(error)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("Получены пустые данные")
                completion(nil)
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                if let results = json?["results"] as? [[String: Any]] {
                    var users: [User] = []
                    for result in results {
                        if let name = result["name"] as? [String: String],
                           let firstName = name["first"],
                           let lastName = name["last"],
                         let title = name["title"] {
                            let user = User(firstName: firstName, lastName: lastName, title: title)
                            users.append(user)
                        }
                    }
                    completion(users)
                }
            } catch {
                print("Ошибка при разборе данных: \(error)")
                completion(nil)
            }
        }.resume()
    }
}

extension ViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let user = users[indexPath.row]
        cell.textLabel?.text = "\(user.firstName) \(user.lastName)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserViewController") as! UserViewController
        
        vc.testResult = users[indexPath.row].title
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
}
