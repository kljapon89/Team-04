package com.calzados_store.proyect_calzado_store.resources;

import com.calzados_store.proyect_calzado_store.models.Producto;
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

@Path("/productos")
public class ProductosResource {

    private MongoClient mongoClient;
    private MongoDatabase database;
    private MongoCollection<Document> collection;

    public ProductosResource() {
        // Establecer la conexión con la base de datos
        mongoClient = new MongoClient(new MongoClientURI("mongodb+srv://admin_db:tSAy7QHqmwcrAafy@cluster0.qltezap.mongodb.net/calzados_store?retryWrites=true&w=majority"));
        database = mongoClient.getDatabase("calzados_store");
        collection = database.getCollection("productos");
    }

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public List<Producto> obtenerProductos() {
        List<Producto> productos = new ArrayList<>();
        List<Document> productosDocument = collection.find().into(new ArrayList<>());

        for (Document productoDocument : productosDocument) {
            String nombre = productoDocument.getString("nombre");
            double precio = productoDocument.getDouble("precio");

            Producto producto = new Producto(nombre, precio);
            productos.add(producto);
        }

        return productos;
    }

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    public Response agregarProducto(Producto producto) {
        Document document = new Document()
                .append("nombre", producto.getNombre())
                .append("precio", producto.getPrecio());

        collection.insertOne(document);

        return Response.status(Response.Status.CREATED).build();
    }

    @PUT
    @Path("/{id}")
    @Consumes(MediaType.APPLICATION_JSON)
    public Response actualizarProducto(@PathParam("id") String id, Producto producto) {
        Document filter = new Document("_id", id);
        Document update = new Document("$set", new Document("nombre", producto.getNombre()).append("precio", producto.getPrecio()));

        collection.updateOne(filter, update);

        return Response.status(Response.Status.OK).build();
    }

    @DELETE
    @Path("/{id}")
    public Response eliminarProducto(@PathParam("id") String id) {
        Document filter = new Document("_id", id);

        collection.deleteOne(filter);

        return Response.status(Response.Status.OK).build();
    }
}
