//
//  Modelclass.swift
//  VIT ShareCar
//
//  Created by Mridul Agarwal on 21/12/18.
//  Copyright © 2018 Techifuzz. All rights reserved.
//

class Modelclass{
    
    var name: String?
    var date: String?
    var time: String?
    var image: String?
    var to: String?
    var from: String?
    var number: String?
    
    init(name: String?, date: String?, time: String?, image: String?, to: String?, from: String?, number: String?) {
        self.name = name;
        self.date = date;
        self.time = time;
        self.image = image;
        self.to = to;
        self.from = from;
        self.number = number;
    }
    
}
