<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.flug.*,java.io.*,java.util.*, javax.naming.InitialContext, javax.naming.Context,javax.naming.NamingException"%>
<!DOCTYPE html>
<%! Properties props=null; 
    InitialContext ctx = null;
    FlugdatenBeanRemote bean = null; %>
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
    if (button != null) {
        if (button.equals("einlesen")) {
            datenEinlesen("C:\\Projektarbeit\\Test.csv");
        }
    }
    
    //vorläufige Ausgabe
    List<Flug> liste=null;
    try {
          liste=bean.ausgeben();  
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
            <input type="text" name="pfad">
            <input type="submit" name="button" value="einlesen">
        </form>
        <ul>
            <%=liste%>
        </ul>
    </body>
</html>

<%! public void datenEinlesen(String pfad) { //Daten werden aus .csv eingelesen und in Object[] zurückgegeben
        BufferedReader buffi = null;
        String[] daten = null;
        String zeile = null;
        try {
            buffi = new BufferedReader(new FileReader(pfad));
            //zeile = buffi.readLine();
            while ((zeile = buffi.readLine()) != null) {
                daten = zeile.split(";");
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
                Fluggesellschaft fluggesellschaft = bean.fluggesellschaftSuchen(daten[0]);
                if (fluggesellschaft == null) {
                    fluggesellschaft = new Fluggesellschaft();
                    fluggesellschaft.setKuerzel(daten[0]);
                    fluggesellschaft.setName(daten[1]);
                    bean.datensatzEinlesen(fluggesellschaft);
                }
                Buchungsdaten buchung = bean.buchungsdatenSuchen(Integer.parseInt(daten[16].trim()), bean.datumParsen(daten[17].trim()));
                if (buchung == null) {
                    buchung = new Buchungsdaten();
                    buchung.setBuchungsnr(Integer.parseInt(daten[16].trim()));
                    String datumBuchung = daten[17].trim();
                    buchung.setBuchungsdatum(bean.datumParsen(datumBuchung));
                }
                Kunde kunde = bean.kundeSuchen(Integer.parseInt(daten[18]));
                if (kunde == null) {
                    kunde = new Kunde();
                    kunde.setId(Integer.parseInt(daten[18]));
                    kunde.setAnrede(daten[19]);
                    kunde.setNamen(daten[20]);
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
                Flug flug = bean.flugSuchen(fhStart.getKuerzel(), fhLandung.getKuerzel(), bean.datumParsen(daten[10].trim()));
                if (flug == null) {
                    flug = new Flug();
                    flug.setFhStart(bean.flughafenSuchen(fhStart.getKuerzel()));
                    flug.setFhLandung(bean.flughafenSuchen(fhLandung.getKuerzel()));
                    flug.hinzuBuchungsdaten(bean.buchungsdatenSuchen(buchung.getBuchungsnr(), buchung.getBuchungsdatum()));
                    String datumFlug = daten[10].trim();
                    flug.setFlugdatum(bean.datumParsen(datumFlug));
                    //flug.setDauer(daten[10]);
                    String preis = daten[11].trim();
                    preis = preis.replaceFirst("[.]", "");
                    preis = preis.replace(',', '.');
                    flug.setPreis((Double.parseDouble(preis)));
                    flug.setSitzeBelegt(Integer.parseInt(daten[14].trim()));
                    flug.setSitzeGes(Integer.parseInt(daten[15].trim()));
                    flug.setFluggesellschaft(bean.fluggesellschaftSuchen(fluggesellschaft.getKuerzel()));
                    flug.setFlugzeug(bean.flugzeugSuchen(flugzeug.getHersteller(), flugzeug.getTyp()));
                    bean.datensatzEinlesen(flug);
                } else {
                    flug.hinzuBuchungsdaten(buchung);
                    bean.datensatzAktualisieren(flug);
                }
            }
        } catch (Exception e) {
            System.out.println(e.getStackTrace().toString());
        }
    }
%>
