
package com.flug;

import java.io.Serializable;
import java.util.GregorianCalendar;
import java.util.List;
import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Table;

@Entity
@Table(name = "Flug")
public class Flug implements Serializable{
    int id;
    Flughafen fhStart;
    Flughafen fhLandung;
    Flugzeug flugzeug;
    Fluggesellschaft fluggesellschaft;
    GregorianCalendar flugdatum;
    double preis;
//    int dauer;
//    String linie;
    int sitzeGes;       //Gesamtanzahl der Sitze
    int sitzeBelegt;    //Anzahl der belegten Sitze
    List<Buchungsdaten> buchungsdaten;

    public Flug() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    @ManyToOne(cascade = {CascadeType.PERSIST, CascadeType.MERGE}
      , fetch = FetchType.EAGER)
    public Flugzeug getFlugzeug() {
        return flugzeug;
    }

    public void setFlugzeug(Flugzeug flugzeug) {
        this.flugzeug = flugzeug;
    }

    @ManyToMany(cascade = {CascadeType.PERSIST, CascadeType.MERGE}
      , fetch = FetchType.EAGER)
     @JoinTable(name = "flug_buchung", joinColumns = @JoinColumn(name = "flug_id"),
        inverseJoinColumns = @JoinColumn(name = "buchungsdaten_id"))
    public List<Buchungsdaten> getBuchungsdaten() {
        return buchungsdaten;
    }

    public void setBuchungsdaten(List<Buchungsdaten> buchungsdaten) {
        this.buchungsdaten = buchungsdaten;
    }

    @ManyToOne(cascade = {CascadeType.PERSIST, CascadeType.MERGE}
      , fetch = FetchType.EAGER)
    public Flughafen getFhStart() {
        return fhStart;
    }

    public void setFhStart(Flughafen fhStart) {
        this.fhStart = fhStart;
    }

    @ManyToOne(cascade = {CascadeType.PERSIST, CascadeType.MERGE}
      , fetch = FetchType.EAGER)
    public Flughafen getFhLandung() {
        return fhLandung;
    }

    public void setFhLandung(Flughafen fhLandung) {
        this.fhLandung = fhLandung;
    }

    @ManyToOne(cascade = {CascadeType.PERSIST, CascadeType.MERGE}
      , fetch = FetchType.EAGER)
    public Fluggesellschaft getFluggesellschaft() {
        return fluggesellschaft;
    }

    public void setFluggesellschaft(Fluggesellschaft fluggesellschaft) {
        this.fluggesellschaft = fluggesellschaft;
    }

    public GregorianCalendar getFlugdatum() {
        return flugdatum;
    }

    public void setFlugdatum(GregorianCalendar flugdatum) {
        this.flugdatum = flugdatum;
    }

    public double getPreis() {
        return preis;
    }

    public void setPreis(double preis) {
        this.preis = preis;
    }

//    public String getLinie() {
//        return linie;
//    }
//
//    public void setLinie(String linie) {
//        this.linie = linie;
//    }

    public int getSitzeGes() {
        return sitzeGes;
    }

    public void setSitzeGes(int sitzeGes) {
        this.sitzeGes = sitzeGes;
    }

    public int getSitzeBelegt() {
        return sitzeBelegt;
    }

    public void setSitzeBelegt(int sitzeBelegt) {
        this.sitzeBelegt = sitzeBelegt;
    }

//    public int getDauer() {
//        return dauer;
//    }
//
//    public void setDauer(String dauer) {
//        String[] dauerArray=dauer.split(":");
//        int std=Integer.parseInt(dauerArray[0].trim());
//        int min=Integer.parseInt(dauerArray[1].trim());
//        this.dauer=std;
//    }
    
}
