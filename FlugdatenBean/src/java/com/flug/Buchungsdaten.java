
package com.flug;

import java.io.Serializable;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.IdClass;
import javax.persistence.Table;

@Entity
@Table(name = "Buchungsdaten")
@IdClass(BuchungsdatenPK.class)
public class Buchungsdaten implements Serializable{
    int buchungsnr; 
    String buchungsdatum;

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
    public String getBuchungsdatum() {
        return buchungsdatum;
    }

    public void setBuchungsdatum(String buchungsdatum) {
        this.buchungsdatum = buchungsdatum;
    }
}
