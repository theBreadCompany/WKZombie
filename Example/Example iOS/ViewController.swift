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
        //            >>* browser.get(by: .attribute("href", "index2.jsp"))
        //            >>* browser.click
        //            >>* browser.execute("""
        //        $(".bus_reservation").val("20200107").trigger('change')
        //            true
        //        """, then: .wait(1))
        //
        //            >>* browser.execute("""
        //            $(".layout.display > tbody > tr:nth-child(1) > td:nth-child(5) > select").val("1").trigger('change')
        //            $(".layout.display > tbody > tr:nth-child(1) > td:nth-child(6) > a").click()
        //            true
        //        """)
        //            >>* browser.inspect
        //            >>* browser.get(by: .class("layout display"))
        //            === myOutput
        
        
    }
    @IBAction func onLogin(_ sender: Any) {
        let start = DispatchTime.now()
        login(id: "2014198024", pw: "e34e43E34!"){ result in
            self.getDuration("LOGIN", start: start)
            switch result {
            case .success(let htmlPage):
                debugPrint(htmlPage)
                return
            case .error(let error):
                debugPrint("error: ", error)
                return
            default:
                return
            }
        }
    }
    @IBAction func onDateSelect(_ sender: Any) {
        selectPath{ resu in
            let start = DispatchTime.now()
            self.selectDate{ result in
                self.getDuration("DATE SELECT", start: start)
                switch result {
                case .success(let htmlPage):
                    debugPrint(htmlPage)
                    return
                case .error(let error):
                    debugPrint(error)
                    return
                default:
                    return
                }
            }
        }
    }
    @IBAction func onReservation(_ sender: Any) {
        getBusList()
    }
    
    func login(id: String, pw: String, _ endCB: @escaping (_ result: Result<JavaScriptResult>?) -> Void){
        browser.open(url)
            >>* browser.execute("""
                document.getElementById("id").value = "\(id)";
                document.getElementById("password").value = "\(pw)";
                document.frmLogin.submit();
                true
                """, then: .wait(1))
            >>> browser.inspect
            >>> browser.execute("document.title")
            === endCB
    }
    func selectDate(_ endCB: @escaping (_ result: Result<JavaScript>?) -> Void){
        browser.inspect
            >>* browser.execute("""
                       $(".bus_reservation").val("20200107").trigger('change')
                           true
                       """, then: .wait(1))
            === endCB
    }
    func selectPath(_ endCB: @escaping (_ result: Result<JavaScript>?) -> Void){
        browser.inspect
            >>* browser.get(by: .attribute("href", "index2.jsp"))
            >>* browser.click
            >>* browser.execute("""
                       $('#MYFORM_LOCATION').val('I');
                        doAction('S');
                        true
                       """, then: .wait(1))
            === endCB
    }
    func getBusList(){
        browser.inspect
            >>> browser.get(by: .XPathQuery("//*[@id=\"pageid\"]/div/div[2]/table"))
            === { (result : Result<HTMLTable>?) -> Void in
                switch result {
                case .success(let table):
                    for var i in table.rows!{
                        if i.columns?.count != 0 {
                            debugPrint(i.columns?.first?.text)
                        }
                    }
                default:
                    return
                }
                
        }
    }
    
    func myOutput(result: Result<HTMLElement>?) {
        end = DispatchTime.now()
        switch result {
        case .success(let element):
            debugPrint(element.innerContent)
        default:
            return
        }
    }
    
    func getDuration(_ title: String, start: DispatchTime){
        let nanoTime = DispatchTime.now().uptimeNanoseconds - start.uptimeNanoseconds
        let timeInterval = Double(nanoTime) / 1_000_000_000
        debugPrint("\(title) ::: \(timeInterval)")
    }
}

