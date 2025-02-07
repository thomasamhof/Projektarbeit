
package com.flug;

import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

@Stateless
public class FlugdatenBean implements FlugdatenBeanRemote {

    @PersistenceContext(unitName = "FlugdatenPU")
    EntityManager entMan;

    public void datensatzEinlesen(Object entitaet) {
        //0-Startfh 1-Landefh 2-Flugzeug 3-Fluggesellschaft
        //4-Buchungsdaten 5-Kunde 6-Flug
        try {
            entMan.persist(entitaet);
        } catch (Exception e) {
            System.out.println("wir-" + e.getMessage() + " - " + e.toString());
        }
    }

    @Override
    public void datensatzAktualisieren(Object entitaet) {
        entMan.merge(entitaet);
    }

    public List<Flug> ausgeben() {
        return entMan.createQuery("From Flug").getResultList();
    }

    @Override
    public Flug flugSuchen(String start, String landung, String datum) {
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
            System.out.println(e.getMessage());
        }
        
        return flug;
    }

    @Override
    public Kunde kundeSuchen(int id) {
        return entMan.find(Kunde.class, id);
    }

    @Override
    public Buchungsdaten buchungsdatenSuchen(int buchungsnr, String buchungsdatum) {
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
            System.out.println("wir: " + e.getMessage());
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
}
