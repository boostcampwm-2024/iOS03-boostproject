//
//  MPCBroswer.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/13/24.
//
import MultipeerConnectivity
import os

fileprivate let log = Logger()

final class MPCBrowser: NSObject {
    let browser: MCNearbyServiceBrowser
    let session: MCSession
    let myPeerId: MCPeerID

    static var sharedBrowser: MCNearbyServiceBrowser?

    @Published var paired: Bool = false
    @Published var availablePeers = [MCPeerID]()
    
    init(browser: MCNearbyServiceBrowser,
         session: MCSession,
         myPeerId: MCPeerID)
    {
        self.browser = browser
        self.session = session
        self.myPeerId = myPeerId
        
        super.init()
        browser.delegate = self
    }
    
    convenience init(session: MCSession, myPeerID: MCPeerID, serviceType: String) {
        if let existingBrowser = MPCBrowser.sharedBrowser {
            self.init(browser: existingBrowser, session: session, myPeerId: myPeerID)
        } else {
            let newBrowser = MCNearbyServiceBrowser(peer: myPeerID,
                                                    serviceType: serviceType)
            MPCBrowser.sharedBrowser = newBrowser
            self.init(browser: newBrowser, session: session, myPeerId: myPeerID)
        }
    }

    deinit {
        if MPCBrowser.sharedBrowser === browser {
            MPCBrowser.sharedBrowser = nil
            log.log("MPCBrowser deinit")
        }
    }

    func startBrowsing() {
        browser.startBrowsingForPeers()
        log.log("start Browsing")

    }
    
    func stopBrowsing() {
        browser.stopBrowsingForPeers()
        availablePeers.removeAll()
        log.log("stop Browsing")
    }
    
    func invite() {
        guard let peer = availablePeers.first else { return }
        browser.invitePeer(peer, to: session, withContext: nil, timeout: 10)
        log.info("invitePeer")
    }

    func invite(peerID: MCPeerID) {
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
        log.info("invitePeer peerID")
    }
    
    func invite(peerID: MCPeerID, tokenData: Data) {
        browser.invitePeer(peerID, to: session, withContext: tokenData, timeout: 10)
        log.info("invitePeer tokenData")
    }
}

extension MPCBrowser: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser,
                 foundPeer peerID: MCPeerID,
                 withDiscoveryInfo info: [String : String]?)
    {
        if let info = info {
            print("Found peer with info: \(info)")
        }
        
        // info에 해당되는 peer에 대해서만 availablepeers에 넣을 수 있다
        log.info("ServiceBrowser found peer: \(peerID)")
        guard !(self.availablePeers.contains(peerID)) else { return }
        self.availablePeers.append(peerID)

        if !session.connectedPeers.contains(peerID) {
            invite(peerID: peerID)
        }
        else {
            log.info("Peer is already connected : \(peerID)")
        }
    }
    
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        guard let index = availablePeers.firstIndex(of: peerID) else { return }
        self.availablePeers.remove(at: index)
    }
}
