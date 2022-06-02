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
        print("---builder.mode----> \(builder.mode!)")
        
        return builder
    }
    

    func generate() -> BDXWallet? {
        var wrapper: BeldexWalletWrapper?
        if let mode = self.mode {
            switch mode {
            case .fromScratch:
                print("--mode--> ")
                print("--mode--> \(mode)")
                wrapper = self.createWalletFromScratch()
            }
        }
        guard let result = wrapper else {
            print("----------resunt in wrapper---------")
            return nil
            
        }
        print("----result--0--> \(result)")
        return BDXWallet(walletWrapper: result)
    }
    
    // MARK: - Methods (private)

    func createWalletFromScratch() -> BeldexWalletWrapper? {
        print("-----pathWithFileNae-----> \(pathWithFileName())")
        print("-----password----> \(password)")
        print("----languate ----> \(language)")
        return BeldexWalletWrapper.generate(withPath: pathWithFileName(), password: password, language: language)
    }

    private func pathWithFileName() -> String {
        let allPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory = allPaths[0]
        let documentPath = documentDirectory + "/"
        let pathWithFileName = documentPath + self.name
        return pathWithFileName
    }
}

extension BDXWalletBuilder {
    private enum Mode {
        case fromScratch
    }
}
