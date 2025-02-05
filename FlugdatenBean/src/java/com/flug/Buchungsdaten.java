
package com.flug;

import java.io.Serializable;
import java.util.GregorianCalendar;
import java.util.List;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToMany;
import javax.persistence.Table;

@Entity
@Table(name = "Buchungsdaten")
public class Buchungsdaten implements Serializable{
    int id;
    List<Flug> fluege;
    int buchungsnr;
    String buchungsdatum;
    int passagiernr;
    List<Kunde> kunden;

    public Buchungsdaten() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    
    
    @ManyToMany(mappedBy = "buchungsdaten")
    public List<Flug> getFluege() {
        return fluege;
    }

    public void setFluege(List<Flug> fluege) {
        this.fluege = fluege;
    }

    
//    @Id
//    public int getFlug() {
//        return flug;
//    }
//
//    public void setFlug(int flug) {
//        this.flug = flug;
//    }

//    @Id
//    public int getKunde() {
//        return kunde;
//    }
//
//    public void setKunde(int kunde) {
//        this.kunde = kunde;
//    }

    public int getBuchungsnr() {
        return buchungsnr;
    }

    public void setBuchungsnr(int buchungsnr) {
        this.buchungsnr = buchungsnr;
    }

    public String getBuchungsdatum() {
        return buchungsdatum;
    }

    public void setBuchungsdatum(String buchungsdatum) {
        this.buchungsdatum = buchungsdatum;
    }

    public int getPassagiernr() {
        return passagiernr;
    }

    public void setPassagiernr(int passagiernr) {
        this.passagiernr = passagiernr;
    }

    @ManyToMany (mappedBy = "buchungen")
    public List<Kunde> getKunden() {
        return kunden;
    }

    public void setKunden(List<Kunde> kunden) {
        this.kunden = kunden;
    }
    
}
