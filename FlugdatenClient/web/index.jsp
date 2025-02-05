<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.flug.*,java.io.*,java.util.*, javax.naming.InitialContext,javax.naming.NamingException"%>
<!DOCTYPE html>
<%  Properties props; 
    InitialContext ctx=null;
    props = new Properties(); 
    try { 
        ctx = new InitialContext(props); 
    } 
    catch (NamingException ex) { 
 	ex.printStackTrace(); 
    }
    
    FlugdatenBeanRemote bean = (FlugdatenBeanRemote)ctx.lookup("FlugdatenBean/remote");
    BufferedReader buffi=null;
    try {
            buffi=new BufferedReader(new FileReader("C:\\Java\\KlausurJan17\\JavaApplication12\\fdtest.csv"));
        } catch (Exception e) {
        }
    String[] daten=buffi.readLine().split(";");
    //1 ID 2 Name 3 4 Linie 5 Flughafen 6 Land 7 Stadt 8 Flughafen 9 Land 10 Stadt 11 Dauer 12 Datum 13 Preis
    //14 Typ 15 Hersteller 16 Belegt 17 Gesamt 18 Nummer 19 Datum 20 Nummer 21 Anrede 22 Name 23 PLZ 24 Ort 25 Stra�e 26 Land
   /* Flughafen fhStart=new Flughafen();  //Start
    fhStart.setKuerzel(daten[4].trim());
    fhStart.setLand(daten[5]);
    fhStart.setStadt(daten[6]);

    Flughafen fhLandung=new Flughafen();  //Landung
    fhLandung.setKuerzel(daten[7].trim());
    fhLandung.setLand(daten[8]);
    fhLandung.setStadt(daten[9]);
        
    Flugzeug flugzeug=new Flugzeug();
    flugzeug.setTyp(daten[13]);
    flugzeug.setHersteller(daten[14]);
    
    Fluggesellschaft fluggesellschaft=new Fluggesellschaft();
    fluggesellschaft.setKuerzel(daten[0]);
    fluggesellschaft.setName(daten[1]);
    
    Buchungsdaten buchung=new Buchungsdaten();
    buchung.setBuchungsnr(Integer.parseInt(daten[17].trim()));
    String datumBuchung=daten[18].trim();
    //String tagBuchung=datumBuchung.substring(0,2);
    //String monatBuchung=datumBuchung.substring(3,5);
    //String jahrBuchung=datumBuchung.substring(6);
    //buchung.setBuchungsdatum(new GregorianCalendar(Integer.parseInt(jahrBuchung), Integer.parseInt(monatBuchung), Integer.parseInt(tagBuchung)));
    buchung.setBuchungsdatum(datumBuchung);
    buchung.setPassagiernr(Integer.parseInt(daten[19]));
    
    Kunde kunde=new Kunde();
    kunde.setAnrede(daten[20]);
    kunde.setNamen(daten[21]);
    kunde.setPlz(daten[22]);
    kunde.setOrt(daten[23]);
    kunde.setStrasse(daten[24]);
    kunde.setLand(daten[25]);
    List<Buchungsdaten> listeBuchungenKunde=new ArrayList<Buchungsdaten>();
    listeBuchungenKunde.add(buchung);
    kunde.setBuchungen(listeBuchungenKunde);
    
    Flug flug=new Flug();
    flug.setFhStart(fhStart);
    flug.setFhLandung(fhLandung);
    List<Buchungsdaten> listeBuchungenFlug=new ArrayList<Buchungsdaten>();
    listeBuchungenFlug.add(buchung);
    String datumFlug=daten[11].trim();
    //String tagFlug=datumFlug.substring(0,2);
    //String monatFlug=datumFlug.substring(3,5);
    //String jahrFlug=datumFlug.substring(6);
    //flug.setFlugdatum(new GregorianCalendar(Integer.parseInt(jahrFlug), Integer.parseInt(monatFlug), Integer.parseInt(tagFlug)));
    flug.setFlugdatum(datumFlug);
    flug.setBuchungsdaten(listeBuchungenFlug);
    //flug.setDauer(daten[10]);
    flug.setPreis(Double.parseDouble(daten[12].trim()));
    flug.setSitzeBelegt(Integer.parseInt(daten[15].trim()));
    flug.setSitzeGes(Integer.parseInt(daten[16].trim()));
    //flug.setLinie(daten[3]);
    
    bean.datensatzEinlesen(flug);*/
    
    //List<Flug> flugListe=bean.ausgeben();
    //Calendar kalender=new GregorianCalendar(2012, 9, 27);
    Flug flug1=bean.flugSuchen("FRA", "JFK","27.09.2012");
    //GregorianCalendar kalender=new GregorianCalendar(2012, 9, 27, 0, 0);
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
        <%=flug1%>

    </body>
</html>
