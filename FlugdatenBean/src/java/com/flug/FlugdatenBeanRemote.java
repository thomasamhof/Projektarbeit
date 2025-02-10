
package com.flug;

import java.time.LocalDate;
import java.util.List;
import javax.ejb.Remote;

@Remote
public interface FlugdatenBeanRemote {  
    void datensatzEinlesen(Object entitaet);
    void datensatzAktualisieren(Object entitaet);
    List<Flug> ausgeben();
    Flug flugSuchen(String start, String landung, LocalDate datum); 
    Kunde kundeSuchen(int id); 
    Buchungsdaten buchungsdatenSuchen(int buchungsnr, LocalDate buchungsdatum); 
    Flugzeug flugzeugSuchen(String hersteller, String typ); 
    Flughafen flughafenSuchen(String kuerzel); 
    Fluggesellschaft fluggesellschaftSuchen(String kuerzel); 
    LocalDate datumParsen(String datum);
    String datumParsen(LocalDate datum);
    int dauerParsen(String dauer);
    String dauerParsen(int dauer);
}
