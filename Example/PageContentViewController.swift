//
//  PageContentViewController.swift
//  Iniciacao
//
//  Created by Marjorie Alvelos on 2015-09-06.
//  Copyright (c) 2015 William Alvelos. All rights reserved.
//

import UIKit



class PageContentViewController: UIViewController {

    
    @IBOutlet weak var scroll: UIScrollView!

    @IBOutlet var pageControl: UIPageControl!
        
    var pageIndex: Int?
    var titleText : String!
    var imageName : String!
    
    
    private var y =  Float(10)
    private var x:Float = 10
    
    var animais = Array<Animal>()
    
    
    let container = UIView()
    let redSquare = UIView()
    let blueSquare = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageControl.pageIndicatorTintColor = UIColor.whiteColor()
        self.pageControl.numberOfPages = 5
        self.pageControl.currentPage = pageIndex!
        
        self.title = self.titleText
        

        
        if(self.titleText == "Aves"){
            let defaults = NSUserDefaults.standardUserDefaults()
            let dict = defaults.objectForKey("avestruz") as? Bool
            
            if(dict == true){
                let avestruz = Animal();
                avestruz.nome = "Avestruz"
                avestruz.enable = true
                avestruz.image = UIImage(named: "img.avestruz")
                avestruz.imageCarta = UIImage(named: "carta_avestruz")
                self.animais.append(avestruz)
            }else{
                let avestruz = Animal();
                avestruz.nome = "Avestruz"
                avestruz.enable = false
                avestruz.image = UIImage(named: "patas_avestruz")
                avestruz.imageCarta = UIImage(named: "carta_avestruz")
                self.animais.append(avestruz)
            }
        }
        
        
        if(self.titleText == "Mamíferos"){
            
            let defaults = NSUserDefaults.standardUserDefaults()
            let leao = defaults.objectForKey("leao") as? Bool
            
            
            if(leao == true){
                let leao = Animal();
                leao.nome = "Leão"
                leao.enable = true
                leao.image = UIImage(named: "img.leão")
                leao.imageCarta = UIImage(named: "carta_leao")
                self.animais.append(leao)
            }else{
                let leao = Animal();
                leao.nome = "Leão"
                leao.enable = false
                leao.image = UIImage(named: "pata_leão")
                leao.imageCarta = UIImage(named: "carta_leao")
                self.animais.append(leao)
            }
            
            
            let elefante = defaults.objectForKey("elefante") as? Bool
            
            if(elefante == true){
                let elefante = Animal();
                elefante.nome = "Elefante"
                elefante.enable = true
                elefante.image = UIImage(named: "img.leão")
                elefante.imageCarta = UIImage(named: "carta_leao")
                self.animais.append(elefante)
            }else{
                let elefante = Animal();
                elefante.nome = "Elefante"
                elefante.enable = false
                elefante.image = UIImage(named: "patas_elefante")
                elefante.imageCarta = UIImage(named: "carta_leao")
                self.animais.append(elefante)
            }

        }
        
        
        if(self.titleText == "Anfíbios"){
            let defaults = NSUserDefaults.standardUserDefaults()
            let dict = defaults.objectForKey("sapo") as? Bool
            
            if(dict == true){
                let sapo = Animal();
                sapo.nome = "Sapo Cururu"
                sapo.enable = true
                sapo.image = UIImage(named: "1CURURU")
                sapo.imageCarta = UIImage(named: "carta_sapo_cururu")
                self.animais.append(sapo)
            }else{
                let sapo = Animal();
                sapo.nome = "Sapo Cururu"
                sapo.enable = false
                sapo.image = UIImage(named: "patas_sapo")
                sapo.imageCarta = UIImage(named: "carta_sapo_cururu")
                self.animais.append(sapo)
            }
        }
        
        if(self.titleText == "Répteis"){
            
            let defaults = NSUserDefaults.standardUserDefaults()
            let dict = defaults.objectForKey("iguana") as? Bool
            
            if(dict == true){
                let Iguana = Animal();
                Iguana.nome = "Iguana"
                Iguana.enable = true
                Iguana.image = UIImage(named: "2IGUANA")
                Iguana.imageCarta = UIImage(named: "carta_iguana")
                self.animais.append(Iguana)
            }else{
                let Iguana = Animal();
                Iguana.nome = "Iguana"
                Iguana.enable = false
                Iguana.image = UIImage(named: "patas_iguana")
                Iguana.imageCarta = UIImage(named: "carta_iguana")
                self.animais.append(Iguana)
            }
            
        }
        
