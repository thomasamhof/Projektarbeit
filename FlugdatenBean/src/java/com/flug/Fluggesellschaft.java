package com.flug;

import java.io.Serializable;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "Fluggesellschaft")
public class Fluggesellschaft implements Serializable {

    String kuerzel;
    String name;

    public Fluggesellschaft() {
    }

    @Id
    public String getKuerzel() {
        return kuerzel;
    }

    public void setKuerzel(String kuerzel) {
        this.kuerzel = kuerzel;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
    
    @Override
    public String toString(){
        return String.format("%s %s", kuerzel, name);
    }
}
