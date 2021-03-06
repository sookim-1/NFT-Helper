//
//  PersistenceMangager.swift
//  NFT-Helper
//
//  Created by sookim on 2022/04/04.
//

import Foundation

enum PersistenceActionType {
    case add, remove, edit
}

enum PersistenceManager {
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let addressList = "addressList"
        static let calendarList = "calendarList"
    }
    
    static func updateWith(addressModel: WalletAddress, actionType: PersistenceActionType, completed: @escaping (Error?) -> Void) {
        retrieveAddress { result in
            switch result {
            case .success(var value):
                
                switch actionType {
                case .add:
                    guard !value.contains(addressModel) else {
                        completed(.none)
                        return
                    }
                    
                    value.append(addressModel)
                case .remove:
                    value.removeAll { $0.address == addressModel.address }
                case .edit:
                    value.removeAll { $0.address == addressModel.address }
                    guard !value.contains(addressModel) else {
                        completed(.none)
                        return
                    }
                    
                    value.append(addressModel)
                }
                
                completed(save(addressList: value))
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    static func retrieveAddress(completed: @escaping (Result<[WalletAddress], Error>) -> Void) {
        guard let addressData = defaults.object(forKey: Keys.addressList) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let addressList = try decoder.decode([WalletAddress].self, from: addressData)
            completed(.success(addressList))
        } catch {
            completed(.failure(error))
        }
    }
    
    static func save(addressList: [WalletAddress]) -> Error? {
        do {
            let encoder = JSONEncoder()
            let encodedAddressList = try encoder.encode(addressList)
            defaults.set(encodedAddressList, forKey: Keys.addressList)
            return nil
        } catch {
            return error
        }
    }
}

extension PersistenceManager {
    static func updateWithCalendarItem(calendarItem: MintMetadata, actionType: PersistenceActionType, completed: @escaping (Error?) -> Void) {
        retrieveCalendarItem { result in
            switch result {
            case .success(var value):
                
                switch actionType {
                case .add:
                    guard !value.contains(calendarItem) else {
                        completed(.none)
                        return
                    }
                    
                    value.append(calendarItem)
                case .remove:
                    value.removeAll { $0.name == calendarItem.name }
                case .edit:
                    value.removeAll { $0.name == calendarItem.name }
                    guard !value.contains(calendarItem) else {
                        completed(.none)
                        return
                    }
                    value.append(calendarItem)
                }
                
                completed(saveCalendarItem(calendarList: value))
                
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    static func retrieveCalendarItem(completed: @escaping (Result<[MintMetadata], Error>) -> Void) {
        guard let itemData = defaults.object(forKey: Keys.calendarList) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let calendarList = try decoder.decode([MintMetadata].self, from: itemData)
            completed(.success(calendarList))
        } catch {
            completed(.failure(error))
        }
    }
    
    static func saveCalendarItem(calendarList: [MintMetadata]) -> Error? {
        do {
            let encoder = JSONEncoder()
            let encodedCalendarList = try encoder.encode(calendarList)
            defaults.set(encodedCalendarList, forKey: Keys.calendarList)
            return nil
        } catch {
            return error
        }
    }
}
