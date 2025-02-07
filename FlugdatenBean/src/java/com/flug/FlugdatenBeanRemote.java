
package com.flug;

import java.util.List;
import javax.ejb.Remote;

@Remote
public interface FlugdatenBeanRemote {  
    void datensatzEinlesen(Object entitaet);
    void datensatzAktualisieren(Object entitaet);
    List<Flug> ausgeben();
    Flug flugSuchen(String start, String landung, String datum); 
    Kunde kundeSuchen(int id); 
    Buchungsdaten buchungsdatenSuchen(int buchungsnr, String buchungsdatum); 
    Flugzeug flugzeugSuchen(String hersteller, String typ); 
    Flughafen flughafenSuchen(String kuerzel); 
    Fluggesellschaft fluggesellschaftSuchen(String kuerzel); 
}
