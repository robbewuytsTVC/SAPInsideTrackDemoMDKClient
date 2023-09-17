import SwiftUI
import Combine

struct ContentView: View {
    @State private var ballPosition: CGPoint = CGPoint(x: 50, y: 50)
    @State private var paddlePosition: CGFloat = 300
    @State private var dx: CGFloat = 5.0
    @State private var dy: CGFloat = 5.0
    @State private var score: Int = 0
    @State private var timer: Timer.TimerPublisher = Timer.publish(every: 0.02, on: .main, in: .common)
    @State private var cancellable: Cancellable?
    @State private var gameOver = false
    @State private var level: Int = 1
    @State private var opacity: Double = 1.0
    @State private var showLoadingScreen: Bool = true
    
    var body: some View {
        
            ZStack {
                // Frame
                Rectangle()
                    .fill(Color(red: 139 / 255, green: 172 / 255, blue: 15 / 255))
                    .frame(maxWidth: 350, maxHeight: 650)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.black, lineWidth: 5)
                    )
                
                // Loading screen
                if showLoadingScreen {
                    VStack {
                        Text("SAP Inside Track 2023")
                            .font(.custom("Early GameBoy", size: 22))
                            .foregroundColor(.black)
                            .padding(.bottom, 20)
                        
                        Text("MDK PONG Game")
                            .font(.custom("Early GameBoy", size: 26))
                            .foregroundColor(.black)
                        
                        
                        Image("SAP3")  // Replace with your image name
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                        
                        Text("Loading...")
                            .font(.custom("Early GameBoy", size: 20))
                    }
                } else {
                    //Title
                    Text("SAP Inside Track goes 8bit")
                        .font(.custom("Early GameBoy", size: 20))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.black)
                        .offset(y: -250)
                    
                    //Ball
                    Rectangle()
                        .fill(Color.black)
                        .frame(width: 25, height: 25)
                        .position(ballPosition)
                        .opacity(gameOver ? 0 : 1)
                    
                    //Paddle
                    Rectangle()
                        .fill(Color.black)
                        .frame(width: 100, height: 10)
                        .position(x: paddlePosition, y: 625)
                        .opacity(gameOver ? 0 : 1)
                    
                    //Score
                    Text("Score: \(score)")
                        .foregroundColor(.black)
                        .font(.custom("Early GameBoy", size: 18))
                        .position(x: 90, y: 170)
                    
                    //Level
                    Text("Level: \(level)")
                        .foregroundColor(.black)
                        .font(.custom("Early GameBoy", size: 18))
                        .position(x: 90, y: 140)
                    
                    
                    if gameOver {
                        //Game over text
                        Text("GAME OVER!")
                            .font(.custom("Early GameBoy", size: 30))
                            .foregroundColor(Color.black)
                        
                        //TVC advertising :-)
                        Text("©2023 TheValueChain")
                            .foregroundColor(.black)
                            .font(.custom("Early GameBoy", size: 15))
                            .position(x: 170, y: 610)
                        
                        //Start text
                        Text("Press start to play again!")
                            .font(.custom("Early GameBoy", size: 11))
                            .foregroundColor(Color.black)
                            .position(x: 180, y: 380)
                            .opacity(opacity)
                            .onAppear {
                                startBlinking()
                            }
                        
                        //Start button
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
                        .position(x: 170, y: 450)
                    }
                }
            }
            .gesture(
                //Movement of paddle
                DragGesture()
                    .onChanged { value in
                        paddlePosition = value.location.x
                    }
            )
            .onAppear {
                // Simulate loading for 3 seconds and start the game
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.showLoadingScreen = false
                    startGame()
                }
            }
            .frame(width: 350, height: 650)
    }
    
    //Start game
    func startGame() {
        // Update game each 'tick' of the timer
        cancellable = timer.autoconnect().sink { _ in
            update()
        }
    }
    
    // Change opacity to 0, and keep repeating in order to have 'blinking' effect
    func startBlinking() {
        withAnimation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
            opacity = 0.0
        }
    }
    
    // Restart game, reset parameters
    func restartGame() {
        ballPosition = CGPoint(x: 50, y: 50)
        paddlePosition = 300
        dx = 5.0
        dy = 5.0
        score = 0
        level = 1
        gameOver = false
        opacity = 1
        
        cancellable?.cancel()
        startGame()
    }
    
    // Update parameters, again and again... until game over
    func update() {
        guard !gameOver else { return }
        ballPosition.x += dx
        ballPosition.y += dy
        
        // Bounce on sides
        if ballPosition.x <= 15	 || ballPosition.x >= 335 { // Frame is 350 wide, ball is 25 wide
            dx = -dx
        }
        
        // Bounce on roof
        if ballPosition.y <= 15 { // Top boundary
            dy = -dy
        }
        
        // Game Over, frame is 650 high
        if ballPosition.y > 650 {
            gameOver = true
            cancellable?.cancel()
            return
        }
        
        // Ball bounces on paddle, add point
        if abs(ballPosition.y - 625) <= 15 && abs(ballPosition.x - paddlePosition) <= 50 {
            dy = -dy
            score += 1
            
            // Level up each 3 points
            if score % 3 == 0 {
                level += 1
                dx *= 1.1
                dy *= 1.1
            }
        }
    }
}
