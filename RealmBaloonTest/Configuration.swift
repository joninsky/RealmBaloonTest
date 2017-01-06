//
//  Configuration.swift
//  RealmBaloonTest
//
//  Created by Jon Vogel on 1/5/17.
//  Copyright © 2017 Jon Vogel. All rights reserved.
//

import Foundation
import RealmSwift
/// Class that represents a configuration that will help you interact with the Pebblebee cloud.
public class PBConfiguration {
    
    ///The default configuraiton that will be used to sign all Networking requests
    public static let defaultConfiguration: PBConfiguration? = PBConfiguration()
    
    /// Your Appliction ID as assigned to you by the Pebblebee Web God. Johnathan. Or that you set up on the Pebblebbe dashboard (If Johnathan has build that yet)
    public internal(set) var PBAppID: String?
    
    internal var pebblebeeRealm: Realm!
    
    let v: UInt64 = 0
    
    public var fileSizeOnInitalization: Double = 0.0
    
    private init?(){
        if let realmFileURL = self.configRealmFile() {
            let config = Realm.Configuration(fileURL: realmFileURL,
                                             readOnly: false,
                                             schemaVersion: self.v,
                                             migrationBlock: { migration, oldSchemaVersion in
                                                if (oldSchemaVersion < self.v) {
                                                    // Nothing to do!
                                                    // Realm will automatically detect new properties and removed properties
                                                    // And will update the schema on disk automatically
                                                }
                                            }//,
                                             //I put this in for testing
                                            //deleteRealmIfMigrationNeeded: true
            )
            
            do{
                self.pebblebeeRealm = try Realm(configuration: config)
                //Maybe call invalidate here?
                //self.pebblebeeRealm.invalidate()
            }catch{
                
                print("REALM ERROR!! Realm threw an Error on initalization: \(error)")
                return nil
            }
        }else{
            return nil
        }
        
        guard let sizeAtLunch = self.checkRealmFileSize().0 else{
            return
        }
        self.fileSizeOnInitalization = sizeAtLunch
    }
    
    /// Method to add your App ID as assigned by our Web God, Johnathan
    ///
    /// - Parameter id: String representing your app ID
    public func addAppID(_ id: String) {
        self.PBAppID = id
    }
    
    public func checkRealmFileSize() -> (Double?, Error?) {
        if let realmPath = self.pebblebeeRealm.configuration.fileURL?.relativePath {
            do {
                let attributes = try FileManager.default.attributesOfItem(atPath:realmPath)
                if let fileSize = attributes[FileAttributeKey.size] as? Double {
                    return (fileSize / 1000000000, nil)
                }else{
                    return (nil, nil)
                }
            }catch {
                return (nil, error)
            }
        }else{
            return (nil, nil)
        }
    }
    
    func configRealmFile() -> URL? {
        
        
        var documentsURL: URL!
        
        do {
            documentsURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        } catch {
            
            return nil
        }
        
        
        let realmFileURL = documentsURL.appendingPathComponent("myRealmOfControl.realm")
        
        
        if FileManager.default.fileExists(atPath: realmFileURL.path) {
            return realmFileURL
        }else if FileManager.default.createFile(atPath: realmFileURL.path, contents: nil, attributes: nil) {
            return realmFileURL
        }else{
            return nil
        }
    }
}
