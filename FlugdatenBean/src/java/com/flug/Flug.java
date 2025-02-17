package com.flug;

import java.io.Serializable;
import java.time.LocalDate;
import java.util.HashSet;
import java.util.Set;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;

@Entity
@Table(name = "Flug")
public class Flug implements Serializable {

    int id;
    Flughafen fhStart; //Startflughafen
    Flughafen fhLandung; //Landungsflughafen
    Flugzeug flugzeug;
    Fluggesellschaft fluggesellschaft;
    LocalDate flugdatum;
    double preis;
    int dauer;
    String linie;
    int sitzeGes;       //Gesamtanzahl der Sitze
    int sitzeBelegt;    //Anzahl der belegten Sitze
    Set<Buchungsdaten> buchungsdaten;

    public Flug() {
        buchungsdaten = new HashSet<Buchungsdaten>();
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "flugzeug_id")
    public Flugzeug getFlugzeug() {
        return flugzeug;
    }

    public void setFlugzeug(Flugzeug flugzeug) {
        this.flugzeug = flugzeug;
    }

    @OneToMany(fetch = FetchType.EAGER)
    public Set<Buchungsdaten> getBuchungsdaten() {
        return buchungsdaten;
    }

    public void setBuchungsdaten(Set<Buchungsdaten> buchungsdaten) {
        this.buchungsdaten = buchungsdaten;
    }

    public boolean hinzuBuchungsdaten(Buchungsdaten buchungsdaten) {
        return this.buchungsdaten.add(buchungsdaten);
    }

    @ManyToOne(fetch = FetchType.EAGER)
    public Flughafen getFhStart() {
        return fhStart;
    }

    public void setFhStart(Flughafen fhStart) {
        this.fhStart = fhStart;
    }

    @ManyToOne(fetch = FetchType.EAGER)
    public Flughafen getFhLandung() {
        return fhLandung;
    }

    public void setFhLandung(Flughafen fhLandung) {
        this.fhLandung = fhLandung;
    }

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "fluggesellschaft_kuerzel")
    public Fluggesellschaft getFluggesellschaft() {
        return fluggesellschaft;
    }

    public void setFluggesellschaft(Fluggesellschaft fluggesellschaft) {
        this.fluggesellschaft = fluggesellschaft;
    }

    public LocalDate getFlugdatum() {
        return flugdatum;
    }

    public void setFlugdatum(LocalDate flugdatum) {
        this.flugdatum = flugdatum;
    }

    public double getPreis() {
        return preis;
    }

    public void setPreis(double preis) {
        this.preis = preis;
    }

    public String getLinie() {
         return linie;
    }
    
    public void setLinie(String linie) {
        this.linie = linie;
    }
    
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

    public int getDauer() {
        return dauer;
    }
    
    public void setDauer(int dauer) {
        this.dauer=dauer;
    }
    
    @Override
    public String toString() {
        String ausgabe = id + " von " + fhStart.stadt + " nach " + fhLandung.stadt + "</br>";
        return ausgabe;
    }
}
