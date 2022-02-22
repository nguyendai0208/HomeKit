//
//  VLHomeManager.swift
//  HomeKitExample
//
//  Created by Neo Nguyen on 22/02/2022.
//

import UIKit
import HomeKit
import RxSwift
import RxRelay

typealias AddHomeHandler = (HMHome?, Error?)->Void
typealias OnUpdateHomesHandler = ([HMHome])->Void
//typealias OnUpdateAccessoriesHandler = ([HMAccessory])->Void
typealias OnAddedAccessoryToRoomHandler = (HMHome?, HMAccessory, Error?)->Void

class VLHomeManager: NSObject {
    
    //Home
    private let homeManager = HMHomeManager()
    private var homes : [HMHome] = [HMHome]()
    
    //Accessories
    let browser = HMAccessoryBrowser()
    var discoveryAccessories : [HMAccessory] = []
    
    static let shared : VLHomeManager = VLHomeManager()
    
    //Handler
    public var onUpdateHomes : OnUpdateHomesHandler?
    public var onAddedAccessory : OnAddedAccessoryToRoomHandler?
//    public var onUpdateAccessories : OnUpdateAccessoriesHandler?
    
    override init() {
        super.init()
        if self.homeManager.delegate == nil {
            self.homeManager.delegate = self
            self.browser.delegate = self
        }
    }
}

//MARK: Home
extension VLHomeManager{
    func getHomes() -> [HMHome] {
        return self.homes
    }
    
    func addHome(with name : String, complete : @escaping AddHomeHandler) {
        self.homeManager.addHome(withName: name, completionHandler: complete)
    }
    
    func addAccesories(home : HMHome?, accessory : HMAccessory) {
        home?.addAccessory(accessory, completionHandler: { [weak self] err in
            guard let wSelf = self else { return }
            wSelf.onAddedAccessory?(home, accessory, err)
        })
    }
}

//MARK: Accessory
extension VLHomeManager : HMAccessoryBrowserDelegate, HMAccessoryDelegate{
    func searchAccessory() {
        self.discoveryAccessories.removeAll()
        browser.startSearchingForNewAccessories()
        self.perform(#selector(stopSearchAccessories), with: nil, afterDelay: 10)
    }
    
    @objc private func stopSearchAccessories(){
        print("stopSearchAccessories")
        self.browser.stopSearchingForNewAccessories()
    }
    
    func accessoryBrowser(_ browser: HMAccessoryBrowser, didFindNewAccessory accessory: HMAccessory) {
        print("accessoryBrowser : \(accessory.name)")
        self.discoveryAccessories.append(accessory)
        
        
//        accessory.delegate = self
    }
}

//MARK: HMHomeDelegate
extension VLHomeManager : HMHomeManagerDelegate{
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        // add home
        self.homes = manager.homes
        self.onUpdateHomes?(self.homes)
    }
}
