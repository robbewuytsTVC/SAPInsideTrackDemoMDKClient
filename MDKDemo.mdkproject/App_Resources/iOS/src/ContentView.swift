import SwiftUI
import Combine

struct ContentView: View {
    @State private var ballPosition: CGPoint = CGPoint(x: 50, y: 50)
    @State private var paddlePosition: CGFloat = 200
    @State private var dx: CGFloat = 5.0
    @State private var dy: CGFloat = 5.0
    @State private var score: Int = 0
    @State private var timer: Timer.TimerPublisher = Timer.publish(every: 0.02, on: .main, in: .common)
    @State private var cancellable: Cancellable?
    @State private var gameOver = false
    @State private var level: Int = 1
    @State private var opacity: Double = 1.0
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(red: 139 / 255, green: 172 / 255, blue: 15 / 255))
               
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Text("SAP Inside Track goes 8bit")
                          .font(.custom("Early GameBoy", size: 22))
                          .multilineTextAlignment(.center)
                          .foregroundColor(Color.black)
                          .offset(y: -300)

            Rectangle()
                .fill(Color.black)
                .frame(width: 30, height: 30)
                .position(ballPosition)
                .overlay( 
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.black, lineWidth: 5)
                )
            
            
            Rectangle()
                .fill(Color.black)
                .frame(width: 100, height: 10)
                .position(x: paddlePosition, y: 750)
            
            Text("Score: \(score)")
                .foregroundColor(.black)
                .font(.custom("Early GameBoy", size: 20))
                .position(x: 90, y: 170)

            
            if gameOver {
                Text("GAME OVER!")
                    .font(.custom("Early GameBoy", size: 35))
                    .foregroundColor(Color.black)
                
                Text("©2023 TheValueChain")
                    .foregroundColor(.black)
                    .font(.custom("Early GameBoy", size: 16))
                    .position(x: 200, y: 700)
                
                Text("Press start to play again!")
                    .font(.custom("Early GameBoy", size: 15))
                    .foregroundColor(Color.black)
                    .position(x: 200, y: 500)
                    .opacity(opacity)
                    .onAppear {
                        startBlinking()
                    }
                
                Button(action: {
                    restartGame()
                }) {
                    Text("START")
                        .font(.custom("Early GameBoy", size: 20))
                        .foregroundColor(.black)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                }
                .background(Color.white)
                .cornerRadius(5)
                .position(x: 200, y: 600)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.black, lineWidth: 2)
                )
               
                                
                
            }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    paddlePosition = value.location.x
                }
        )
        .onAppear {
            startGame()
        }
    }
    
    func startGame() {
        cancellable = timer.autoconnect().sink { _ in
            update()
        }
    }
    
    func startBlinking() {
            withAnimation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                opacity = 0.0
            }
            
//            // Stop blinking after 3 seconds
//            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                self.opacity = 1.0
//            }
        }
    
    func restartGame() {
            // Reset game state variables
            ballPosition = CGPoint(x: 50, y: 50)
            paddlePosition = 200
            dx = 5.0
            dy = 5.0
            score = 0
            level = 1
            gameOver = false
        opacity = 1
            
            // Restart the timer
            cancellable?.cancel()
            startGame()
        }
    
    func update() {
        guard !gameOver else { return }
        ballPosition.x += dx
        ballPosition.y += dy
        
        if ballPosition.x < 0 || ballPosition.x > 400 {
            dx = -dx
        }
        
        if ballPosition.y < 0 {
            dy = -dy
        }
        
        if ballPosition.y > 800 {
            // Game Over
            gameOver = true
            cancellable?.cancel()
            return
        }
        
        if abs(ballPosition.y - 750) <= 25 && abs(ballPosition.x - paddlePosition) <= 50 {
            dy = -dy
            score += 1
            
            if score % 3 == 0 {
                level += 1
                dx *= 1.1
                dy *= 1.1
            }
        }
    }
}
