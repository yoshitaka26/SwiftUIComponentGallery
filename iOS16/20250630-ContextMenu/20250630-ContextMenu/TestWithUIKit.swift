import SwiftUI
import UIKit

// ContextMenuの上に永続的にコンテンツを表示するカスタムビュー
struct PersistentOverlayContextMenuView: UIViewRepresentable {
    @Binding var showingOverlay: Bool
    @Binding var overlayContent: String
    
    func makeUIView(context: Context) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
        
        // メインコンテンツ
        let mainLabel = UILabel()
        mainLabel.text = "長押ししてください"
        mainLabel.textAlignment = .center
        containerView.addSubview(mainLabel)
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // オーバーレイビュー（最初は非表示）
        let overlayView = UIView()
        overlayView.backgroundColor = UIColor.systemBackground
        overlayView.layer.cornerRadius = 12
        overlayView.layer.shadowColor = UIColor.black.cgColor
        overlayView.layer.shadowOffset = CGSize(width: 0, height: 4)
        overlayView.layer.shadowRadius = 12
        overlayView.layer.shadowOpacity = 0.3
        overlayView.isHidden = true
        containerView.addSubview(overlayView)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        
        // オーバーレイ内のコンテンツ
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        
        let titleLabel = UILabel()
        titleLabel.text = "オーバーレイコンテンツ"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = UIColor.label
        
        let contentLabel = UILabel()
        contentLabel.text = overlayContent
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        contentLabel.textColor = UIColor.secondaryLabel
        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = .center
        
        // インタラクティブなボタン
        let button1 = UIButton(type: .system)
        button1.setTitle("ボタン1", for: .normal)
        button1.backgroundColor = UIColor.systemBlue
        button1.setTitleColor(UIColor.white, for: .normal)
        button1.layer.cornerRadius = 8
        button1.addTarget(context.coordinator, action: #selector(Coordinator.button1Tapped), for: .touchUpInside)
        
        let button2 = UIButton(type: .system)
        button2.setTitle("ボタン2", for: .normal)
        button2.backgroundColor = UIColor.systemGreen
        button2.setTitleColor(UIColor.white, for: .normal)
        button2.layer.cornerRadius = 8
        button2.addTarget(context.coordinator, action: #selector(Coordinator.button2Tapped), for: .touchUpInside)
        
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("閉じる", for: .normal)
        closeButton.backgroundColor = UIColor.systemRed
        closeButton.setTitleColor(UIColor.white, for: .normal)
        closeButton.layer.cornerRadius = 8
        closeButton.addTarget(context.coordinator, action: #selector(Coordinator.closeTapped), for: .touchUpInside)
        
        let buttonStack = UIStackView(arrangedSubviews: [button1, button2, closeButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 8
        buttonStack.distribution = .fillEqually
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(contentLabel)
        stackView.addArrangedSubview(buttonStack)
        
        overlayView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // 制約設定
        NSLayoutConstraint.activate([
            mainLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            mainLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            overlayView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            overlayView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            overlayView.widthAnchor.constraint(equalToConstant: 280),
            overlayView.heightAnchor.constraint(equalToConstant: 200),
            
            stackView.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -16),
            
            button1.heightAnchor.constraint(equalToConstant: 36),
            button2.heightAnchor.constraint(equalToConstant: 36),
            closeButton.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        // 長押しジェスチャーを追加
        let longPressGesture = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 0.5
        containerView.addGestureRecognizer(longPressGesture)
        
        // ContextMenuインタラクションを追加
        let contextMenuInteraction = UIContextMenuInteraction(delegate: context.coordinator)
        containerView.addInteraction(contextMenuInteraction)
        
        // Coordinatorに参照を保存
        context.coordinator.containerView = containerView
        context.coordinator.overlayView = overlayView
        context.coordinator.contentLabel = contentLabel
        
        return containerView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // オーバーレイコンテンツの更新
        context.coordinator.contentLabel?.text = overlayContent
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIContextMenuInteractionDelegate {
        let parent: PersistentOverlayContextMenuView
        weak var containerView: UIView?
        weak var overlayView: UIView?
        weak var contentLabel: UILabel?
        
        init(_ parent: PersistentOverlayContextMenuView) {
            self.parent = parent
        }
        
        @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
            switch gesture.state {
            case .began:
                showOverlay()
            case .ended, .cancelled:
                // 長押し終了時は何もしない（ユーザーが手動で閉じるまで表示し続ける）
                break
            default:
                break
            }
        }
        
        @objc func button1Tapped() {
            parent.overlayContent = "ボタン1がタップされました: \(Date().formatted(date: .omitted, time: .shortened))"
        }
        
        @objc func button2Tapped() {
            parent.overlayContent = "ボタン2がタップされました: \(Date().formatted(date: .omitted, time: .shortened))"
        }
        
        @objc func closeTapped() {
            hideOverlay()
        }
        
        private func showOverlay() {
            parent.showingOverlay = true
            overlayView?.isHidden = false
            
            // アニメーション付きで表示
            overlayView?.alpha = 0
            overlayView?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
                self.overlayView?.alpha = 1
                self.overlayView?.transform = .identity
            })
        }
        
        private func hideOverlay() {
            parent.showingOverlay = false
            
            UIView.animate(withDuration: 0.2, animations: {
                self.overlayView?.alpha = 0
                self.overlayView?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }) { _ in
                self.overlayView?.isHidden = true
            }
        }
        
        // ContextMenuの設定（オーバーレイ表示中は無効化）
        func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
            // オーバーレイが表示されている場合はContextMenuを無効化
            if parent.showingOverlay {
                return nil
            }
            
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
                let action1 = UIAction(title: "アクション1", image: UIImage(systemName: "star.fill")) { _ in
                    self.parent.overlayContent = "ContextMenuアクション1実行"
                }
                let action2 = UIAction(title: "アクション2", image: UIImage(systemName: "heart.fill")) { _ in
                    self.parent.overlayContent = "ContextMenuアクション2実行"
                }
                return UIMenu(children: [action1, action2])
            }
        }
    }
}

// 使用例
struct TestWithUIKit: View {
    @State private var showingOverlay = false
    @State private var overlayContent = "初期コンテンツ"
    
    var body: some View {
        VStack(spacing: 30) {
            Text("永続的オーバーレイ ContextMenu デモ")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(spacing: 20) {
                Text("長押しでオーバーレイ表示")
                    .font(.headline)
                
                PersistentOverlayContextMenuView(
                    showingOverlay: $showingOverlay,
                    overlayContent: $overlayContent
                )
                .frame(width: 200, height: 100)
                
                Text("現在のコンテンツ: \(overlayContent)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            if showingOverlay {
                Text("オーバーレイ表示中")
                    .font(.caption)
                    .foregroundColor(.green)
            }
        }
        .padding()
    }
}

#Preview {
    TestWithUIKit()
}
