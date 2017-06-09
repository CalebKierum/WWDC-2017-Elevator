//
//  Passengers.swift
//  HotelElevator
//
//  Created by Kierum Family Macbook on 8/20/16.
//  Copyright © 2016 Kierum Family Macbook. All rights reserved.
//

import Foundation
import SpriteKit

struct Person
{
    var startFloor:Int = 0
    var goalFloor:Int = 0
    var inElevator:Bool = false
    
    var corpial = Body()
}
class CircleT:SKShapeNode
{
    var label = SKLabelNode()
    func startup(gs: GameScene, size: CGFloat)
    {
        label = SKLabelNode(fontNamed: "Arial")
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.fontColor = UIColor.black
        label.fontSize = size
        
        label.zPosition = 10
        
        self.addChild(label)
        
        self.fillColor = UIColor(colorLiteralRed: 0 / 255, green: 191/255, blue: 230 / 255, alpha: 1.0)
        gs.addChild(self)
        self.zPosition = 5
    }
    func setText(txt: String)
    {
        if (txt == "1")
        {
            label.text = "L"
        }
        else
        {
            label.text = txt
        }
    }
    func clean()
    {
        label.removeFromParent()
        self.removeFromParent()
        label = SKLabelNode()
    }
}

class Body:SKSpriteNode
{
    var label = SKLabelNode(fontNamed: "Arial")
    var backing = SKShapeNode()
    var cleaned = false
    func start(gs: GameScene, size: CGFloat)
    {
        label.fontSize = size
        label.fontColor = UIColor.black
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.zPosition = 10
        
        backing = SKShapeNode(rectOf: CGSize(width: size * 1.2, height: size), cornerRadius: size / 10)
        backing.fillColor = UIColor(colorLiteralRed: 255 / 255, green: 69 / 255, blue: 0 / 255, alpha: 1.0)
        backing.zPosition = 9
        
        self.zPosition = 8
        self.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        self.size = CGSize(width: size, height: size * 2.5)
        
        backing.position = CGPoint(x: 0, y: self.size.height * 1.1 + size * 0.7)
        
        
        self.texture?.filteringMode = .nearest
        
        gs.hotelParent.addChild(self)
        self.addChild(backing)
        backing.addChild(label)
    }
    
    func setText(str: String)
    {
        if (str == "1")
        {
            label.text = "L"
        }
        else
        {
            label.text = str
        }
    }
    
    func clean()
    {
        cleaned = true
        backing.removeFromParent()
        label.removeFromParent()
        self.removeFromParent()
        backing = SKShapeNode()
        label = SKLabelNode()
    }
}

class Passengers
{
    static var People:[Person] = []
    
    static var waitTime:CGFloat = countdownStartStart//12
    
    static var timer:CGFloat = 0
    
    static var waiters:CGFloat = 0
    static var riders:CGFloat = 0
    
    static var d = true
    
