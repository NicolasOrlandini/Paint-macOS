//
//  ImageViewController.swift
//  TP4
//  iPaint
//
//  Created by Nicolas Orlandini on 11/11/2016.
//  Copyright © 2016 Nicolas Orlandini. All rights reserved.
//

import Cocoa

class ImageViewController: NSViewController {

    // ========================================================= //
    //                          OUTLETS                          //
    // ========================================================= //
    
    // Image View
    @IBOutlet weak var vueImage: ImageView?
    
    @IBOutlet weak var vue: NSView!
    // Panel A propos
    @IBOutlet weak var aPropos: NSPanel!
    
    // Panel Outils de dessin
    @IBOutlet weak var PanelOutils: NSPanel!
    
    // Boutons du panel Outils de dessin
    @IBOutlet weak var btnModifierFigure: NSButton!
    @IBOutlet weak var btnDeleteFigure: NSButton!
    @IBOutlet weak var btnRemplissage: NSButton!
    @IBOutlet weak var btnClearAll: NSButton!
    @IBOutlet weak var btnLigneLibre: NSButton!
    @IBOutlet weak var btnContour: NSButton!
    @IBOutlet weak var sliderEpaisseurTrait: NSSlider!
    @IBOutlet weak var btnAPropos: NSButton!
    
    @IBOutlet weak var colorWellTrait: NSColorWell!
    @IBOutlet weak var colorWellRemplissage: NSColorWell!
    
    @IBOutlet weak var fenetrePrincipale: NSWindow!
    @IBOutlet weak var scrollView: NSScrollView!
    
    var imageURL: URL? {
        didSet {
            if imageURL != nil {
                let monImage = NSImage(contentsOf: imageURL!)!
                
                // Redimentionnement automatique de la fenêtre en fonction de l'image chargée
                vueImage?.image = monImage
                vueImage?.setFrameSize(monImage.size)
                fenetrePrincipale?.setContentSize(NSSize(width: monImage.size.width, height: monImage.size.height))
                scrollView?.setFrameSize(NSSize(width: monImage.size.width + 3, height: monImage.size.height + 3))
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Taille originale de la fenêtre (sans photo) : 1024x768
        let defaultSize = NSSize(width: 1024, height: 768)
        vueImage?.setFrameSize(defaultSize)
        fenetrePrincipale?.setContentSize(NSSize(width: defaultSize.width + 4, height: defaultSize.height + 4))
        scrollView?.setFrameSize(NSSize(width: defaultSize.width + 4, height: defaultSize.height + 4))
        
        /*if let monImage = NSImage(contentsOfFile: "delorean.png") {
            vueImage.image = monImage
            vueImage.setFrameSize(monImage.size)
        }
        else {
            print("Image non trouvée")
        }*/
    }
    
    // ========================================================= //
    //                          ACTIONS                          //
    // ========================================================= //
    
    
    // Methode exécutée lorsque l'utilisateur clique sur le menu File -> Open
    // Ouvre un panel permettant de choisir une image dans les fichiers du Mac
    @IBAction func ouvrirFichier(_ sender: AnyObject) {
        print("ici j'ouvre le fichier")
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseFiles = true
        openPanel.canChooseDirectories = false
        openPanel.title = "Choisir une image"
        openPanel.runModal()
        imageURL = openPanel.url
    }
    
    
    @IBAction func undoCircle(_ sender: AnyObject) {
        vueImage?.enleverDerniereForme()
    }
    
    @IBAction func removeCircles(_ sender: AnyObject) {
        vueImage?.viderFormes()
    }
    
    @IBAction func remplissage(_ sender: AnyObject) {
        
        vueImage?.remplir = btnRemplissage.state == 1 ? true : false
    }
    
    @IBAction func contour(_ sender: AnyObject) {
        vueImage?.contour = btnContour.state == 1 ? true : false
    }
    
    
    @IBAction func changerCouleurTrait(_ sender: AnyObject) {
        vueImage?.couleurTrait = colorWellTrait.color
    }
    
    @IBAction func changerCouleurRemplissage(_ sender: AnyObject) {
        vueImage?.couleurRemplissage = self.colorWellRemplissage.color
    }
    
    @IBAction func dessinerCercle(_ sender: AnyObject) {
        vueImage?.etatForme = Etats.creationCercle
    }
    
    @IBAction func dessinerCarré(_ sender: AnyObject) {
        vueImage?.etatForme = Etats.creationCarre
    }
    
    @IBAction func dessinerTriangle(_ sender: AnyObject) {
        vueImage?.etatForme = Etats.creationTriangle
    }
    
    @IBAction func dessinerLigneLibre(_ sender: AnyObject) {
        vueImage?.etatForme = Etats.creationLigneLibre
    }
    
    @IBAction func changerEpaisseurTrait(_ sender: AnyObject) {
        vueImage?.epaisseurTrait = sliderEpaisseurTrait.floatValue
    }
    
    @IBAction func modifierFigurer(_ sender: AnyObject) {
            if(btnModifierFigure.state == 1){
                btnDeleteFigure.state = 0
                vueImage?.etat = Etats.modification
            }
            else {
                vueImage?.etat = Etats.attente
            }
    }
    
    // Lorsque le bouton "supprimer figure" est sélectionné, l'état passe
    // à "suppressionFigure" et l'utilisateur peut supprimer les figures
    // de son choix en cliquant dessus
    @IBAction func deleteFigure(_ sender: AnyObject) {
            if(btnDeleteFigure.state == 1){
                btnModifierFigure.state = 0
                vueImage?.etat = Etats.suppressionFigure
            }
            else {
                vueImage?.etat = Etats.attente
            }
    }
    
    // Supprime toutes les formes dessinées
    @IBAction func clearAll(_ sender: AnyObject) {
        if(btnClearAll.state == 1){
            btnModifierFigure.state = 0
            btnDeleteFigure.state = 0
            vueImage?.viderFormes()
            vueImage?.etat = Etats.attente
        }
    }
    
    // Méthode exécutée lorsque l'utilisateur clique sur le bouton i (info)
    // Affiche ou cache le panel "A propos"
    @IBAction func ouvrirAPropos(_ sender: AnyObject) {
        if (aPropos.isVisible) {
            aPropos.setIsVisible(false)
        }
        else {
            aPropos.setIsVisible(true)
        }
    }
    
    // Methode exécutée lorsque l'utilisateur clique sur le menu File -> Save
    // Ne sauvegarde pas les formes
    /*@IBAction func saveAs(_ sender: AnyObject) {
     
     do {
     let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
     let fileURL = documentsURL.appendingPathComponent("image.png")
     
     if let bits = vueImage?.bitmapImageRepForCachingDisplay(in: (vueImage?.bounds)!)
     /*let bits = vueImage?.image?.representations.first as? NSBitmapImageRep*/ {
     let data = bits.representation(using: NSPNGFileType, properties: [ : ])
     try data?.write(to: fileURL, options: .atomic)
     }
     } catch { }
     }*/
    
}
