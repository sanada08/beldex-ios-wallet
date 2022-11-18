//
//  BDXWallet.swift
//
import UIKit
import Foundation

public enum BDXWalletError: Error {
    case noWalletName
    case noSeed
    
    case createFailed
    case openFailed
}


private func bdx_path(with name: String) -> String {
    let allPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentDirectory = allPaths[0]
    let documentPath = documentDirectory + "/"
    let pathWithFileName = documentPath + name
    print("### WALLET LOCATION: \(pathWithFileName)")
    return pathWithFileName
}



public class BDXWallet {
    
    // MARK: - Properties (public)
    
    public let walletName: String
    
    
    // MARK: - Properties (private)
    
    private let language: String
    private let walletWrapper: BeldexWalletWrapper
    private let safeQueue: DispatchQueue
    
    private var isClosing = false
    private var isSaving = false
    private var isClosed = false
    
    private var needSaveOnTerminate = false
    
    private var didEnterBackground: NSObjectProtocol?
    private var willTerminate: NSObjectProtocol?
    
    
    // MARK: - Life Cycles
    
    public init(walletWrapper: BeldexWalletWrapper) {
        self.language = "English"
        self.walletWrapper = walletWrapper
        self.walletName = walletWrapper.name
        self.safeQueue = DispatchQueuePool.shared["BDXWallet:" + walletName]
    }
    
    public func saveOnTerminate() {
        guard !needSaveOnTerminate else {
            return
        }
        needSaveOnTerminate = true
        let saveOnAppTerminateHandler = { [weak self] (notification: Notification) in
            guard let SELF = self else { return }
            SELF.save()
        }
        didEnterBackground = NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: nil, using: saveOnAppTerminateHandler)
        willTerminate = NotificationCenter.default.addObserver(forName: UIApplication.willTerminateNotification, object: nil, queue: nil, using: saveOnAppTerminateHandler)
    }

    public func connectToDaemon(address: String, refresh: @escaping BeldexWalletRefreshHandler, newBlock: @escaping BeldexWalletNewBlockHandler) -> Bool {
        return walletWrapper.connect(toDaemon: address, refresh: refresh, newBlock: newBlock)
    }
    
    public func connectToDaemon(address: String, delegate: BeldexWalletDelegate, result: @escaping (Bool) -> Void) {
        safeQueue.async {
            result(self.walletWrapper.connect(toDaemon: address, delegate: delegate))
        }
    }
    
    public func start() {
        walletWrapper.startRefresh()
    }
    
    public func save() {
        guard !isClosing || !isSaving else {
            return
        }
        self.isSaving = true
        safeQueue.async {
            self.walletWrapper.save()
            self.isSaving = false
        }
    }
    
}

extension BDXWallet {

    public var publicAddress: String {
        return walletWrapper.publicAddress
    }
    
    public var seed: Seed? {
        let sentence = walletWrapper.getSeedString(language)
        return Seed(sentence: sentence!)
    }
    public var publicViewKey: String {
        return walletWrapper.publicViewKey
    }
    public var publicSpendKey: String {
        return walletWrapper.publicSpendKey
    }
    public var secretViewKey: String {
        return walletWrapper.secretViewKey
    }
    public var secretSpendKey: String {
        return walletWrapper.secretSpendKey
    }
    public var balance: String {
        return displayAmount(walletWrapper.balance)
    }
    public var unlockedBalance: String {
        return displayAmount(walletWrapper.unlockedBalance)
    }
    public func getTransactionFee() -> String? {
        let fee = walletWrapper.transactionFee()
        if fee < 0 {
            return nil
        }
        return BeldexWalletWrapper.displayAmount(UInt64(fee))
    }
    public func displayAmount(_ value: UInt64) -> String {
        return BeldexWalletWrapper.displayAmount(value)
    }
    public var blockChainHeight: UInt64 {
        return walletWrapper.blockChainHeight
    }
    public var daemonBlockChainHeight: UInt64 {
        return walletWrapper.daemonBlockChainHeight
    }
    public var restoreHeight: UInt64 {
        get { return walletWrapper.restoreHeight }
        set {
            walletWrapper.restoreHeight = newValue
        }
    }
    
    public var history: TransactionHistory {
        return self.getUpdatedHistory()
    }
    private func getUpdatedHistory() -> TransactionHistory {
        let unorderedHistory = walletWrapper.fetchTransactionHistory().map({TransactionItem(model: $0)})
        // in reverse order: latest to oldest
        let list = unorderedHistory.sorted{ return $0.timestamp > $1.timestamp }
        return TransactionHistory(list)
    }
}
