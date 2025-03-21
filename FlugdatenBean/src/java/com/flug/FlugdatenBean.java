
package com.flug;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import javax.ejb.Remote;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

@Stateless
@Remote(FlugdatenBeanRemote.class)
public class FlugdatenBean implements FlugdatenBeanRemote {

    @PersistenceContext(unitName = "FlugdatenPU")
    EntityManager entMan;

    @Override
    public void datensatzEinlesen(Object entitaet) {
        try {
            entMan.persist(entitaet);
        } catch (Exception e) {
            
        }
    }

    @Override
    public void datensatzAktualisieren(Object entitaet) {
           entMan.merge(entitaet); 
    }

    @Override
    public void testDatensatzLoeschen() {
           entMan.createNativeQuery("DELETE FROM flugzeug WHERE typ = 'Concorde';").executeUpdate();;
    }

    public List<Flug> ausgeben() {
        return entMan.createQuery("From Flug").getResultList();
    }

    @Override
    public Flug flugSuchen(String start, String landung, LocalDate datum) {
        Flughafen fhStart = entMan.find(Flughafen.class, start);
        Flughafen fhLandung = entMan.find(Flughafen.class, landung);
        Flug flug = null;
        String query = "FROM Flug f WHERE f.fhStart = :start AND f.fhLandung = :landung and f.flugdatum = :datum";
        try {
            flug = (Flug) entMan.createQuery(query, Flug.class).setParameter("start", fhStart)
                    .setParameter("landung", fhLandung).setParameter("datum", datum).getSingleResult();
        } catch (Exception e) {

        }

        return flug;
    }

    public Flug flugSuchen(Flug gesuchterflug) {
        Flug flug = null;
        String query = "FROM Flug f WHERE f.fhStart = :start AND f.fhLandung = :landung and f.flugdatum = :datum";
        try {
            flug = (Flug) entMan.createQuery(query, Flug.class).setParameter("start", gesuchterflug.fhStart)
                    .setParameter("landung", gesuchterflug.fhLandung).setParameter("datum", gesuchterflug.flugdatum).getSingleResult();
        } catch (Exception e) {
            
        }
        
        return flug;
    }

    @Override
    public Kunde kundeSuchen(int id) {
        return entMan.find(Kunde.class, id);
    }

    @Override
    public Buchungsdaten buchungsdatenSuchen(int buchungsnr, LocalDate buchungsdatum) {
        Buchungsdaten buchungsdaten = null;
        String query = "FROM Buchungsdaten b WHERE b.buchungsnr = :buchungsnr AND b.buchungsdatum = :datum";
        try {
            buchungsdaten = (Buchungsdaten) entMan.createQuery(query, Buchungsdaten.class).setParameter("buchungsnr", buchungsnr)
                    .setParameter("datum", buchungsdatum).getSingleResult();
        } catch (Exception e) {

        }

        return buchungsdaten;
    }

    @Override
    public Flugzeug flugzeugSuchen(String hersteller, String typ) {
        Flugzeug flugzeug = null;
        String query = "FROM Flugzeug f WHERE f.typ = :typ AND f.hersteller = :hersteller";
        try {
            flugzeug = (Flugzeug) entMan.createQuery(query, Flugzeug.class).setParameter("typ", typ)
                    .setParameter("hersteller", hersteller).getSingleResult();
        } catch (Exception e) {

        }
        
        return flugzeug;
    }

    @Override
    public Flughafen flughafenSuchen(String kuerzel) {
        return entMan.find(Flughafen.class, kuerzel);
    }

    @Override
    public Fluggesellschaft fluggesellschaftSuchen(String kuerzel) {
        return entMan.find(Fluggesellschaft.class, kuerzel);
    }
    
    //Zeit wird als String eingelesen und hier in ein LocalDate Format gespeichert
    public LocalDate datumParsen(String datum){
        DateTimeFormatter formi=null;
        if (datum.length()>10) {
            datum=datum.substring(0, 10);
            formi=DateTimeFormatter.ofPattern("yyyy-MM-dd");
        } else{
            formi=DateTimeFormatter.ofPattern("dd.MM.yyyy"); 
        }
        LocalDate datumAusgabe=LocalDate.parse(datum, formi);
        return datumAusgabe;
        
    }
    
    public String datumParsen(LocalDate datum){
        String datumString=datum.toString();
        String ausgabe=datumString.substring(8)+"."+datumString.substring(5, 7)+"."+datumString.substring(0,4);
        return ausgabe;
    }
    
    //Zeit liegt im Format hh:min vor, mit der Methode wird die Zeit in min umgerechnet und so gespeichert
    public int dauerParsen(String dauer){
        String[] stdMin=dauer.split(":");
        return Integer.parseInt(stdMin[0])*60+Integer.parseInt(stdMin[1]);
    }
    
    public String dauerParsen(int dauer){
        return (dauer/60+":"+dauer%60);
    }
}
