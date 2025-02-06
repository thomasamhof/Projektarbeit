<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.flug.*,java.io.*,java.util.*, javax.naming.InitialContext,javax.naming.NamingException"%>
<!DOCTYPE html>
<%  Properties props; %> 
<%!    InitialContext ctx = null;
    FlugdatenBeanRemote bean = null; 
        String debug="";    %>
<%    props = new Properties();
    try {
        ctx = new InitialContext(props);
    } catch (NamingException ex) {
        ex.printStackTrace();
    }
    bean = (FlugdatenBeanRemote) ctx.lookup("FlugdatenBean/remote");

    //Flug flug=datenEinlesen("C:\\Projektarbeit\\SQfsfgsfdg.csv");
    out.println("hiur");
    debug=datenEinlesen("C:\\Java\\KlausurJan17\\JavaApplication12\\JL.csv");
    out.println(debug);
    //bean.datensatzEinlesen(flug);
    //List<Flug> flugListe=bean.ausgeben();
    //Calendar kalender=new GregorianCalendar(2012, 9, 27);
    //Flug flug1 = bean.flugSuchen("FRA", "JFK", "27.09.2012");
    //GregorianCalendar kalender=new GregorianCalendar(2012, 9, 27, 0, 0);
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>


    </body>
</html>

<%! public String datenEinlesen(String pfad) { //Daten werden aus .csv eingelesen und in Object[] zurückgegeben
        String debug="";
        BufferedReader buffi = null;
        String[] daten = null;
        Object[] objekte = new Object[7];
        String zeile = null;
        try {
            buffi = new BufferedReader(new FileReader(pfad));
            //buffi.readLine();
            //buffi.readLine();
            zeile = buffi.readLine();
            //out.println(zeile);
            // while (zeile != null) {
            //out.println("zeile");
            daten = zeile.split(";");
            //1 ID 2 Name 3 4 Linie 5 Flughafen 6 Land 7 Stadt 8 Flughafen 9 Land 10 Stadt 11 Dauer 12 Datum 13 Preis
            //14 Typ 15 Hersteller 16 Belegt 17 Gesamt 18 Nummer 19 Datum 20 Nummer 21 Anrede 22 Name 23 PLZ 24 Ort 25 Stra�e 26 Land
            Flughafen fhStart = new Flughafen();  //Start
            fhStart.setKuerzel(daten[3].trim());
            fhStart.setLand(daten[4]);
            fhStart.setStadt(daten[5]);
            objekte[0] = fhStart;

            Flughafen fhLandung = new Flughafen();  //Landung
            fhLandung.setKuerzel(daten[6].trim());
            fhLandung.setLand(daten[7]);
            fhLandung.setStadt(daten[8]);
            objekte[1] = fhLandung;

            Flugzeug flugzeug = new Flugzeug();
            flugzeug.setTyp(daten[12]);
            flugzeug.setHersteller(daten[13]);
            objekte[2] = flugzeug;

            Fluggesellschaft fluggesellschaft = new Fluggesellschaft();
            fluggesellschaft.setKuerzel(daten[0]);
            fluggesellschaft.setName(daten[1]);
            objekte[3] = fluggesellschaft;

            Buchungsdaten buchung = new Buchungsdaten();
            buchung.setBuchungsnr(Integer.parseInt(daten[16].trim()));
            String datumBuchung = daten[17].trim();
            //String tagBuchung=datumBuchung.substring(0,2);
            //String monatBuchung=datumBuchung.substring(3,5);
            //String jahrBuchung=datumBuchung.substring(6);
            //buchung.setBuchungsdatum(new GregorianCalendar(Integer.parseInt(jahrBuchung), Integer.parseInt(monatBuchung), Integer.parseInt(tagBuchung)));
            buchung.setBuchungsdatum(datumBuchung);
            buchung.setPassagiernr(Integer.parseInt(daten[18]));
            objekte[4] = buchung;

            Kunde kunde = new Kunde();
            kunde.setAnrede(daten[19]);
            kunde.setNamen(daten[20]);
            kunde.setPlz(daten[21]);
            kunde.setOrt(daten[22]);
            kunde.setStrasse(daten[23]);
            kunde.setLand(daten[24]);
            List<Buchungsdaten> listeBuchungenKunde = new ArrayList<Buchungsdaten>();
            listeBuchungenKunde.add(buchung);
            kunde.setBuchungen(listeBuchungenKunde);
            objekte[5] = kunde;

            Flug flug = new Flug();
            flug.setFhStart(fhStart);
            flug.setFhLandung(fhLandung);
            List<Buchungsdaten> listeBuchungenFlug = new ArrayList<Buchungsdaten>();
            listeBuchungenFlug.add(buchung);
            String datumFlug = daten[10].trim();
            //String tagFlug=datumFlug.substring(0,2);
            //String monatFlug=datumFlug.substring(3,5);
            //String jahrFlug=datumFlug.substring(6);
            //flug.setFlugdatum(new GregorianCalendar(Integer.parseInt(jahrFlug), Integer.parseInt(monatFlug), Integer.parseInt(tagFlug)));
            flug.setFlugdatum(datumFlug);
            flug.setBuchungsdaten(listeBuchungenFlug);
            //flug.setDauer(daten[10]);
            flug.setPreis(Double.parseDouble(daten[11].trim()));
            flug.setSitzeBelegt(Integer.parseInt(daten[14].trim()));
            flug.setSitzeGes(Integer.parseInt(daten[15].trim()));
            //flug.setLinie(daten[3]);
            objekte[6] = flug;

            //0-FlughafenStart  1-FlughafenLandung 2-Flugzeug 3-Fluggesellschaft 4-Buchung 5-Kunde 6-Flug
            //datenPersistieren(objekte);
            // }
        } catch (Exception e) {
            debug=e.toString();
        }
        return debug;
    }

    public void datenPersistieren(Object[] objekte) {
        bean.datensatzEinlesen((Flug) objekte[6]);

    }%>
