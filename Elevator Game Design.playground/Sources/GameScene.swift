//
//  GameScene.swift
//  HotelElevator
//
//  Created by Kierum Family Macbook on 8/20/16.
//  Copyright (c) 2016 Kierum Family Macbook. All rights reserved.
//

import SpriteKit

struct Floor
{
    var Room = SKSpriteNode()
    var Label = SKLabelNode()
}

class zPositions
{
    static var bg:CGFloat = 0
    static var room:CGFloat = 1
    static var label:CGFloat = 2
    static var freight:CGFloat = 3
    static var annotate:CGFloat = 4
}


let countdownStartStart:CGFloat = 10.2
let countdownStartMin:CGFloat = 5
let timesTillMin:CGFloat = 11
public class GameScene: SKScene {
    
    var score = SKLabelNode(fontNamed: "04b_19")
    var bscore = SKLabelNode(fontNamed: "04b_19")
    
    public var editSpeed:CGFloat = 1.0
    public var editDrag:CGFloat = 1.0
    public var editTime:CGFloat = 1.0
    
    //let marker = SKSpriteNode(imageNamed: "SLDFJK.png")
    //let marker2 = SKSpriteNode(imageNamed: "SLDFJK.png")
    func reset()
    {
        Passengers.waitTime = countdownStartStart
        Passengers.timer = 0
        for p in Passengers.People
        {
            p.corpial.clean()
        }
        Passengers.People = []
        for c in waitingCircles
        {
            c.clean()
        }
        waitingCircles = []
        yPercent = 0
        hotelMoveUp = 0
        velocity = 0
        direction = 0
        
        let action = SKAction.sequence([SKAction.fadeOut(withDuration: 1), SKAction.removeFromParent()])
        go1.run(action)
        go2.run(action)
        go3.run(action)
       // go3.run(action)
        
        Storage.gameOver = false
        
        Storage.score = 0
        
        Passengers.timesDone = 0
        
        clamped = false
    }
    
    
    let floorsCount:Int = 30//30
    
    var floors:[Floor] = []
    var freight = SKSpriteNode()
    var floorSize = CGSize()
    var hotelHeight:CGFloat = 0
    
    var hotelParent = SKNode()
    
    var yPercent:CGFloat = 0
    var hotelMoveUp:CGFloat = 0
    
    public var height:CGFloat = 0
    public var width:CGFloat = 0
    
    //Ipad 480 x 320
    //Ipod 568 x 320
    //284 = height / 2
    //284 = width * x
    
    
    var RoofStop:CGFloat = 0
    var FloorStop:CGFloat = 0
    var BasementStop:CGFloat = 0
    var maximumMove:CGFloat = 0
    var minimumMove:CGFloat = 0
    
