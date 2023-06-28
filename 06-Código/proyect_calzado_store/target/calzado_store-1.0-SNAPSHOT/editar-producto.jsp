<%@ page import="com.mongodb.MongoClient" %>
<%@ page import="com.mongodb.MongoClientURI" %>
<%@ page import="com.mongodb.client.MongoCollection" %>
<%@ page import="com.mongodb.client.MongoDatabase" %>
<%@ page import="org.bson.Document" %>

<%
    try (MongoClient mongoClient = new MongoClient(new MongoClientURI("mongodb+srv://admin_db:tSAy7QHqmwcrAafy@cluster0.qltezap.mongodb.net/calzados_store?retryWrites=true&w=majority"))) {
        MongoDatabase database = mongoClient.getDatabase("calzados_store");
        MongoCollection<Document> collection = database.getCollection("productos");

        String id = request.getParameter("id");
        String nombre = request.getParameter("nombre");
        int stock = Integer.parseInt(request.getParameter("stock"));
        String marca = request.getParameter("marca");
        double precio = Double.parseDouble(request.getParameter("precio"));

        // Construir el filtro para encontrar el producto a actualizar
        Document filtro = new Document("_id", new org.bson.types.ObjectId(id));

        // Construir los nuevos valores del producto
        Document nuevosValores = new Document()
                .append("nombre", nombre)
                .append("stock", stock)
                .append("marca", marca)
                .append("precio", precio);

        // Actualizar el producto en la base de datos
        collection.updateOne(filtro, new Document("$set", nuevosValores));

        response.sendRedirect("productos.jsp");
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
