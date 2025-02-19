package unittest;

import com.flug.*;
import com.aspose.cells.*;

public class UnitTest {

    public static String check(FlugdatenBeanRemote bean) throws Exception {
        // Arange
        Boolean vorEinlesenVorhanden, nachEinlesenVorhanden;
        Flugzeug testFlugzeug = new Flugzeug();
        testFlugzeug.setHersteller("Aerospatiale");
        testFlugzeug.setTyp("Concorde");
        vorEinlesenVorhanden = bean.flugzeugSuchen("Aerospatiale", "Concorde") != null;
        String ausgabe = "";

        // Act
        if (bean.flugzeugSuchen("Aerospatiale", "Concorde") == null) {
            bean.datensatzEinlesen(testFlugzeug);
        }
        
        nachEinlesenVorhanden = bean.flugzeugSuchen("Aerospatiale", "Concorde") != null;

        // Assert
        System.out.println("****** TEST ******");
        System.out.println("Vor Einlesen vorhanden: " + vorEinlesenVorhanden);
        System.out.println("Nach Einlesen vorhanden: " + nachEinlesenVorhanden);
        ausgabe = "****** Datenbank TEST ******<br>" + "Testdatensatz vor Einlesen vorhanden: " + vorEinlesenVorhanden + "<br>Testdatensatz wird eingespielt<br>Testdatensatz nach Einlesen vorhanden: " + nachEinlesenVorhanden;

        if (!vorEinlesenVorhanden && nachEinlesenVorhanden) {
            System.out.println("DER TEST WAR ERFOLGREICH!!!");
            ausgabe = ausgabe.concat("<br>DER TEST WAR ERFOLGREICH!!!");
        } else {
            System.out.println("DER TEST WAR NICHT ERFOLGREICH!!!");
            ausgabe = ausgabe.concat("<br>DER TEST WAR NICHT ERFOLGREICH!!!");
        }
        System.out.println("******************");
        ausgabe = ausgabe.concat("<br>******************");

        bean.testDatensatzLoeschen();
        return ausgabe;
    }

