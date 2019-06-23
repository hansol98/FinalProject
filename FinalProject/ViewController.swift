//
//  ViewController.swift
//  FinalProject
//
//  Created by SWUCOMPUTER on 14/06/2019.
//  Copyright © 2019 SWUCOMPUTER. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    // 로그인 구현 페이지
    
    @IBOutlet var loginID: UITextField!
    @IBOutlet var loginPW: UITextField!
    @IBOutlet var labelStatus: UILabel!
    
    // 키보드 내려가게 하기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.loginID {  // 아이디 입력후 done --> 다음 텍스트 필드로
            textField.resignFirstResponder()
            self.loginPW.becomeFirstResponder()
        }
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        labelStatus.text=""
    }

    // 로그인 버튼 눌렸을 때
    @IBAction func loginPressed(_ sender: UIButton) {
        // 오류처리
        if loginID.text == "" {
            labelStatus.text = "ID를 입력하세요"; return;
        }
        if loginPW.text == "" {
            labelStatus.text = "비밀번호를 입력하세요"; return;
        }
        let urlString: String = "http://condi.swu.ac.kr/student/T13/login/loginUser.php"
        guard let requestURL = URL(string: urlString) else {
            return
        }
        self.labelStatus.text = " "
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        let restString: String = "id=" + loginID.text! + "&password=" + loginPW.text!
        request.httpBody = restString.data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else {
                print("Error: calling POST")
                return
            }
            guard let receivedData = responseData else {
                print("Error: not receiving Data")
                return
            }
            do {
                let response = response as! HTTPURLResponse
                if !(200...299 ~= response.statusCode) {
                    print ("HTTP Error!")
                    return
                }
                guard let jsonData = try JSONSerialization.jsonObject(with: receivedData,
                                                                      options:.allowFragments) as? [String: Any] else {
                                                                        print("JSON Serialization Error!")
                                                                        return
                }
                guard let success = jsonData["success"] as? String else {
                    print("Error: PHP failure(success)")
                    return
                }
                if success == "YES" {
                    if let name = jsonData["name"] as? String {
                        DispatchQueue.main.async {
                            self.labelStatus.text = name + "님 안녕하세요?"
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.ID = self.loginID.text
                            appDelegate.userName = name
                            self.performSegue(withIdentifier: "toLoginSuccess", sender: self) }
                    }
                } else {
                    if let errMessage = jsonData["error"] as? String {
                        DispatchQueue.main.async {
                            self.labelStatus.text = errMessage }
                    }
                }
            } catch {
                print("Error: \(error)")
            }
        }
        task.resume()
    }
    
}

