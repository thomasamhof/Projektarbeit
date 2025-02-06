/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.flug;

import java.util.Calendar;
import java.util.GregorianCalendar;
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
//       if (flugSuchen(flug.fhStart.kuerzel, flug.fhLandung.kuerzel, flug.flugdatum)!=null) {
//           entMan.persist(flug);
//       } else {
//           entMan.merge(flug);
//       }
   }
    public List<Flug> ausgeben(){
        return entMan.createQuery("From Flug").getResultList();
    }
    
    public Flug flugSuchen(String start, String landung, String datum){
        Flughafen fhStart=entMan.find(Flughafen.class, start);
        Flughafen fhLandung=entMan.find(Flughafen.class, landung);
        Flug flug=null;
        String query="FROM Flug f WHERE f.fhStart = :start AND f.fhLandung = :landung and f.flugdatum = :datum";
        try {
          flug = (Flug) entMan.createQuery(query, Flug.class).setParameter("start", fhStart)
                .setParameter("landung", fhLandung).setParameter("datum", datum).getSingleResult();  
        } catch (Exception e) {
            System.out.print("Flug wurde nicht gefunden.");
        }
        
        return flug;
    }
}
