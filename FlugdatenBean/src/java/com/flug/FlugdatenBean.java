/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.flug;

import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

/**
 *
 * @author TAmhof
 */
@Stateless
public class FlugdatenBean implements FlugdatenBeanRemote {
    
    @PersistenceContext(unitName = "FlugdatenPU")
    EntityManager entMan;
            
   public void datensatzEinlesen(Flug flug){
       entMan.persist(flug);
   }
    public List<Flug> ausgeben(){
        return entMan.createQuery("From Flug").getResultList();
    }
}
