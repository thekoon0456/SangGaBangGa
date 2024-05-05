//
//  NetworkMonitorManager.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 5/5/24.
//

import Foundation
import Network

import RxSwift

final class NetworkMonitorManager {
    
    static let shared = NetworkMonitorManager()
    private let monitor: NWPathMonitor = NWPathMonitor()
    private let statusSubject = BehaviorSubject<NWPath.Status?>(value: nil)
    private var lastStatus: NWPath.Status?
    
    var statusObservable: Observable<NWPath.Status> {
        return statusSubject.asObservable().compactMap { $0 }
    }
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            if let lastStatus = self.lastStatus, lastStatus != path.status {
                statusSubject.onNext(path.status)
            }
            lastStatus = path.status
        }
        let queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel()
    }
}
