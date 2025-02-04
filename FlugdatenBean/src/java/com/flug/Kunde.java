
package com.flug;

import java.io.Serializable;
import java.util.List;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToMany;
import javax.persistence.Table;

@Entity
@Table(name = "Kunde")
public class Kunde implements Serializable{
    int id;
    String anrede;
    String namen; //TODO sollte später noch atomar gemacht werden
    String plz;
    String ort;
    String strasse;
    String land;
    List<Buchungsdaten> buchungen;

    public Kunde() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getAnrede() {
        return anrede;
    }

    public void setAnrede(String anrede) {
        this.anrede = anrede;
    }

    public String getNamen() {
        return namen;
    }

    public void setNamen(String namen) {
        this.namen = namen;
    }

    public String getPlz() {
        return plz;
    }

    public void setPlz(String plz) {
        this.plz = plz;
    }

    public String getOrt() {
        return ort;
    }

    public void setOrt(String ort) {
        this.ort = ort;
    }

    public String getStrasse() {
        return strasse;
    }

    public void setStrasse(String strasse) {
        this.strasse = strasse;
    }

    public String getLand() {
        return land;
    }

    public void setLand(String land) {
        this.land = land;
    }

    @ManyToMany
    (mappedBy = "kunde")
    public List<Buchungsdaten> getBuchungen() {
        return buchungen;
    }

    public void setBuchungen(List<Buchungsdaten> liste) {
        this.buchungen = liste;
    }
    
}
