//
//  RankingView.swift
//  운기조식
//
//  Created by Austin's Macbook Pro M3 on 8/25/24.
//

import SwiftUI
import GameKit

enum RankingError {
    case noValue
    case failToFetch
    case failToPost
}

@MainActor
final class RankingViewObservable: NSObject, GKGameCenterControllerDelegate, ObservableObject {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    @Published var score: Int = 0
    @Published var isLoading: Bool = false
    @Published var currentError: RankingError?
    @Published var authViewController: UIViewController?
    @Published var leaderboard: GKLeaderboard?
    @Published var ranking = [GKEntity]()
    @Published var rankingImage: UIImage?
    
    override init() {
        super.init()
        getRanking()
        getAuthView()
    }
    
    func postNewRanking(_ newScore: Int) {
        
        GKLeaderboard.submitScore(newScore, context: 0, player: GKLocalPlayer.local, leaderboardIDs: ["leaderboard_100Rankers"]) { [weak self] error in
            guard let error else {
                print("post error \(error?.localizedDescription ?? "")")
                self?.currentError = .failToPost
                return
            }
            print("success to write")
            self?.getRanking()
        }
    }
    
    func getAuthView() {
        if GKLocalPlayer.local.isAuthenticated {
            print("logIn already")
        } else {
            GKLocalPlayer.local.authenticateHandler = { [weak self] viewController, error in
                self?.authViewController = viewController
                if GKLocalPlayer.local.isAuthenticated {
                    print("logIn")
                } else {
                    print("logout")
                }
            }
        }
    }
    
    func getRanking() {
        Task {
            do {
                leaderboard = try await GKLeaderboard.loadLeaderboards(IDs: ["leaderboard_100Rankers"]).first
                rankingImage = try await leaderboard?.loadImage()
            } catch {
                currentError = .failToFetch
            }
        }
    }
}

extension RankingViewObservable {
    func showLeaderboard() {
        let leaderboardID = "leaderboard_100Rankers"
        let viewController = GKGameCenterViewController(leaderboardID: leaderboardID, playerScope: .friendsOnly, timeScope: .allTime)
        viewController.gameCenterDelegate = self
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                window.rootViewController?.present(viewController, animated: true, completion: nil)
            }
        }
    }
}

struct RankingView: View {
    @StateObject private var observable = RankingViewObservable()
    
    var body: some View {
        ZStack {
            DefaultBackgroundAnimationView()
            VStack(spacing: 30) {
                Text("끝없는 비움은\n무한한 가능성으로\n가득 차 있다.")
                    .font(.customTitle3)
                Text("노자")
                    .font(.customCaption)
                Text("세계 10대 고수 & 경지 기능 준비 중")
                    .font(.customCaption)
                    .padding(.top, 30)
            }
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .lineSpacing(6.0)
//            VStack {
//                if let uiImage = observable.rankingImage {
//                    Image(uiImage: uiImage)
//                }
//                Button {
//                    observable.score += 1
//                    observable.postNewRanking(observable.score)
//                } label: {
//                    Text("post new rank")
//                }
//                Button {
//                    observable.showLeaderboard()
//                } label: {
//                    Text("get ranking")
//                }
//            }
        }
    }
}

#Preview {
    RankingView()
}
