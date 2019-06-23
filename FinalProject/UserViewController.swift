//
//  UserViewController.swift
//  FinalProject
//
//  Created by SWUCOMPUTER on 21/06/2019.
//  Copyright © 2019 SWUCOMPUTER. All rights reserved.
//

import UIKit
import CoreData

class UserViewController: UIViewController {

    var moviePoint:[NSManagedObject] = []
    
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
            moviePoint = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    // 두 번째 탭에 들어왔을 때
    @IBOutlet var movieCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {    // 탭 눌릴 때 마다 갱신하기
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let mc: Int = appDelegate.movieName.count
//        var s1: Int = 0
//        s1 = mc
        movieCount.text = "지금까지 총 " + "\(moviePoint.count)" + "편의 영화를 보셨군요!"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
