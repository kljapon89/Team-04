<%@ page import="com.mongodb.MongoClient" %>
<%@ page import="com.mongodb.MongoClientURI" %>
<%@ page import="com.mongodb.client.MongoCollection" %>
<%@ page import="com.mongodb.client.MongoDatabase" %>
<%@ page import="org.bson.Document" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Locale" %>
<%

    try {
        MongoClient mongoClient = new MongoClient(new MongoClientURI("mongodb+srv://admin_db:tSAy7QHqmwcrAafy@cluster0.qltezap.mongodb.net/calzados_store?retryWrites=true&w=majority"));
        MongoDatabase database = mongoClient.getDatabase("calzados_store");
        MongoCollection<Document> collection = database.getCollection("ventas");

        // Obtener los datos del formulario
        String cedula = request.getParameter("cedula");
        String nombre = request.getParameter("nombre");
        String zapato = request.getParameter("zapato");
        double precio = Double.parseDouble(request.getParameter("precio"));
        double precioIVA = Double.parseDouble(request.getParameter("precio-iva"));

        // Obtener la fecha actual
        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault());
        Date fechaActual = new Date();
        String fecha = dateFormat.format(fechaActual);

        // Crear el documento de venta
        Document venta = new Document();
        venta.append("cedula", cedula)
             .append("nombre", nombre)
             .append("zapato", zapato)
             .append("precio", precio)
             .append("precioIVA", precioIVA)
             .append("fecha", fecha);

        // Insertar la venta en la colección
        collection.insertOne(venta);

        // Cerrar la conexión a la base de datos
        mongoClient.close();

        // Redireccionar a una página de confirmación
        response.sendRedirect("ventas.jsp");

    } catch (Exception e) {
        e.printStackTrace();
    }
%>
