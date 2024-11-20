//
//  NIManager.swift
//  SniffMeet
//
//  Created by 배현진 on 11/14/24.
//

import Combine
import MultipeerConnectivity
import NearbyInteraction

class NIManager: NSObject {
    private var niSession: NISession?
    private var mpcManager: MPCManager
    private var cancellables = Set<AnyCancellable>()

    private let minDistance: Float = 0.09
    private let maxDistance: Float = 0.15
    private let minDirection: simd_float3 = simd_float3(-0.6, -0.3, -1.0)
    private let maxDirection: simd_float3 = simd_float3(0.6, 0.3, -0.8)

    init(mpcManager: MPCManager) {
        self.mpcManager = mpcManager
        super.init()

        setupNISession()
        setupBindings()
    }

    private func setupNISession() {
        niSession = NISession()
        niSession?.delegate = self
    }

    private func setupBindings() {
        // MPC 연결 완료 시 discoveryToken을 주고받기
        mpcManager.$paired
            .receive(on: RunLoop.main)
            .sink { [weak self] isPaired in
                if isPaired {
                    self?.sendDiscoveryToken()
                }
            }
            .store(in: &cancellables)

        // MPC로 discoveryToken 수신 시 NI 세션 업데이트
        mpcManager.receivedTokenPublisher
            .sink { [weak self] token in
                self?.handleReceivedDiscoveryToken(token)
            }
            .store(in: &cancellables)
    }

    // discoveryToken 전송
    private func sendDiscoveryToken() {
        guard let niSession = niSession, let discoveryToken = niSession.discoveryToken else {
            print("Discovery token is not available.")
            return
        }

        do {
            let tokenData = try NSKeyedArchiver.archivedData(
                withRootObject: discoveryToken,
                requiringSecureCoding: true
            )
            mpcManager.send(mateData: tokenData)
            print("Discovery token sent to peer.")
        } catch {
            print("Failed to encode discovery token: \(error)")
        }
    }

    // discoveryToken 수신 처리
    private func handleReceivedDiscoveryToken(_ data: Data) {
        do {
            guard let token = try NSKeyedUnarchiver.unarchivedObject(
                ofClass: NIDiscoveryToken.self,
                from: data
            ) else {
                print("Invalid discovery token received.")
                return
            }

            let config = NINearbyPeerConfiguration(peerToken: token)
            niSession?.run(config)
            print("NearbyInteraction session started with received discovery token.")
        } catch {
            print("Failed to decode discovery token: \(error)")
        }
    }

    func isDirectionInRange(direction: simd_float3,
                            minDirection: simd_float3,
                            maxDirection: simd_float3) -> Bool {
        return (minDirection.x...maxDirection.x).contains(direction.x) &&
               (minDirection.y...maxDirection.y).contains(direction.y) &&
               (minDirection.z...maxDirection.z).contains(direction.z)
    }
}

// MARK: - NISessionDelegate
extension NIManager: NISessionDelegate {
    func session(_ session: NISession, didUpdate nearbyObjects: [NINearbyObject]) {
        guard let nearbyObject = nearbyObjects.first else { return }
        let distance = nearbyObject.distance ?? 0
        let direction = nearbyObject.direction ?? simd_float3(0.0, 0.0, 0.0)

        print("Distance and Direction to peer: \(distance) and \(direction)")

        if distance > minDistance && distance < maxDistance && isDirectionInRange(direction: direction,
                                                                                  minDirection: minDirection,
                                                                                  maxDirection: maxDirection) {
            print("거리와 방향 조건 만족")
        }
    }

    func sessionWasSuspended(_ session: NISession) {
        print("NearbyInteraction session suspended.")
    }

    func sessionSuspensionEnded(_ session: NISession) {
        print("NearbyInteraction session suspension ended.")
    }

    func session(_ session: NISession, didInvalidateWith error: Error) {
        print("NearbyInteraction session invalidated: \(error)")
    }
}
