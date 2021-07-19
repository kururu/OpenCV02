//
//  ViewController.swift
//  OpenCV02
//
//  Created by RUI KONDO on 2021/07/12.
//

import UIKit
import SQLite3



class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var button01: UIButton!
    
    @IBOutlet weak var button_access: UIButton!
    var db: OpaquePointer?
    var dbfile: String = "sample.db"
    
    var webServer:GCDWebServer!

    override func viewDidLoad() {
        super.viewDidLoad()

        /* ナビゲーションを隠す */
        navigationController?.setNavigationBarHidden(true, animated: true)
        print("画面01が読み込まれました")
        
        /* JSONを読み込み */
        struct TenkiJSON: Codable {
            let publishingOffice: String
            let reportDatetime: String
            let targetArea: String
            let headlineText: String
            let text: String
        }
        
        let jsonUrlString = "https://www.jma.go.jp/bosai/forecast/data/overview_forecast/130000.json"
        guard let url = URL(string: jsonUrlString) else {return}
        //
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {return}
            //
            do{
                let tenki = try JSONDecoder().decode(TenkiJSON.self, from: data)
                
                print(tenki.publishingOffice);
                print(tenki.targetArea);
                print(tenki.reportDatetime);
                print(tenki.headlineText);
                print(tenki.text);
                
            } catch {
                print("JSONDecoder error: \(error.localizedDescription)")
                print("JSONデータを読み込めません")
            }
        }.resume()
        
        struct gitUsers: Codable {
            let login: String
            let html_url: String
            let type: String
        }
        
        let jsonUrlString2 = "https://api.github.com/users"
        guard let url2 = URL(string: jsonUrlString2) else {return}
        URLSession.shared.dataTask(with: url2) { (data, response, error) in
            guard let data = data else {return}
            //
            do{
                let git_users = try JSONDecoder().decode([gitUsers].self, from: data)
                for git_user in git_users {
                    print(git_user.login)
                    print(git_user.html_url)
                    print(git_user.type)
                }
                
            } catch {
                print("JSONDecoder error: \(error.localizedDescription)")
                print("JSONデータを読み込めません")
            }
        }.resume()
        /* /JSONを読み込み */
        
        label.text = "Hello world!"
        
        let image = UIImage(named: "gazou")!
        imageView.image = image;
        imageView.image = opencv002.grayScale(image);
        
        opencv002.testMethod();
        label.text = String(label.text!) + String(opencv002.testInt());
        
        /* UUID */
        let idfv = UIDevice.current.identifierForVendor?.uuidString
        print("IDFV:\(idfv!)")
        /* /UUID */
        
        /* WebServer */
        if webServer != nil {
            print("webserver already started")
            return
        }
        webServer = GCDWebServer()
        
        if webServer.start(withPort: 8080, bonjourName: "GCD Web Server") {
            print("GCDWebServer running locally on port \(webServer.port)")
        } else {
            print("GCDWebServer not running!")
        }
        /* /WebServer */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("画面01が表示されました")
    }
    
    @IBAction func click01(_ sender: Any) {
        print("次のページへ移動します")
        let storyboard: UIStoryboard = self.storyboard!
        let next = storyboard.instantiateViewController(withIdentifier: "pageNext")
        navigationController?.pushViewController(next, animated: true)
    }
    

    @IBAction func access01(_ sender: Any) {
        db_access01()
        post01(url: "http://192.168.11.22/PHPsample/post01.php")

        
    }
    
    func post01(url: String){
        /* POST */
        let urlString = url

        let request = NSMutableURLRequest(url: URL(string: urlString)!)

        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")



        let params:[String:Any] = [
            "foo": "bar",
            "baz":[
                "a": 1,
                "b": 2,
                "x": 3]
        ]

        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)

            let task:URLSessionDataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data,response,error) -> Void in
                let resultData = String(data: data!, encoding: .utf8)!
                print("result:\(resultData)")
                print("response:\(String(describing: response))")

            })
            task.resume()
        }catch{
            print("Error:\(error)")
            return
        }
        /* /POST */
    }
    
    func db_access01(){
        
        
        /* DB */
        print("これはDBです")
        let dt : Date = Date()
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        formatter.locale = Locale(identifier: "ja_JP")
        let datetime = formatter.string(from: dt)
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(self.dbfile)
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error: database file open error.")
        }

        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS foobar (id INTEGER PRIMARY KEY AUTOINCREMENT, text01 TEXT)", nil, nil, nil) != SQLITE_OK {
            print("Error: SQL execution error.")
        }
        
        if sqlite3_exec(db, "SELECT COUNT(*) FROM sample WHERE TYPE='table' AND name='foobar'", nil, nil, nil) > 0 {
            print("foobarテーブルが存在します")
            if sqlite3_exec(db, "INSERT INTO foobar(text01) VALUES (" + datetime + ")", nil, nil, nil) == SQLITE_OK {
                print("foobarテーブルに書き込みました")
            }
        }
        
        /* /DB */
    }
    
    
}