        if(self.titleText == "Aracnídeos"){
            let defaults = NSUserDefaults.standardUserDefaults()
            let dict = defaults.objectForKey("aranha") as? Bool
            
            if(dict == true){
                let aranha = Animal();
                aranha.nome = "Caranguejeira"
                aranha.enable = true
                aranha.image = UIImage(named: "aranha")
                aranha.imageCarta = UIImage(named: "carta_caranguejeira")
                self.animais.append(aranha)
            }
            else{
                let aranha = Animal();
                aranha.nome = "Caranguejeira"
                aranha.enable = false
                aranha.image = UIImage(named: "patas_aranha")
                aranha.imageCarta = UIImage(named: "carta_caranguejeira")
                self.animais.append(aranha)
            
            }
        }
        
        
        self.scroll.showsVerticalScrollIndicator = false
        self.scroll.showsHorizontalScrollIndicator = false
        
        prepareScroll()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.colorNavigation(self.titleText)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func prepareScroll(){
        let width = CGFloat((UIScreen.mainScreen().bounds.size.width - 30) / 2)
        let screenHeight = CGFloat((UIScreen.mainScreen().bounds.size.height - 30) / 2)
        let screenWidth = UIScreen.mainScreen().bounds.size.width
//        let scrollBarHeight = self.navigationController?.navigationBar.frame.height
        self.scroll.contentSize = CGSizeMake(screenWidth , CGFloat((animais.count)/2) *  CGFloat(screenHeight) - 30)
        
        x = 10
        y = 10
        
        for (var i = 0 ; i < animais.count ; i++){
            let cartaView = CartaView(frame: CGRectMake(CGFloat(x), CGFloat(y), width, width))
//            cartaView.label.text = animais[i].nome
            cartaView.number!.text = animais[i].nome
            cartaView.button!.tag = i
            
            cartaView.button.enabled = animais[i].enable!
            
            cartaView.layer.cornerRadius = cartaView.frame.size.width / 6;
    
            cartaView.clipsToBounds = true;
            
            cartaView.image?.layer.cornerRadius = cartaView.image!.frame.size.width / 8;
            
            cartaView.image?.clipsToBounds = true;
            
            cartaView.image?.image = animais[i].image
            
            
            if(self.titleText == "Mamíferos"){
                cartaView.backgroundColor = Mamifero.Caracteristicas
            }else if(self.titleText == "Aves"){
                cartaView.backgroundColor = Aves.Caracteristicas
            }else if(self.titleText == "Anfíbios"){
                cartaView.backgroundColor = Anfibios.Caracteristicas
            }else if(self.titleText == "Répteis"){
                cartaView.backgroundColor = Repteis.Caracteristicas
            }else if(self.titleText == "Aracnídeos"){
                cartaView.backgroundColor = Aracnideos.Caracteristicas
            }
            
            
            cartaView.button!.addTarget(self, action: "buttonTapped:", forControlEvents: .TouchUpInside)
            x = alterna(x)
            self.scroll.addSubview(cartaView)
        }
        
    }
    
    private func alterna(number : Float)->Float{
        let width = CGFloat((UIScreen.mainScreen().bounds.size.width - 30) / 2) + 20
        if Float(width) == x {
            y = y + Float(width) - 10
            return 10
        }
        return Float(width)
    }
    
    
    func colorNavigation(text:String){
        
        if(text == "Mamíferos"){
            self.navigationController?.navigationBar.barTintColor = Mamifero.Caracteristicas
            self.view.backgroundColor = Mamifero.Fundo
            self.pageControl.currentPageIndicatorTintColor = Mamifero.Caracteristicas
        }else if(text == "Aves"){
            self.navigationController?.navigationBar.barTintColor = Aves.Caracteristicas
            self.view.backgroundColor = Aves.Fundo
            self.pageControl.currentPageIndicatorTintColor = Aves.Caracteristicas
        }else if(text == "Anfíbios"){
            self.navigationController?.navigationBar.barTintColor = Anfibios.Caracteristicas
            self.view.backgroundColor = Anfibios.Fundo
            self.pageControl.currentPageIndicatorTintColor = Anfibios.Caracteristicas
        }else if(text == "Répteis"){
            self.navigationController?.navigationBar.barTintColor = Repteis.Caracteristicas
            self.view.backgroundColor = Repteis.Fundo
            self.pageControl.currentPageIndicatorTintColor = Repteis.Caracteristicas
        }else if(text == "Aracnídeos"){
            self.navigationController?.navigationBar.barTintColor = Aracnideos.Caracteristicas
            self.view.backgroundColor = Aracnideos.Fundo
            self.pageControl.currentPageIndicatorTintColor = Aracnideos.Caracteristicas
        }
        
    }
    
    
    func buttonTapped(sender : UIButton){
        print("change", terminator: "")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("Animal") as! AnimalViewController
        vc.animal = self.animais[sender.tag]
        vc.titleText = self.titleText
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    
    
}
