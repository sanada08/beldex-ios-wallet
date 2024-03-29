//
//  BeldexWalletBuilder.swift
//

import Foundation

public struct BDXWalletBuilder {
    
    // MARK: - Properties (private)
    
    private var language: String
    private var name: String
    private var password: String
    private var mode: Mode?
    
    
    // MARK: - Life Cycles
    
    init(name: String, password: String) {
        self.language = "English"
        self.name = name
        self.password = password
    }
    
    public func fromScratch() -> BDXWalletBuilder {
        var builder = self
        builder.mode = .fromScratch
        return builder
    }
    
    public func fromSeed(_ seed: Seed) -> BDXWalletBuilder {
        var builder = self
        builder.mode = .fromSeed(seed: seed)
       // print("builder.mode ----> \(seed)")
        return builder
    }
    
    public func fromKeys(_ keys: Keys) -> BDXWalletBuilder {
        var builder = self
        builder.mode = .fromKeys(keys: keys)
        return builder
    }
    
    public func isValidatePassword() -> Bool {
        return BeldexWalletWrapper.verifyPassword(password, path: pathWithFileName() + ".keys")
    }

    func generate() -> BDXWallet? {
        var wrapper: BeldexWalletWrapper?
        if let mode = self.mode {
            switch mode {
            case .openExisting:
                wrapper = self.openExistingWallet()
            case .fromScratch:
                wrapper = self.createWalletFromScratch()
            case .fromSeed(let seed):
                wrapper = self.recoverWalletFromSeed(seed)
            case .fromKeys(let keys):
                wrapper = self.recoverWalletFromKeys(keys: keys)
            }
        }
        guard let result = wrapper else { return nil }
        return BDXWallet(walletWrapper: result)
    }
    
    // MARK: - Methods (private)

    func createWalletFromScratch() -> BeldexWalletWrapper? {
        return BeldexWalletWrapper.generate(withPath: pathWithFileName(), password: password, language: language)
    }
    private func recoverWalletFromSeed(_ seed: Seed) -> BeldexWalletWrapper? {
        return BeldexWalletWrapper.recover(withSeed: seed.sentence, path: pathWithFileName(), password: password)
    }
    
    private func recoverWalletFromKeys(keys:Keys) -> BeldexWalletWrapper? {
        return BeldexWalletWrapper.recoverFromKeys(withPath: pathWithFileName(), password: password, language: language, restoreHeight: keys.restoreHeight, address: keys.addressString, viewKey: keys.viewKeyString, spendKey: keys.spendKeyString)
    }

    private func pathWithFileName() -> String {
        let allPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory = allPaths[0]
        let documentPath = documentDirectory + "/"
        let pathWithFileName = documentPath + self.name
        print("pathWithFileName-->", pathWithFileName)
        return pathWithFileName
    }
    
    public func openExisting() -> BDXWallet? {
        if let result = openExistingWallet() {
            return BDXWallet(walletWrapper: result)
        }
        return nil
    }
    
    
    private func openExistingWallet() -> BeldexWalletWrapper? {
        return BeldexWalletWrapper.openExisting(withPath: pathWithFileName(), password: password)
    }
}

extension BDXWalletBuilder {
    private enum Mode {
        case fromScratch
        case fromSeed(seed: Seed)
        case fromKeys(keys: Keys)
        case openExisting
    }
}
