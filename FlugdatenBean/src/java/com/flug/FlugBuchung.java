
import java.io.Serializable;
import javax.persistence.Embeddable;

@Embeddable
public class FlugBuchung implements Serializable {
    private int flugId;
    private int buchungsdatenId;

    public FlugBuchung() {}

    public FlugBuchung(int flugId, int buchungsdatenId) {
        this.flugId = flugId;
        this.buchungsdatenId = buchungsdatenId;
    }
}
