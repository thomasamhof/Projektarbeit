
package com.flug;


import java.util.List;
import javax.ejb.Remote;


@Remote
public interface FlugdatenBeanRemote {
    
    void datensatzEinlesen(Flug flug);
    List<Flug> ausgeben();
    
}
