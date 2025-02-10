
package com.flug;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.IdClass;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "Buchungsdaten")
@IdClass(BuchungsdatenPK.class)
public class Buchungsdaten implements Serializable{
    int buchungsnr; 
    LocalDate buchungsdatum;

    public Buchungsdaten() {
    }

    @Id
    public int getBuchungsnr() {
        return buchungsnr;
    }

    public void setBuchungsnr(int buchungsnr) {
        this.buchungsnr = buchungsnr;
    }

    @Id
    public LocalDate getBuchungsdatum() {
        return buchungsdatum;
    }

    public void setBuchungsdatum(LocalDate buchungsdatum) {
        this.buchungsdatum = buchungsdatum;
    }
    
    @Override
    public String toString(){
        return buchungsdatum.toString()+" "+buchungsnr;
    }

}
