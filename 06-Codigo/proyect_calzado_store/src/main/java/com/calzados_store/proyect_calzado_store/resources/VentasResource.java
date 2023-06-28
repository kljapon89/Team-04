package com.calzados_store.proyect_calzado_store.resources;

import com.calzados_store.proyect_calzado_store.models.Venta;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import org.bson.Document;

import com.mongodb.MongoClient;
import com.mongodb.MongoClientURI;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;

@Path("/ventas")
public class VentasResource {

    private final MongoCollection<Document> collection;

    public VentasResource() {
        // Establecer la conexión con la base de datos
        MongoClient mongoClient = new MongoClient(new MongoClientURI("mongodb+srv://admin_db:tSAy7QHqmwcrAafy@cluster0.qltezap.mongodb.net/calzados_store?retryWrites=true&w=majority"));
        MongoDatabase database = mongoClient.getDatabase("calzados_store");
        collection = database.getCollection("ventas");
    }

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public List<Venta> obtenerVentas() {
        return StreamSupport.stream(collection.find().spliterator(), false)
                .map(this::mapVentaFromDocument)
                .collect(Collectors.toList());
    }

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    public Response agregarVenta(Venta venta) {
        Document document = mapDocumentFromVenta(venta);
        collection.insertOne(document);
        return Response.status(Response.Status.CREATED).build();
    }

    @PUT
    @Path("/{id}")
    @Consumes(MediaType.APPLICATION_JSON)
    public Response actualizarVenta(@PathParam("id") String id, Venta venta) {
        Document filter = new Document("_id", id);
        Document update = new Document("$set", mapDocumentFromVenta(venta));
        collection.updateOne(filter, update);
        return Response.status(Response.Status.OK).build();
    }

    @DELETE
    @Path("/{id}")
    public Response eliminarVenta(@PathParam("id") String id) {
        Document filter = new Document("_id", id);
        collection.deleteOne(filter);
        return Response.status(Response.Status.OK).build();
    }

private Venta mapVentaFromDocument(Document document) {
    String producto = document.getString("producto");
    Integer cantidadObj = document.getInteger("cantidad");
    Double precioTotalObj = document.getDouble("precioTotal");

    int cantidad = (cantidadObj != null) ? cantidadObj.intValue() : 0;
    double precioTotal = (precioTotalObj != null) ? precioTotalObj.doubleValue() : 0.0;

    return new Venta(producto, cantidad, precioTotal);
}


    private Document mapDocumentFromVenta(Venta venta) {
        return new Document()
                .append("producto", venta.getProducto())
                .append("cantidad", venta.getCantidad())
                .append("precioTotal", venta.getPrecioTotal());
    }
}