    var waitingCircles:[CircleT] = []
    override public func didMove(to view: SKView) {
            //initializer()
    }
    public func initializer()
    {
        print(width)
        print(height)
        view?.isMultipleTouchEnabled = false
        print("I1")
        //view.frameInterval = 30
        
        /*marker.size = CGSize(width: 20, height: 20)
         marker.zPosition = 999999
         marker.position.x = width * 0.3
         self.addChild(marker)
         marker2.size = CGSize(width: 20, height: 20)
         marker2.zPosition = 999999
         marker2.position.x = width * 0.35
         self.addChild(marker2)*/
        
        self.backgroundColor = UIColor.black
        
        Storage.gs = self
        Storage.width = width
        
        
        hotelParent.position = CGPoint(x: 0, y: 0)
        self.addChild(hotelParent)
        
        floorSize = CGSize(width: width, height: width * 0.5)
        hotelHeight = floorSize.height * CGFloat(floorsCount)
        buildFloors()
        print("I2")
        freight = SKSpriteNode(imageNamed: "Elevator.png")
        freight.size = CGSize(width: floorSize.width * (314 / 960), height: floorSize.height * (290 / 422))
        freight.position = CGPoint(x: width / 2, y: (height / 2) - (freight.size.height * 0.5))
        freight.anchorPoint = CGPoint(x: 0.5, y: 0)
        freight.zPosition = zPositions.freight
        self.addChild(freight)
        
        RoofStop = (97/422) * floorSize.height
        FloorStop = (85/422) * floorSize.height
        BasementStop = (77/422) * floorSize.height
        maximumMove = 0.917253 * hotelHeight
        minimumMove = 0.00246482 * hotelHeight
        
        backgrounds()
        
        gameUpdate(currentTime: CFTimeInterval())
        
        carSy = freight.position.y
        parSy = hotelParent.position.y
        
        
        startTextStuff()
        arrowStuff()
        
        
        score.horizontalAlignmentMode = .center
        score.verticalAlignmentMode = .center
        score.zPosition = 99999
        score.fontSize = height * 0.08
        score.text = "0"
        score.fontColor = UIColor.white
        
        bscore = score.copy() as! SKLabelNode
        let shift = height * 0.007
        bscore.position = CGPoint(x: (width / 2), y: (height * 0.94))
        score.position = CGPoint(x: shift, y: -shift)
        bscore.zPosition = 99998
        bscore.fontColor = UIColor.black
        
        
        self.addChild(bscore)
        bscore.addChild(score)
        
        
        
        
        
    }
    func add()
    {
        let s = SKSpriteNode(imageNamed: "Spaceship.png")
        s.size = CGSize(width: width, height: height)
        s.position = CGPoint(x: width / 2, y: height / 2)
        s.zPosition = 99999999999999
        self.addChild(s)
    }
    var upArrow = SKSpriteNode(imageNamed: "Up.png")
    var downArrow = SKSpriteNode(imageNamed: "Down.png")
    func arrowStuff()
    {
        let arrowSize = CGSize(width: width / 6, height: (width / 6) * 2)
        upArrow.size = arrowSize
        downArrow.size = CGSize(width: arrowSize.width, height: -arrowSize.height)
            //CGSize(arrowSize.width, -arrowSize.height)
        
        upArrow.anchorPoint = CGPoint(x: 0.5, y: 0)
        downArrow.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        upArrow.position = CGPoint(x: width / 2, y: height * 0.7)
        downArrow.position = upArrow.position
        
        let apart = height * 0.05
        upArrow.position.y += apart
        downArrow.position.y -= apart
        
        upArrow.zPosition = zPositions.annotate
        downArrow.zPosition = zPositions.annotate
        
        hotelParent.addChild(upArrow)
        hotelParent.addChild(downArrow)
        
    }
    var line1_text = SKLabelNode()
    var globalFade = SKShapeNode()
    var globalFade2 = SKShapeNode()
    var carSy:CGFloat = 0
    var parSy:CGFloat = 0
    var texSy:CGFloat = 0
    func startTextStuff()
    {
        line1_text = SKLabelNode(fontNamed: "American Typewriter Bold")
        line1_text.text = "Do NOT leave more than three"
        line1_text.horizontalAlignmentMode = .center
        line1_text.verticalAlignmentMode = .bottom
        line1_text.zPosition = zPositions.annotate + 3
        line1_text.fontSize = width / 16
        let color = UIColor.white
        line1_text.fontColor = color
        line1_text.color = color
        line1_text.position.x = width / 2
        
        let line2_text = line1_text.copy() as! SKLabelNode
        line2_text.text = "customers waiting"
        line2_text.verticalAlignmentMode = .top
        
        let apart = height * 0.04
        line1_text.position.y = height / 2 + apart
        line2_text.position.y = 0 - apart
        line2_text.position.x = 0
        
        
        line1_text.addChild(line2_text)
        self.addChild(line1_text)
        
        texSy = line1_text.position.y
        
        globalFade = SKShapeNode(rectOf: CGSize(width: width, height: height))
        globalFade.strokeColor = UIColor.clear
        globalFade.fillColor = UIColor(colorLiteralRed: 0, green: 0, blue: 150 / 255, alpha: 1.0)
        globalFade.alpha = 0.7 / 2
        globalFade.zPosition = zPositions.annotate + 2
        globalFade.position = CGPoint(x: width / 2, y: height / 2)
        
        globalFade2 = SKShapeNode(rectOf: CGSize(width: width, height: height))
        globalFade2.strokeColor = UIColor.clear
        globalFade2.fillColor = UIColor(colorLiteralRed: 150 / 255, green: 0, blue: 0, alpha: 1)
        globalFade2.alpha = 0.7 / 2
        globalFade2.zPosition = zPositions.annotate + 2
        globalFade2.position = CGPoint(x: width / 2, y: height / 2)
        
        self.addChild(globalFade2)
        self.addChild(globalFade)
        
        
    }
    func backgrounds()
    {
        let black = SKShapeNode(rectOf: CGSize(width: width * 2, height: height))
        black.position = CGPoint(x: width / 2, y: height / 2)
        let color = UIColor.black
        black.fillColor = color
        black.zPosition = zPositions.bg
        black.strokeColor = UIColor.black
        //hotelParent.addChild(black)
        
        let sunset = SKSpriteNode(imageNamed: "Sunset.png")
        sunset.size = CGSize(width: width, height: width)
        sunset.position = CGPoint(x: width / 2, y: hotelHeight + floorSize.height * 0.5)
        sunset.zPosition = zPositions.bg
        hotelParent.addChild(sunset)
    }
    func buildFloors()
    {
        
        for i in 1...floorsCount
        {
            var tex = SKTexture(imageNamed: "Floor.png")
            if (i == 1)
            {tex = SKTexture(imageNamed: "Lobby.png")}
            else if (i == floorsCount)
            {tex = SKTexture(imageNamed: "Roof.png")}
            
            var build = Floor()
            
            let building = SKSpriteNode(texture: tex)
            building.size = floorSize
            building.position = CGPoint(x: width / 2, y: CGFloat(i) * floorSize.height)
            building.zPosition = zPositions.room
            
            let text = SKLabelNode(fontNamed: "American Typewriter Bold")
            text.text = String(i)
            text.position = CGPoint(x: floorSize.width * (692.5 / 960), y: floorSize.height * (229 / 422))
            text.position.x -= floorSize.width * 0.5
            text.position.y -= floorSize.height * 0.5
            text.fontSize = ((74 / 422) * floorSize.height) * 0.8
            text.horizontalAlignmentMode = .center
            text.verticalAlignmentMode = .center
            text.zPosition = zPositions.label
            let color = UIColor.black
            text.fontColor = color
            text.color = color
            if (i == 1)
            {text.text = ""}
            
            build.Label = text
            build.Room = building
            hotelParent.addChild(build.Room)
            build.Room.addChild(build.Label)
            
            
            floors.append(build)
            print("S!")
        }
    }
    var fingerDown = false
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       /* Called when a touch begins */
        if (animation >= 1.0){
            Storage.isStartSequence = false
            //globalFade.removeAllActions()
            globalFade2.run(SKAction.fadeOut(withDuration: 0.5))
            
            upArrow.run(SKAction.fadeOut(withDuration: 0.5))
            downArrow.run(SKAction.fadeOut(withDuration: 0.5))
            line1_text.run(SKAction.fadeOut(withDuration: 0.5))
            print("Fade out completely")
        }
        if (Storage.gameTime > 1) {
            mulp = 1
            globalFade.run(SKAction.fadeOut(withDuration: 0.5))
        }
        