    public static String datenEinlesen(String[] daten, FlugdatenBeanRemote bean) { //Daten werden aus .csv eingelesen und in Object[] zurückgegeben
        try {
            Fluggesellschaft fluggesellschaft = bean.fluggesellschaftSuchen(daten[0]);
            if (fluggesellschaft == null) {
                fluggesellschaft = new Fluggesellschaft();
                fluggesellschaft.setKuerzel(daten[0]);
                fluggesellschaft.setName(daten[1]);
                bean.datensatzEinlesen(fluggesellschaft);
            }
            Flughafen fhStart = bean.flughafenSuchen(daten[3]);
            if (fhStart == null) {
                fhStart = new Flughafen();  //Start
                fhStart.setKuerzel(daten[3]);
                fhStart.setLand(daten[4]);
                fhStart.setStadt(daten[5]);
                bean.datensatzEinlesen(fhStart);
            }
            Flughafen fhLandung = bean.flughafenSuchen(daten[6]);
            if (fhLandung == null) {
                fhLandung = new Flughafen();  //Landung
                fhLandung.setKuerzel(daten[6]);
                fhLandung.setLand(daten[7]);
                fhLandung.setStadt(daten[8]);
                bean.datensatzEinlesen(fhLandung);
            }
            Flugzeug flugzeug = bean.flugzeugSuchen(daten[13], daten[12]);
            if (flugzeug == null) {
                flugzeug = new Flugzeug();
                flugzeug.setTyp(daten[12]);
                flugzeug.setHersteller(daten[13]);
                bean.datensatzEinlesen(flugzeug);
            }
            System.out.println("vor Buchung");
            Buchungsdaten buchung = bean.buchungsdatenSuchen(Integer.parseInt(daten[16].substring(0, daten[16].lastIndexOf("."))), bean.datumParsen(daten[17]));
            if (buchung == null) {
                buchung = new Buchungsdaten();
                System.out.println("vorzwischen");
                buchung.setBuchungsnr(Integer.parseInt(daten[16].substring(0, daten[16].lastIndexOf("."))));
                System.out.println("zwischen");
                buchung.setBuchungsdatum(bean.datumParsen(daten[17]));
                bean.datensatzEinlesen(buchung);
            }
            System.out.println("nach Buchung");
            Kunde kunde = bean.kundeSuchen(Integer.parseInt(daten[18].substring(0, daten[18].lastIndexOf("."))));
            if (kunde == null) {
                kunde = new Kunde();
                kunde.setId(Integer.parseInt(daten[18].substring(0, daten[18].lastIndexOf("."))));
                kunde.setAnrede(daten[19]);
                kunde.setName(daten[20]);
                kunde.setPlz(daten[21]);
                kunde.setOrt(daten[22]);
                kunde.setStrasse(daten[23]);
                kunde.setLand(daten[24]);
                kunde.hinzuBuchungen(buchung);
                bean.datensatzEinlesen(kunde);
            } else {
                kunde.hinzuBuchungen(buchung);
                bean.datensatzAktualisieren(kunde);
            }
            Flug flug = bean.flugSuchen(fhStart.getKuerzel(), fhLandung.getKuerzel(), bean.datumParsen(daten[10]));
            if (flug == null) {
                flug = new Flug();
                flug.setFhStart(bean.flughafenSuchen(fhStart.getKuerzel()));
                flug.setFhLandung(bean.flughafenSuchen(fhLandung.getKuerzel()));
                flug.hinzuBuchungsdaten(bean.buchungsdatenSuchen(buchung.getBuchungsnr(), buchung.getBuchungsdatum()));
                String datumFlug = daten[10];
                flug.setFlugdatum(bean.datumParsen(datumFlug));
                flug.setDauer(bean.dauerParsen(daten[9]));
                flug.setLinie(daten[2]);
                String preis = daten[11];
                //preis = preis.replaceFirst("[.]", "");
                preis = preis.replace(',', '.');
                flug.setPreis((Double.parseDouble(preis)));
                flug.setSitzeBelegt(Integer.parseInt(daten[14].substring(0, daten[14].lastIndexOf("."))));
                flug.setSitzeGes(Integer.parseInt(daten[15].substring(0, daten[15].lastIndexOf("."))));
                flug.setFluggesellschaft(bean.fluggesellschaftSuchen(fluggesellschaft.getKuerzel()));
                flug.setFlugzeug(bean.flugzeugSuchen(flugzeug.getHersteller(), flugzeug.getTyp()));
                bean.datensatzEinlesen(flug);
            } else {
                flug.hinzuBuchungsdaten(buchung);
                bean.datensatzAktualisieren(flug);
            }
        } catch (Exception e) {
            //ausgabe = "Unerwarteter Fehler" + e.getMessage();
            System.out.println("hier");
        }
        System.out.println("nach dem catch");
        return "";
    }

    public static void xlsEinlesen(String pfad, FlugdatenBeanRemote bean) throws Exception {
        Workbook buch = new Workbook(pfad);
        WorksheetCollection worksheets = buch.getWorksheets();    //hier werden die einzelnen Tabellen ausgelesen
        Worksheet tabelle = worksheets.get(0);
        String[] daten = new String[25];
        for (int i = 0; i < tabelle.getCells().getMaxDataRow(); i++) {
            daten[0] = String.valueOf(tabelle.getCells().get(i, 0).getValue()).replaceAll("[^A-Za-z]", "");
            if (!daten[0].matches("[A-Z]{2}") || daten[0].equalsIgnoreCase("ID")) {
                continue;
            }
            for (int j = 1; j < tabelle.getCells().getMaxDataColumn(); j++) {
                daten[j] = (String.valueOf(tabelle.getCells().get(i, j).getValue())).trim();

            }
            datenEinlesen(daten, bean);
        }
    }
}
