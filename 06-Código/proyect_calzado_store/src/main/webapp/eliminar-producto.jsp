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

        if (id != null) {
            Document filter = new Document("_id", new org.bson.types.ObjectId(id));
            collection.deleteOne(filter);
        }

        response.sendRedirect("productos.jsp");
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