        if (Storage.isStartSequence) { return}
        if (Storage.gameOver) {reset(); return}
        genProcess( pt: touches.first!.location(in: self))
        fingerDown = true
    }
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (Storage.isStartSequence) { return}
        if (Storage.gameOver) {return}
        genProcess( pt: touches.first!.location(in: self))
    }
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (Storage.isStartSequence) { return}
        if (Storage.gameOver) {return}
        direction = 0
        fingerDown = false
    }
    var direction:CGFloat = 0
    var velocity:CGFloat = 0
    func genProcess(pt: CGPoint)
    {
        direction = (pt.y / height) * 2 - 1
    }
   
    var lastTime:CFTimeInterval = CFTimeInterval()
    var delta:CGFloat = 0
    var dtpercent:CGFloat = 0
    
    var animation:CGFloat = 0
    var mulp:CGFloat = 0
    
    var clamped:Bool = false
    override public func update(_ currentTime: CFTimeInterval) {
        delta = CGFloat(currentTime - lastTime)
        lastTime = currentTime
        dtpercent = delta / (1 / 60)
        if (delta > 1) {return}
        Storage.gameTime += delta
        
        
        if (Storage.isStartSequence)
        {
            animation += delta * 0.5 * mulp
            let add:CGFloat = CGFloat(vector_smoothstep(0.0, 1.0, Double(1.0 - animation))) * width * 1.2
            freight.position.y = carSy + add
            hotelParent.position.y = parSy + add
            line1_text.position.y = texSy - CGFloat(vector_smoothstep(0.0, 1.0, Double(animation))) * 1.2 * width
            
            
        }
        else
        {
            gameUpdate(currentTime: currentTime)
            
            score.text = String(Storage.score)
            bscore.text = String(Storage.score)
        }
        
        if (clamped)
        {
            bscore.position.y = height * 0.93
        }
        else
        {
            bscore.position.y = (height * 2) + (hotelParent.position.y)
            
            if (bscore.position.y < height * 0.93)
            {
                bscore.position.y = height * 0.93
                clamped = true
            }
        }
        
        //add()
    }
    func gameUpdate(currentTime: CFTimeInterval)
    {
        if (Storage.gameOver) {return}
        
        if (!Storage.isStartSequence)
        {
            Passengers.update(dt: delta)
        }
        
        if (yPercent > 1.0) {
            yPercent = 1.0 - abs(yPercent - 1.0)
            velocity /= -1.1
        }
        else if (yPercent < 0) {
            yPercent = 0 + abs(yPercent)
            velocity /= -1.1
        }
        
        let yy = Math.linearForm(p1: CGPoint(x: 0, y: -0.0249333), p2: CGPoint(x: 1, y: 0.94334), x: yPercent)
        moveHotel(yy: yy)
        
        checkWhichFloor(yy: yy)
        
        
        
        velocity += direction * 0.00007 * dtpercent
        yPercent += velocity * editSpeed
        velocity /= pow(1 + 0.03 * editDrag, dtpercent)
        
        //print("DT \(delta)\tDTPercent \(dtpercent)\tDirection \(direction)\tvelocity \((velocity * dtpercent) / delta)")
        
        //DT 0.0166172	DTPercent 0.997032	Direction 0.973592	velocity 0.00224437
        //DT 0.499999	DTPercent 29.9999	Direction 1.0	velocity 0.00147106
        
                                                            //0.0705572
        
        //
        //print(round(velocity * 100 * 10000000.0) / 10000000.0)
        //DEVIDE BY 100
        waitingCirclesDisplay()
    }
    func waitingCirclesDisplay()
    {
        let wait = Passengers.returnWaiters()
        
        if (waitingCircles.count == wait.count)
        {
            
        }
        else if (waitingCircles.count < wait.count)
        {
            if (waitingCircles.count < 3)
            {
                let rad = (width / 15) / 2
                let circle = CircleT(circleOfRadius: rad)
                circle.startup(gs: self, size: rad * 1.8)
                waitingCircles.append(circle)
            }
        }
        else
        {
            if let l = waitingCircles.last
            {
                l.clean()
            }
            waitingCircles.removeLast()
        }
        
        let oneList:[CGFloat] = [0.5]
        let twoList:[CGFloat] = [0.333, 0.666]
        let threeList:[CGFloat] = [0.25, 0.5, 0.75]
        
        let yline = freight.position.y + (freight.size.height * 1.3)
        
        var dmax = waitingCircles.count
        if (dmax > 3) {dmax = 3}
        
        var arr:[CGFloat] = []
        if (dmax == 1) {arr = oneList}
        else if (dmax == 2) {arr = twoList}
        else if (dmax == 3) {arr = threeList}
        
        for i in 0..<dmax
        {
            let ws = waitingCircles[i]
            let per = wait[i]
            
            ws.setText(txt: String(per.startFloor))
            
            ws.position.y = yline
            
            let lineWidth = (width / 3)
            let startx = (width / 2) - lineWidth * 0.5
            
            
            ws.position.x = startx + (arr[i] * lineWidth)
        }
    }
    var go1 = SKLabelNode()
    var go2 = SKShapeNode()
    var go3 = SKLabelNode()
    func gameOver()
    {
        go1 = SKLabelNode(fontNamed: "American Typewriter Bold")
        go1.text = "Game Over"
        go1.position = CGPoint(x: width / 2, y: height / 2)
        go1.horizontalAlignmentMode = .center
        go1.verticalAlignmentMode = .center
        go1.zPosition = 999998
        go1.alpha = 0
        go1.run(SKAction.fadeIn(withDuration: 2))
        //fadeIn(withDuration: 
        go1.fontColor = UIColor.white
        go1.fontSize = width / 15
        self.addChild(go1)
        
        go3 = SKLabelNode(fontNamed: "American Typewriter Bold")
        go3.text = "Score: \(Storage.score)"
        go3.position = CGPoint(x: width / 2, y: (height / 2) - (go1.fontSize * 1.2))
        go3.horizontalAlignmentMode = .center
        go3.verticalAlignmentMode = .center
        go3.zPosition = 999999
        go3.alpha = 0
        go3.run(SKAction.fadeIn(withDuration: 2))
        go3.fontColor = UIColor.white
        go3.fontSize = width / 17
        self.addChild(go3)
        
        go2 = SKShapeNode(circleOfRadius: 1)
        go2.fillColor = UIColor.black
        go2.strokeColor = UIColor.clear
        go2.run(SKAction.scale(by: 1000, duration: 1))
        go2.zPosition = 999997
        go2.position = CGPoint(x: width / 2, y: height / 2)
        self.addChild(go2)
        
        
        self.run(SKAction.sequence([SKAction.wait(forDuration: 2), SKAction.run(resetgo)]))
    }
    func resetgo()
    {
        Storage.gameOver = true
    }
    func calculateMinDistance() -> (CGFloat, Int)
    {
        var minimumDistance:CGFloat = 9999999
        var minFloor:Int = -1
        
        let freightY = freight.position.y
        for i in 0..<floors.count
        {
            let flr = floors[i]
            let itsY = (flr.Room.position.y + hotelParent.position.y - (floorSize.height * 0.5)) + ((85/422) * floorSize.height)
            
            let dist = abs(freightY - itsY)
            if (dist < minimumDistance) {minimumDistance = dist; minFloor = i + 1}
            
        }
        
        minimumDistance /= floorSize.height
        return (minimumDistance, minFloor)
        
    }
    func checkWhichFloor(yy: CGFloat)
    {
        let minDist = calculateMinDistance()
        
        
        let calc = abs(round(velocity * 100 * 1000000) / 1000000)
        //CHECKS
        var onFloor = false
        if (!fingerDown)
        {
            //velocity /= pow(1.0 + (distf * 0.05), dtpercent)
            if (calc < 0.006998)
            {
                if (minDist.0 < 0.053072) //0.043278
                {
                    velocity = 0
                    onFloor = true
                    Passengers.gotToFloor(floor: minDist.1)
                }
            }
        }
        
        
        
        if ((calc) < 0.006998)
        {
            //print("\(calc) SLOW")
        }
        else
        {
            //print(calc)
        }
        
        //What is it not
        
        
        if (onFloor)
        {
            freight.texture = SKTexture(imageNamed: "ElevatorOn.png")
        }
        else
        {
            freight.texture = SKTexture(imageNamed: "Elevator.png")
        }
        
    }
    var hotelBottom:CGFloat = 0
    func moveHotel(yy:CGFloat)
    {
        hotelMoveUp = yy * hotelHeight
        
        
        hotelBottom = 0.0249333 * hotelHeight
        
        let freightNeuteral = (width * 0.8875 ) - (freight.size.height * 0.5)
        if (hotelMoveUp > maximumMove)
        {
            let delta = abs(hotelMoveUp - maximumMove)
            hotelMoveUp = maximumMove
            freight.position.y = freightNeuteral + delta
        }
        else if (hotelMoveUp < minimumMove)
        {
            let delta = abs(hotelMoveUp - minimumMove)
            hotelMoveUp = minimumMove
            freight.position.y = freightNeuteral - delta
        }
        else
        {
            freight.position.y = freightNeuteral
        }
        
        hotelParent.position.y = -hotelMoveUp
    }
}
