//
//  MovieListTableViewController.swift
//  FinalProject
//
//  Created by SWUCOMPUTER on 14/06/2019.
//  Copyright © 2019 SWUCOMPUTER. All rights reserved.
//

import UIKit
import CoreData

class MovieListTableViewController: UITableViewController {
    
    // 저장한 영화 후기 리스트 보여주기
    
    // cell사용하기 위해 tableview 연결하기
    @IBOutlet weak var tableview: UITableView!

    // 영화와 평점 저장할 배열 생성
    var movies: [NSManagedObject] = []
    var img:[NSManagedObject] = []
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 미리 패치하기
        let context = self.getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movies")
        
//        let sortDescriptor = NSSortDescriptor (key: "watchDate", ascending: true)
//        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            movies = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        do {
            img = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let name = appDelegate.userName {
            self.title = name + "님의 영화기록"   // 타이틀 변경
        }
        tableview.dataSource = self
        tableview.delegate = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title:"로그아웃 하시겠습니까?",message: "",preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            let urlString: String = "http://localhost:8888/login/logout.php"
            guard let requestURL = URL(string: urlString) else { return }
            var request = URLRequest(url: requestURL)
            request.httpMethod = "POST"
            let session = URLSession.shared
            let task = session.dataTask(with: request) { (responseData, response, responseError) in
                guard responseError == nil else { return }
            }
            task.resume()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginView = storyboard.instantiateViewController(withIdentifier: "loginView")
            self.present(loginView, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieListTableViewCell    // cell.swift에 있는 변수들 사용하기 위함

        // 영화 이름 띄우기
        let movie = movies[indexPath.row]
        var display: String = ""
        if let movieTitleLabel = movie.value(forKey: "movieTitle") as? String {
            display = movieTitleLabel
        }
        
        // 영화 본 날짜 띄우기
        let dbDate: Date? = movie.value(forKey: "watchDate") as? Date
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let unwrapDate = dbDate {
            cell.textWathchDate?.text = formatter.string(from: unwrapDate as Date)
        }
        cell.textMovieTitle?.text = display
        //cell.gradeImage.image = UIImage(named: img[indexPath.row])
        
        // 평점별 별점 이미지 띄우기
        let grade = img[indexPath.row]
        if let gradeStar = grade.value(forKey: "grade") as? String {
            cell.gradeImage.image = UIImage(named: "\(gradeStar)"+".png")
        }
        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let movieGrade = appDelegate.userPoint
//        cell.gradeImage.image = UIImage(named: movieGrade[indexPath.row])

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // 테이블 삭제 가능
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            // Core Data 내의 해당 자료 삭제
            let context = getContext()
            context.delete(movies[indexPath.row])
            do {
                try context.save()
                print("deleted!")
            } catch let error as NSError {
                print("Could not delete \(error), \(error.userInfo)")
            }
            // 배열에서 해당 자료 삭제
            movies.remove(at: indexPath.row)
            // 테이블뷰 Cell 삭제
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toDetailView" {
            if let destination = segue.destination as? DetailViewController {
                if let selectedIndex = self.tableView.indexPathsForSelectedRows?.first?.row {
                    destination.detailMovie = movies[selectedIndex]
                }
            }
        }
    }
}
