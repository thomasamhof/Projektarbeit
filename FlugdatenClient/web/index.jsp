<%@page import="com.aspose.cells.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.flug.*,java.io.*,java.util.*, javax.naming.InitialContext, javax.naming.Context,javax.naming.NamingException"%>
<!DOCTYPE html>
<%! Properties props = null;
    InitialContext ctx = null;
    FlugdatenBeanRemote bean = null;  %>
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
    List<Kunde> liste = null;
    try {
        liste = bean.buchungsdatenSuchenT();
    } catch (NullPointerException npe) {
        out.println("noch keine Daten vorhanden");
    }

%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <style>
            body {
                height: 100vh;
                width: 100vw;
                padding: 20px;
                background: lightblue;
                color: darkblue;
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
                    out.println(datenEinlesen(pfad));
                }
            }%>
        <ul>
            <%=liste%>
        </ul>
    </body>
</html>

<%! public String datenEinlesen(String pfad) { //Daten werden aus .csv eingelesen und in Object[] zurückgegeben
        BufferedReader buffi = null;
        String[] daten = null;
        String zeile = null;
        int zaehlerNeuerKunde = 0;  //Anzahl neu angelegter Kunde
        int zaehlerNeuerFlug = 0;   //Anzahl neu angelegter Flüge
        int zaehlerDatensatz = 0;   //Anzahl eingelesener Zeilen
        String ausgabe = "";  //dient zur Ausgabe der Bestätigung bzw Fehlermeldung
        if (pfad.substring(pfad.lastIndexOf(".")).equals(".xls")) {
            try {
               xlsUmwandeln(pfad); 
            } catch (Exception e) {
            }
            pfad = pfad.substring(0, pfad.lastIndexOf(".")).concat(".csv");
        }
        try {
            buffi = new BufferedReader(new FileReader(pfad));
            //zeile = buffi.readLine();
            while ((zeile = buffi.readLine()) != null) {
                daten = zeile.split(";");
                String kuerzel=daten[0].replaceAll("[^A-Z]", "");
                if (!kuerzel.matches("[A-Z]{2}") || kuerzel.equals("ID")) {
                        continue;
                    }
                Fluggesellschaft fluggesellschaft = bean.fluggesellschaftSuchen(kuerzel);
                if (fluggesellschaft == null) {
                    fluggesellschaft = new Fluggesellschaft();
                    fluggesellschaft.setKuerzel(kuerzel);
                    fluggesellschaft.setName(daten[1]);
                    bean.datensatzEinlesen(fluggesellschaft);
                }
                Flughafen fhStart = bean.flughafenSuchen(daten[3].trim());
                if (fhStart == null) {
                    fhStart = new Flughafen();  //Start
                    fhStart.setKuerzel(daten[3]);
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
                Buchungsdaten buchung = bean.buchungsdatenSuchen(Integer.parseInt(daten[16].trim()), bean.datumParsen(daten[17].trim()));
                if (buchung == null) {
                    buchung = new Buchungsdaten();
                    buchung.setBuchungsnr(Integer.parseInt(daten[16].trim()));
                    String datumBuchung = daten[17].trim();
                    buchung.setBuchungsdatum(bean.datumParsen(datumBuchung));
                    bean.datensatzEinlesen(buchung);
                }
                Kunde kunde = bean.kundeSuchen(Integer.parseInt(daten[18]));
                if (kunde == null) {
                    kunde = new Kunde();
                    kunde.setId(Integer.parseInt(daten[18]));
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
                Flug flug = bean.flugSuchen(fhStart.getKuerzel(), fhLandung.getKuerzel(), bean.datumParsen(daten[10].trim()));
                if (flug == null) {
                    flug = new Flug();
                    flug.setFhStart(bean.flughafenSuchen(fhStart.getKuerzel()));
                    flug.setFhLandung(bean.flughafenSuchen(fhLandung.getKuerzel()));
                    flug.hinzuBuchungsdaten(bean.buchungsdatenSuchen(buchung.getBuchungsnr(), buchung.getBuchungsdatum()));
                    String datumFlug = daten[10].trim();
                    flug.setFlugdatum(bean.datumParsen(datumFlug));
                    flug.setDauer(bean.dauerParsen(daten[9].trim()));
                    flug.setLinie(daten[2]);
                    String preis = daten[11].trim();
                    preis = preis.replaceFirst("[.]", "");
                    preis = preis.replace(',', '.');
                    flug.setPreis((Double.parseDouble(preis)));
                    flug.setSitzeBelegt(Integer.parseInt(daten[14].trim()));
                    flug.setSitzeGes(Integer.parseInt(daten[15].trim()));
                    flug.setFluggesellschaft(bean.fluggesellschaftSuchen(fluggesellschaft.getKuerzel()));
                    flug.setFlugzeug(bean.flugzeugSuchen(flugzeug.getHersteller(), flugzeug.getTyp()));
                    bean.datensatzEinlesen(flug);
                    zaehlerNeuerFlug++;
                } else {
                    flug.hinzuBuchungsdaten(buchung);
                    bean.datensatzAktualisieren(flug); 
                }
                zaehlerDatensatz++;
            }
            ausgabe = String.format("Es wurden %d Zeilen eingelesen, dabei wurden %d Fluege und %d Kunden neu angelegt", zaehlerDatensatz, zaehlerNeuerFlug, zaehlerNeuerKunde);
        } catch (FileNotFoundException fnfe) {
            ausgabe = "Datei nicht gefunden.";
        } catch (Exception e) {
            ausgabe = "Unerwarteter Fehler" + e.getMessage();
        }

        return ausgabe;
    }
%>
<%! public void xlsUmwandeln(String pfad) throws Exception{
        Workbook buch = new Workbook(pfad);
        XlsSaveOptions opt=new XlsSaveOptions();

        buch.save(pfad.substring(0, pfad.lastIndexOf(".")).concat(".csv"));
    
} %>
