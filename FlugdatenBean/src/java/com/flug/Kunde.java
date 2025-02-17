
package com.flug;

import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;

@Entity
@Table(name = "Kunde")
public class Kunde implements Serializable{
    int id; //die Passagiernummer wird als PK verwendet
    String anrede;
    String name; //TODO sollte später noch atomar gemacht werden
    String plz;
    String ort;
    String strasse;
    String land;
    Set<Buchungsdaten> buchungen;

    public Kunde() {
        buchungen=new HashSet<Buchungsdaten>();
    }

    @Id
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

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
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

    @OneToMany(fetch = FetchType.EAGER)
    public Set<Buchungsdaten> getBuchungen() {
        return buchungen;
    }

    public void setBuchungen(Set<Buchungsdaten> liste) {
        this.buchungen = liste;
    }
    
    public boolean hinzuBuchungen(Buchungsdaten buchungsdaten){
        return this.buchungen.add(buchungsdaten);
    }
    
    @Override
    public String toString(){
        String ausgabe = id+" "+name+": ";
        for (Buchungsdaten buchung : buchungen) {
            ausgabe= ausgabe+buchung+", ";
        }
        return ausgabe;
    }
}
