
package com.flug;

import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;
import javax.ejb.Remote;

@Remote
public interface FlugdatenBeanRemote {  
    void datensatzEinlesen(Flug flug);
    List<Flug> ausgeben();
    Flug flugSuchen(String start, String landung, String datum); 
}