    static func pagersOnThisFloor(floor: Int) -> Bool
    {
        for p in People
        {
            if (!p.inElevator && (p.startFloor == floor))
            {
                return true
            }
        }
        return false
    }
    static func peopleThatWantToGo(floor: Int) -> Bool
    {
        for p in People
        {
            if (p.goalFloor == floor)
            {
                return true
            }
        }
        return false
    }
    static func returnRiders() -> [Person]
    {
        var temp:[Person] = []
        for p in People
        {
            if (p.inElevator)
            {
                temp.append(p)
            }
        }
        return temp
    }
    static func returnWaiters() -> [Person]
    {
        var temp:[Person] = []
        for p in People
        {
            if (!p.inElevator)
            {
                temp.append(p)
            }
        }
        return temp
    }
    static func countRiders() -> CGFloat
    {
        var temp = 0
        for p in People
        {
            if (p.inElevator)
            {
                temp += 1
            }
        }
        return CGFloat(temp)
    }
    static func countWaiters() -> CGFloat
    {
        var temp = 0
        for p in People
        {
            if (!p.inElevator)
            {
                temp += 1
            }
        }
        return CGFloat(temp)
    }
    static var elevatorCount:Int = 0
    static func update(dt: CGFloat)
    {
        waiters = countWaiters()
        riders = countRiders()
        
        if ((waiters + riders) == 0)
        {
            timer = 0
        }
        
        if (timer <= 0)
        {
            timer = waitTime + Math.rand2(0, secondNum: 2)
            //Add person
            if (countWaiters() == 3)
            {
                print("GAME OVER")
                Storage.gs.gameOver()
                Storage.gameOver = false
            }
            else
            {
            
                newPerson()
                waitTime -= (countdownStartStart - countdownStartMin) / timesTillMin
                if (waitTime < countdownStartMin) {waitTime = countdownStartMin}
            }
        }
        else
        {
            timer -= dt * Storage.gs.editTime
        }
        
        elevatorCount = 0
        let hh = Storage.gs.hotelHeight
        let fs = hh / 30
        for c in People
        {
            let per = c.corpial

            if (!c.inElevator)
            {
                var y = fs * CGFloat(c.startFloor)
                y -= ((hh / 30) * 0.28)
                per.position = CGPoint(x: Storage.width * 0.27, y: y)
                
                per.setText(str: String(c.goalFloor))
            }
            else
            {
                per.position.y = Storage.gs.freight.size.height * 0.02
                
                if (elevatorCount == 0)
                {
                    per.position.x = 0
                }
                else if (elevatorCount == 1)
                {
                    per.position.x = Storage.gs.freight.size.width * 0.33
                }
                else
                {
                    per.position.x = -Storage.gs.freight.size.width * 0.33
                }
                
                elevatorCount += 1
            }
        }
        
    }
    static func wholisticReport()
    {
        if (d)
        {
            let waiters = returnWaiters()
            let riders = returnRiders()
            print("People waiting \(waiters.count)")
            for w in waiters
            {
                print("\tPlayer waiting on floor \(w.startFloor)")
            }
            print("People in elevator \(riders.count)")
            for w in riders
            {
                print("\tPlayer riding in elevate wants to go to \(w.goalFloor)")
            }
            print("Total \(People.count)")
        }
    }
    static var timesDone:Int = 0
    static func randomFloor() -> Int
    {
        if (timesDone == 0)
        {
            timesDone += 1
            return Int(arc4random_uniform(20)) + 10
        }
        else
        {
            timesDone += 1
            return Int(arc4random_uniform(30)) + 1
        }
    }
    static func newPerson()
    {
        var floor = randomFloor()
        while (pagersOnThisFloor(floor: floor))
        {
            floor = randomFloor()
        }
        
        var target = randomFloor()
        while (pagersOnThisFloor(floor: target) || peopleThatWantToGo(floor: target) || (target == floor))
        {
            target = randomFloor()
        }
        
        if (d)
        {
            print("New player on floor \(floor) Who wants to go to \(target)")
        }
        
        let num = arc4random_uniform(5) + 1
        let build = Body(imageNamed: "p\(num).png")
        build.start(gs: Storage.gs, size: Storage.width / 15)
        
        People.append(Person(startFloor: floor, goalFloor: target, inElevator: false, corpial: build))
        wholisticReport()
    }
    
    static var lastFloor:Int = -1
    static func gotToFloor(floor: Int)
    {
        if (1 == 1)
        {
            lastFloor = floor
            var offset:Int = 0
            var removeList:[Int] = []
            for i in 0..<People.count
            {
                
                if (People[i].inElevator)
                {
                    if (floor == People[i].goalFloor)
                    {
                        print("Arrived a player")
                        People[i].corpial.clean()
                        removeList.append(i)
                        offset -= 1
                        Storage.score += 1
                    }
                }
                else
                {
                    if (countRiders() < 3)
                    {
                        if (floor == People[i].startFloor)
                        {
                            print("Picked up a player")
                            People[i].inElevator = true
                            People[i].corpial.removeFromParent()
                            Storage.gs.freight.addChild(People[i].corpial)
                        }
                    }
                    else
                    {
                        print("CANT PICK PEIPL  UP BECAUE \(countRiders())")
                    }
                }
            }
            
            
            //wholisticReport()
            
            for val in removeList
            {
                People.remove(at: val)
            }
        }
    }
}
