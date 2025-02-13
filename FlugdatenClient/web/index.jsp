<%@page import="com.aspose.cells.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.flug.*,java.io.*,java.util.*, javax.naming.InitialContext, javax.naming.Context,javax.naming.NamingException"%>
<!DOCTYPE html>
<%! Properties props = null;
    InitialContext ctx = null;
    FlugdatenBeanRemote bean = null;
    int zaehlerNeuerKunde;  //Anzahl neu angelegter Kunde
    int zaehlerNeuerFlug;   //Anzahl neu angelegter Flüge
    int zaehlerDatensatz;
%>
<%  props = new Properties();
    props.put(Context.URL_PKG_PREFIXES, "org.jboss.ejb.client.naming");
    props.put("jboss.naming.client.ejb.context", true);
    props.put(Context.PROVIDER_URL, "http-remoting://localhost:8080");

    try {
        ctx = new InitialContext(props);
    } catch (NamingException ex) {
        ex.printStackTrace();
    }
    bean = (FlugdatenBeanRemote) ctx.lookup("ejb:Projektarbeit/FlugdatenBean/FlugdatenBean!com.flug.FlugdatenBeanRemote");

    String button = request.getParameter("button");
    String pfad = request.getParameter("pfad");

    //vorläufige Ausgabe
    List<Flug> liste = null;

%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Flugbuchungen</title>
        <style>
            body {
                min-height: 100vh;
                max-width: 100vw;
                padding: 20px;
                background: lightblue;
                color: darkblue;
            }

            ul {
                padding: 0;
            }
        </style>
    </head>
    <body>
        <h1>Flugbuchungen</h1>
        <form action="index.jsp" method="get">
            <input type="text" name="pfad" value="Pfad angeben">
            <input type="submit" name="button" value="einlesen">
        </form>
        <% if (button != null && !pfad.equals("Pfad angeben")) {
                if (button.equals("einlesen")) {
                    dateiPruefen(pfad);
                    String ausgabe = String.format("Es wurden %d Datensätze eingelesen<br>dabei wurden %d Flüge und %d Kunden angelegt", zaehlerDatensatz, zaehlerNeuerFlug, zaehlerNeuerKunde);
                    out.println(ausgabe);
                }
            }%>

        <ul>
            <%
                try {
                    liste = bean.ausgeben();
                } catch (NullPointerException npe) {
                    out.println("noch keine Daten vorhanden");
                }%>
            <%=liste%>
        </ul>
    </body>
</html>

<%! public void dateiPruefen(String pfad) {
        zaehlerNeuerKunde = 0;  //Anzahl neu angelegter Kunde
        zaehlerNeuerFlug = 0;   //Anzahl neu angelegter Flüge
        zaehlerDatensatz = 0;
        try {
            if (pfad.substring(pfad.lastIndexOf(".")).equals(".xls")) {
                xlsEinlesen(pfad);
            } else if (pfad.substring(pfad.lastIndexOf(".")).equals(".csv")) {
                csvEinlesen(pfad);
            } else {
                //unbekanntest Dateiformat
            }
        } catch (Exception e) {
        }
    }

    public String datenEinlesen(String[] daten) { //Daten werden aus .csv eingelesen und in Object[] zurückgegeben
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
                zaehlerNeuerKunde++;
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
                zaehlerNeuerFlug++;
            } else {
                flug.hinzuBuchungsdaten(buchung);
                bean.datensatzAktualisieren(flug);
            }
            zaehlerDatensatz++;
        } catch (Exception e) {
            //ausgabe = "Unerwarteter Fehler" + e.getMessage();
            System.out.println("hier");
        }
        System.out.println("nach dem catch");
        return "";
    }
%>
<%! public void xlsEinlesen(String pfad) throws Exception {
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
            datenEinlesen(daten);
        }
    }

    public void csvEinlesen(String pfad) {
        BufferedReader buffi = null;
        String[] daten = new String[25];
        String zeile = "";
        try {
            buffi = new BufferedReader(new FileReader(pfad));
            while ((zeile = buffi.readLine()) != null) {
                daten = zeile.split(";");
                daten[0] = daten[0].replaceAll("[^A-Z]", "");
                if (!daten[0].matches("[A-Z]{2}") || daten[0].equals("ID")) {
                    continue;
                }
                for (String string : daten) {
                    string = string.trim();
                }
                datenEinlesen(daten);

            }
        } catch (FileNotFoundException fnfe) {

        } catch (Exception e) {

        }
    }
%>
