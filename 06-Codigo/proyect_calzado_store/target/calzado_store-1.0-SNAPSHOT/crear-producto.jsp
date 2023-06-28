<%@ page import="com.mongodb.MongoClient" %>
<%@ page import="com.mongodb.MongoClientURI" %>
<%@ page import="com.mongodb.client.MongoCollection" %>
<%@ page import="com.mongodb.client.MongoDatabase" %>
<%@ page import="org.bson.Document" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>

<%
try (MongoClient mongoClient = new MongoClient(new MongoClientURI("mongodb+srv://admin_db:tSAy7QHqmwcrAafy@cluster0.qltezap.mongodb.net/calzados_store?retryWrites=true&w=majority"))) {
    MongoDatabase database = mongoClient.getDatabase("calzados_store");
    MongoCollection<Document> collection = database.getCollection("productos");

    String nombre = request.getParameter("nombre");
    int stock = Integer.parseInt(request.getParameter("stock"));
    String marca = request.getParameter("marca");
    double precio = Double.parseDouble(request.getParameter("precio"));

    Locale locale = new Locale("en", "US");
    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(locale);
    String precioFormatted = currencyFormat.format(precio);

    Document nuevoProducto = new Document()
            .append("nombre", nombre)
            .append("stock", stock)
            .append("marca", marca)
            .append("precio", precioFormatted);

    collection.insertOne(nuevoProducto);

    response.sendRedirect("productos.jsp");
} catch (Exception e) {
    e.printStackTrace();
}
%>
