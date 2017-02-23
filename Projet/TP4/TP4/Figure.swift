//
//  Figure.swift
//  TP4
// iPaint
//
//  Created by Nicolas Orlandini on 12/11/2016.
//  Copyright © 2016 Nicolas Orlandini. All rights reserved.
//

import Foundation
import Cocoa

protocol estDessinable {
    func dessine()
    func contient(point: CGPoint) -> Bool
}

class Figure {
    var position:CGPoint = CGPoint()
    var epaisseurTrait = 1.0
    var couleurTrait = NSColor.black
    var estRempli = true
    var estContour = true
    var couleurRemplissage = NSColor.white
    
    func dessine() {
    }
    func contient(point: CGPoint) -> Bool{
        return true
    }
}

// Permet de dessiner un cercle personnalisé
class Cercle : Figure, estDessinable {
    var rayon : Float
    init(centre:CGPoint, rayon:Float) {
        self.rayon = rayon
        super.init()
        self.position = centre
    }
    override func dessine() {
        let diametre = self.rayon * 2
        let circleRect = CGRect(x: self.position.x - CGFloat(rayon), y: self.position.y - CGFloat(rayon), width: CGFloat(diametre), height: CGFloat(diametre))
        couleurTrait.setStroke()
        couleurRemplissage.setFill()
        
        let cPath: NSBezierPath = NSBezierPath(ovalIn: circleRect)
        
        cPath.lineWidth = CGFloat(self.epaisseurTrait)

        if (estRempli) {
            // Activation du remplissage de la forme
            cPath.fill()
        }
        if (estContour){
            // activation du contour de la forme
            cPath.stroke()
        }
    }
    
    // Renvoie true si la souris se trouve dans la forme et que la forme correspond à un cercle
    override func contient(point: CGPoint) -> Bool {
        if (position.x > (point.x - CGFloat(rayon)) && position.x < (point.x + CGFloat(rayon))
            && position.y > (point.y - CGFloat(rayon)) && position.y < (point.y + CGFloat(rayon))) {
            return true
        }
        else {
            return false
        }
    }
}

// Permet de dessiner un carré personnalisé
class Carré : Figure, estDessinable {
    var taille : Float
    init(centre:CGPoint, taille:Float) {
        self.taille = taille
        super.init()
        self.position = centre
    }
    override func dessine() {
        let carreRect = CGRect(x: self.position.x - CGFloat(self.taille)/2, y: self.position.y - CGFloat(self.taille)/2, width: CGFloat(self.taille), height: CGFloat(self.taille))
        couleurTrait.setStroke()
        couleurRemplissage.setFill()
        
        let cPath: NSBezierPath = NSBezierPath(rect: carreRect)
        
        cPath.lineWidth = CGFloat(self.epaisseurTrait)

        if (estRempli) {
            cPath.fill()
        }
        if (estContour){
            cPath.stroke()
        }
    }
    override func contient(point: CGPoint) -> Bool {
        if (position.x > (point.x - CGFloat(taille)/2) && position.x < (point.x + CGFloat(taille)/2)
            && position.y > (point.y - CGFloat(taille)/2) && position.y < (point.y + CGFloat(taille)/2)) {
            return true
        }
        else {
            return false
        }
    }
}


// Permet de dessiner un triangle personnalisé
class Triangle : Figure, estDessinable {
    var longueur : Float
    init(centre:CGPoint, longueur:Float) {
        self.longueur = longueur
        super.init()
        self.position = centre
    }
    override func dessine() {
        
        couleurTrait.setStroke()
        couleurRemplissage.setFill()
        
        // Création du triangle
        let cPath: NSBezierPath = NSBezierPath()
        cPath.move(to: NSMakePoint(self.position.x - CGFloat(self.longueur/2), self.position.y - CGFloat(self.longueur/2)))
        cPath.line(to: NSMakePoint(self.position.x + CGFloat(self.longueur/4), self.position.y + CGFloat(self.longueur)))
        cPath.line(to: NSMakePoint(self.position.x + CGFloat(self.longueur), self.position.y - CGFloat(self.longueur/2)))
        cPath.line(to: NSMakePoint(self.position.x - CGFloat(self.longueur/2) , self.position.y - CGFloat(self.longueur/2)))
        cPath.line(to: NSMakePoint(self.position.x + CGFloat(self.longueur/4), self.position.y + CGFloat(self.longueur)))
        
        cPath.lineWidth = CGFloat(self.epaisseurTrait)
        
        if (estRempli) {
            cPath.fill()
        }
        if (estContour){
            cPath.stroke()
        }
    }
    override func contient(point: CGPoint) -> Bool {
        if (position.x > (point.x - CGFloat(longueur)) && position.x < (point.x + CGFloat(longueur))
            && position.y > (point.y - CGFloat(longueur)*2) && position.y < point.y) {
            return true
        }
        else {
            return false
        }
    }
}
