//
//  NextViewController.swift
//  OpenCV02
//
//  Created by RUI KONDO on 2021/07/14.
//

import UIKit
import SQLite3
import AVFoundation

class NextViewController: UIViewController {
    @IBOutlet weak var back01: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("次のページが読み込まれました")
        print(opencv002.testInt())
        opencv002.testMethod()
        
        
        /* 動画 */
        let path = Bundle.main.path(forResource: "sample01", ofType: "mp4")!
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        player.play()

        // AVPlayer用のLayerを生成
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.zPosition = -1 // ボタン等よりも後ろに表示
        view.layer.insertSublayer(playerLayer, at: 0) // 動画をレイヤーとして追加
        /* /動画 */
        
    }
    


    @IBAction func back01_click(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        print("元のページに戻ります")
    }
    
}
