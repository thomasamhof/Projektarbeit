package com.flug;

import java.io.Serializable;
import java.time.LocalDate;

public class BuchungsdatenPK implements Serializable {
    int buchungsnr;
    LocalDate buchungsdatum;

    public BuchungsdatenPK() {
    }

    public BuchungsdatenPK(int buchungsnr, LocalDate buchungsdatum) {
        this.buchungsnr = buchungsnr;
        this.buchungsdatum = buchungsdatum;
    }

    public int getBuchungsnr() {
        return buchungsnr;
    }

    public void setBuchungsnr(int buchungsnr) {
        this.buchungsnr = buchungsnr;
    }

    public LocalDate getBuchungsdatum() {
        return buchungsdatum;
    }

    public void setBuchungsdatum(LocalDate buchungsdatum) {
        this.buchungsdatum = buchungsdatum;
    }

    @Override
    public int hashCode() {
        int hash = 7;
        hash = 47 * hash + this.buchungsnr;
        hash = 47 * hash + (this.buchungsdatum != null ? this.buchungsdatum.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        final BuchungsdatenPK other = (BuchungsdatenPK) obj;
        if (this.buchungsnr != other.buchungsnr) {
            return false;
        }
        if ((this.buchungsdatum == null) ? (other.buchungsdatum != null) : !this.buchungsdatum.equals(other.buchungsdatum)) {
            return false;
        }
        return true;
    }
}
