
package com.flug;

import java.io.Serializable;
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
import javax.persistence.Table;

@Entity
@Table(name = "Flug")
public class Flug implements Serializable{
    int id;
    String Start;
    Flughafen flughafen;
//    Flugzeug flugzeug;
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

    public String getStart() {
        return Start;
    }

    public void setStart(String Start) {
        this.Start = Start;
    }

    @ManyToOne(cascade = {CascadeType.PERSIST, CascadeType.MERGE}
      , fetch = FetchType.EAGER)
    public Flughafen getFlughafen() {
        return flughafen;
    }

    public void setFlughafen(Flughafen flughafen) {
        this.flughafen = flughafen;
    }

//    @ManyToOne(cascade = {CascadeType.PERSIST, CascadeType.MERGE}
//      , fetch = FetchType.EAGER)
//    public Flugzeug getFlugzeug() {
//        return flugzeug;
//    }
//
//    public void setFlugzeug(Flugzeug flugzeug) {
//        this.flugzeug = flugzeug;
//    }

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
    
}
