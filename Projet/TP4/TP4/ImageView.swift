//
//  ImageView.swift
//  TP4
//  iPaint
//
//  Created by Nicolas Orlandini on 11/11/2016.
//  Copyright © 2016 Nicolas Orlandini. All rights reserved.
//

import Cocoa
import Foundation

enum Etats {
    case attente
    case creationCercle
    case creationCarre
    case creationTriangle
    case creationLigneLibre
    case modeDeplacement
    case redimensionnementCercle
    case redimensionnementCarre
    case redimensionnementTriangle
    case tracerLigneLibre
    case modification
    case suppressionFigure
}

class ImageView: NSImageView {

    var figures: [Figure] = []
    var remplir = true
    var contour = true
    var couleurTrait: NSColor = NSColor.black
    var couleurRemplissage: NSColor = NSColor.white
    var rayon: Float = 0
    var forme = 1
    var localPoint:CGPoint = CGPoint()
    var indexFigure = 0
    var etat = Etats.attente
    var etatForme = Etats.creationCercle
    var figureCourante = Figure()
    var epaisseurTrait: Float = 1.0
    
    // Renvoie vrai si le tableau est vide sinon faux
    var FiguresEstVide: Bool {
        get {
            return figures.isEmpty ? true : false
        }
    }
    
    // Methode draw
    // Toutes les formes sont dessinées
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        for figure in figures {
            figure.dessine()
        }
    }
    
    // Exécuté lorsque le clic de la souris est relâché
    override func mouseDown(with event: NSEvent) {
        // Récupération des coordonnées ou l'utilisataur a cliqué
        let location = event.locationInWindow;
        localPoint = convert(location, to: nil)
        
        switch etat {
            /* Etat suppression figure, l'utilisateur peut supprimer la figure
             de son choix en appuyant dessus */
        case .suppressionFigure:
            var i = 0
            /* Le tableau de figure est parcouru 
             Si l'utilisateur clique sur une forme, celle-ci sera supprimée */
            for figure in figures {
                if figure.contient(point: localPoint) {
                    if !FiguresEstVide {
                        figures.remove(at: i)
                    }
                }
                if (i < figures.count) {
                    i = i+1
                }
            }
            break
            
            /* Etat modification :
             Les caractéristiques de la figure sélectionnée sont rechargés
             avec les nouveaux paramètres */
        case .modification:
            for figure in figures {
                if figure.contient(point: localPoint) {
                    figureCourante = figure
                    
                    configurerCaracteristiquesForme()
                }
            }
        
            /* Etat attente :
             Création et déplacement de formes */
            case .attente:
                for figure in figures {
                    if figure.contient(point: localPoint) {
                        figure.position = localPoint
                        
                        figureCourante = figure
                        etat = .modeDeplacement
                    }
                }
                if etat == .attente {
                    switch etatForme {
                    case .creationCarre: figureCourante = Carré (centre: localPoint, taille: rayon)
                    etat = .redimensionnementCarre
                        break
                    case .creationCercle: figureCourante = Cercle (centre: localPoint, rayon: rayon)
                    etat = .redimensionnementCercle
                        break
                    case .creationTriangle: figureCourante = Triangle (centre: localPoint, longueur: rayon)
                    etat = .redimensionnementTriangle
                        break
                    case .creationLigneLibre: figureCourante = Cercle (centre: localPoint, rayon: 1)
                    etat = .tracerLigneLibre
                        break
                    default:
                        break
                    }
                    configurerCaracteristiquesForme()
                    figures.append(figureCourante)
                    indexFigure = figures.count - 1
                }
            
        default:
            break
        }
        setNeedsDisplay()
    }
    
    // Exécuté lorsque la souris est en mouvement et que le clic est maintenu
    override func mouseDragged(with event: NSEvent) {
        
        let location = event.locationInWindow;
        let position = convert(location, to: nil)
        
        switch etat {
        case .redimensionnementCercle:
            let fig = figures[indexFigure] as! Cercle
            let a = fig.position
            fig.rayon = calculerTaille(positionFigure: a, positionSouris: position)
        
            break
        case .redimensionnementCarre:
            let fig = figures[indexFigure] as! Carré
            let a = fig.position
            fig.taille = calculerTaille(positionFigure: a, positionSouris: position)
            
            break
        case .redimensionnementTriangle:
            let fig = figures[indexFigure] as! Triangle
            let a = fig.position
            fig.longueur = calculerTaille(positionFigure: a, positionSouris: position)
            
            break
        case .modeDeplacement:
            figureCourante.position = position
            break
            /* A chaque fois que la souris bouge, un nouveau petit rond est créé
             pour former une ligne continu */
        case .tracerLigneLibre:
            ajouterPointLigneLibre(a : position)
            break
        default:
            break
        }
        setNeedsDisplay()
    }
    
    // Exécuté lorsque le clic de la souris est relâché
    override func mouseUp(with event: NSEvent) {
        if etat != .modification && etat != .suppressionFigure{
            etat = .attente
        }
    }
    
    // Configuration des caractéristiques d'une figure
    func configurerCaracteristiquesForme() {
        figureCourante.epaisseurTrait = Double(self.epaisseurTrait)
        figureCourante.estRempli = remplir
        figureCourante.estContour = contour
        figureCourante.couleurTrait = self.couleurTrait
        figureCourante.couleurRemplissage = self.couleurRemplissage
    }
    
    // Ajout d'un nouveau point pour créer une ligne continue (ligne libre)
    func ajouterPointLigneLibre(a position : CGPoint) {
        figureCourante = Cercle (centre: position, rayon: self.epaisseurTrait)
        figureCourante.epaisseurTrait = Double(self.epaisseurTrait)
        figureCourante.estRempli = true
        figureCourante.estContour = true
        figureCourante.couleurTrait = self.couleurTrait
        figureCourante.couleurRemplissage = self.couleurTrait
        indexFigure = figures.count - 1
        figures.append(figureCourante)
    }
    
    // Calcul de la nouvelle taille lors du redimentionnement des figures
    func calculerTaille(positionFigure: CGPoint, positionSouris: CGPoint) -> Float {
        let taille = sqrt(pow((positionFigure.x - positionSouris.x), 2) + pow((positionFigure.y - positionSouris.y), 2))
        return Float(taille)
    }
    
    
    // Permet de vider le tableau de formes et donc de supprimer les formes
    func viderFormes() {
        if !FiguresEstVide {
            figures.removeAll()
            setNeedsDisplay()
        }
    }
    
    // Permet de supprimer la dernière forme dessinée
    func enleverDerniereForme() {
        if !FiguresEstVide {
            figures.removeLast()
            setNeedsDisplay()
        }
    }
}
