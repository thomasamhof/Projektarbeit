<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.flug.*,java.io.*,java.util.*, javax.naming.InitialContext,javax.naming.NamingException"%>
<!DOCTYPE html>
<%  Properties props; %> 
<%!    InitialContext ctx = null;
    FlugdatenBeanRemote bean = null;
    String debug = "";
    String debug2 = "";%>
<%    props = new Properties();
    try {
        ctx = new InitialContext(props);
    } catch (NamingException ex) {
        ex.printStackTrace();
    }
    bean = (FlugdatenBeanRemote) ctx.lookup("FlugdatenBean/remote");

    //Flug flug=datenEinlesen("C:\\Projektarbeit\\SQfsfgsfdg.csv");
    String button = request.getParameter("button");
    String pfad = request.getParameter("pfad");
    if (button != null) {
        if (button.equals("einlesen")) {
            datenEinlesen("C:\\Test\\t.csv");
            out.println("ja");
        }
    }

    out.println(debug);
    out.println(debug2);
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
        <form action="index.jsp" method="get">
            <input type="text" name="pfad">
            <input type="submit" name="button" value="einlesen">
        </form>
        <%=debug%>

    </body>
</html>

<%! public void datenEinlesen(String pfad) { //Daten werden aus .csv eingelesen und in Object[] zurückgegeben
        BufferedReader buffi = null;
        String[] daten = null;
        String zeile = null;
        try {
            buffi = new BufferedReader(new FileReader(pfad));
            zeile = buffi.readLine();
            //out.println(zeile);
            // while (zeile != null) {
            //out.println("zeile");
            daten = zeile.split(";");
debug = "1";
            //1 ID 2 Name 3 4 Linie 5 Flughafen 6 Land 7 Stadt 8 Flughafen 9 Land 10 Stadt 11 Dauer 12 Datum 13 Preis
            //14 Typ 15 Hersteller 16 Belegt 17 Gesamt 18 Nummer 19 Datum 20 Nummer 21 Anrede 22 Name 23 PLZ 24 Ort 25 Stra�e 26 Land
            Flughafen fhStart = bean.flughafenSuchen(daten[3].trim());
            if (fhStart == null) {
                fhStart = new Flughafen();  //Start
                fhStart.setKuerzel(daten[3].trim());
                fhStart.setLand(daten[4]);
                fhStart.setStadt(daten[5]);
                bean.datensatzEinlesen(fhStart);
            }

            Flughafen fhLandung = bean.flughafenSuchen(daten[6].trim());
            if (fhLandung == null) {
                fhLandung = new Flughafen();  //Landung
                fhLandung.setKuerzel(daten[6].trim());
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
debug = "1";
            Fluggesellschaft fluggesellschaft = bean.fluggesellschaftSuchen(daten[0]);
            if (fluggesellschaft == null) {
                fluggesellschaft = new Fluggesellschaft();
                fluggesellschaft.setKuerzel(daten[0]);
                fluggesellschaft.setName(daten[1]);
                bean.datensatzEinlesen(fluggesellschaft);
            }
debug = "2";
            Buchungsdaten buchung = bean.buchungsdatenSuchen(Integer.parseInt(daten[16].trim()), daten[17].trim());
            if (buchung == null) {
                buchung = new Buchungsdaten();
                buchung.setBuchungsnr(Integer.parseInt(daten[16].trim()));
                String datumBuchung = daten[17].trim();
                buchung.setBuchungsdatum(datumBuchung);
            }

            Kunde kunde = bean.kundeSuchen(Integer.parseInt(daten[18]));
debug = "3";             if (kunde == null) {
                kunde.setId(Integer.parseInt(daten[18]));
debug = "4";                kunde.setAnrede(daten[19]);
debug = "5";                kunde.setNamen(daten[20]);
               kunde.setPlz(daten[21]);
                kunde.setOrt(daten[22]);
                kunde.setStrasse(daten[23]);
                kunde.setLand(daten[24]);
                kunde.hinzuBuchungen(buchung);
debug = "6";                bean.datensatzEinlesen(kunde);
            } else {
                kunde.hinzuBuchungen(buchung);
                bean.datensatzAktualisieren(kunde);
            }
debug = "7";
            Flug flug = bean.flugSuchen(fhStart.getKuerzel(), fhLandung.getKuerzel(), daten[10].trim());
            if (flug == null) {
                flug = new Flug();
                flug.setFhStart(fhStart);
                flug.setFhLandung(fhLandung);
                flug.hinzuBuchungsdaten(buchung);
                String datumFlug = daten[10].trim();
                flug.setFlugdatum(datumFlug);
                //flug.setDauer(daten[10]);
                String preis = daten[11].trim();
                flug.setPreis((Double.parseDouble(preis)));
                flug.setSitzeBelegt(Integer.parseInt(daten[14].trim()));
                flug.setSitzeGes(Integer.parseInt(daten[15].trim()));
                bean.datensatzEinlesen(flug);
            } else {
                flug.hinzuBuchungsdaten(buchung);
                bean.datensatzAktualisieren(flug);
            }

        } catch (Exception e) {
            debug2 = e.toString();
        }
    }
%>
