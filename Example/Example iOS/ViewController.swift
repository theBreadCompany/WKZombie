//
//  ViewController.swift
//  Yontle
//
//  Created by woohyun on 02/01/2020.
//  Copyright © 2020 woohyun. All rights reserved.
//

import UIKit
import WKZombieRevised

class ViewController: UIViewController {
    @IBOutlet weak var snapshotImageView: UIImageView!
    var snapshots = [Snapshot]()
    var url = URL(string: "https://ysweb.yonsei.ac.kr/ysbus.jsp")!
    var url2 = URL(string: "https://ysweb.yonsei.ac.kr/busTest/index2.jsp")!
    var browser = WKZombie(name: "Demo")
    var start, end : DispatchTime!
    override func viewDidLoad() {
        super.viewDidLoad()
        WKZombie.sharedInstance.snapshotHandler = { [weak self] snapshot in
            self?.snapshotImageView.image = snapshot.image
        }
        browser.snapshotHandler = { [weak self] snapshot in
            self?.snapshotImageView.image = snapshot.image
        }
        
        browser = WKZombie.sharedInstance
        
        start = DispatchTime.now()
        browser.open(url)
        >>* browser.get(by: .id("id"))
        >>> browser.setAttribute("value", value: "2014198024")
        >>* browser.get(by: .id("password"))
        >>> browser.setAttribute("value", value: "e34e43E34!")
        >>* browser.get(by: .name("frmLogin"))
        >>* browser.submit(then: .validate("$(a[href='index2.jsp'] !== null"))
        >>* browser.get(by: .attribute("href", "index2.jsp"))
        >>* browser.click
        >>* browser.execute("""
        $(".bus_reservation").val("20200107").trigger('change')
            true
        """, then: .wait(1))

        >>* browser.execute("""
            $(".layout.display > tbody > tr:nth-child(1) > td:nth-child(5) > select").val("1").trigger('change')
            $(".layout.display > tbody > tr:nth-child(1) > td:nth-child(6) > a").click()
            true
        """)
        >>* browser.inspect
        >>* browser.get(by: .class("layout display"))
        === myOutput
        
//        open(url)
//            >>* get(by: .id("id"))
//            >>> setAttribute("value", value: "2014198024")
//            >>* get(by: .id("password"))
//            >>> setAttribute("value", value: "e34e43E34!")
//            >>* get(by: .name("frmLogin"))
//            >>* submit(then: .validate("$(a[href='index2.jsp'] !== null"))
//            >>* get(by: .attribute("href", "index2.jsp"))
//            >>* click
//            >>* execute("""
//            $(".bus_reservation").val("20200107").trigger('change')
//                true
//            """, then: .wait(1))
//
//            >>* execute("""
//                $(".layout.display > tbody > tr:nth-child(1) > td:nth-child(5) > select").val("1").trigger('change')
//                $(".layout.display > tbody > tr:nth-child(1) > td:nth-child(6) > a").click()
//                true
//            """)
//            >>* inspect
//            >>* get(by: .class("layout display"))
//            === myOutput
        
        
    }
    
    func myOutput(result: Result<HTMLElement>?) {
        end = DispatchTime.now()
        switch result {
        case .success(let element):
            debugPrint(element.innerContent)
        default:
            return
        }
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
        let timeInterval = Double(nanoTime) / 1_000_000_000
        debugPrint(timeInterval)
    }
    
}
