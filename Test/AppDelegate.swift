//
//  AppDelegate.swift
//  Test
//
//  Created by Pavel Sharanda on 29.03.17.
//  Copyright © 2017 AnyCoder. All rights reserved.
//

import UIKit
import AnyCoder

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    private lazy var data:Data = {
        let path = Bundle(for: type(of: self)).url(forResource: "Large", withExtension: "json")
        let data = try! Data(contentsOf: path!)
        return data
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let dict = try! JSONSerialization.jsonObject(with: self.data, options: []) as! [String: Any]
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            _ = try! dict.decoder(forKey: "ProgramList").decode(key: "Programs") as [Program]
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


public struct Recording {
    enum Status: String, AnyDecodable {
        case None = "0"
        case Recorded = "-3"
        case Recording = "-2"
        case Unknown
    }
    
    enum RecGroup: String, AnyDecodable {
        case Deleted = "Deleted"
        case Default = "Default"
        case LiveTV = "LiveTV"
        case Unknown
    }
    
    let startTsStr:String
    let status:Status
    let recordId:String
    let recGroup:RecGroup
}

public struct Program {
    
    let title:String
    let chanId:String
    let description:String?
    let subtitle:String?
    let recording:Recording
    let season:String?
    let episode:String?
}

extension Recording: Decodable {
    
    public init?(decoder: Decoder) throws {
        startTsStr = try decoder.decode(key: "StartTs")
        recordId = try decoder.decode(key: "RecordId")
        status = (try? decoder.decode(key: "Status")) ?? .Unknown
        recGroup = (try? decoder.decode(key: "RecGroup")) ?? .Unknown
    }
}

extension Program: Decodable {
    
    public init?(decoder: Decoder) throws {
        title = try decoder.decode(key: "Title")
        chanId = try decoder.decoder(forKey: "Channel").decode(key: "ChanId")
        description = try decoder.decode(key: "Description", nilIfMissing: true)
        subtitle = try decoder.decode(key: "SubTitle", nilIfMissing: true)
        recording = try decoder.decode(key: "Recording")
        season = try decoder.decode(key: "Season", nilIfMissing: true)
        episode = try decoder.decode(key: "Episode", nilIfMissing: true)
        
    }
}

