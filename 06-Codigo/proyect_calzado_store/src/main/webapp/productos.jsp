<%@ page import="com.mongodb.MongoClient" %>
<%@ page import="com.mongodb.MongoClientURI" %>
<%@ page import="com.mongodb.client.MongoCollection" %>
<%@ page import="com.mongodb.client.MongoDatabase" %>
<%@ page import="org.bson.Document" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>

<%
    Locale locale = new Locale("en", "US");
    NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(locale);
%>

<%
    try (MongoClient mongoClient = new MongoClient(new MongoClientURI("mongodb+srv://admin_db:tSAy7QHqmwcrAafy@cluster0.qltezap.mongodb.net/calzados_store?retryWrites=true&w=majority"))) {
        MongoDatabase database = mongoClient.getDatabase("calzados_store");
        MongoCollection<Document> collection = database.getCollection("productos");

        // Obtener todos los productos
        List<Document> productos = collection.find().into(new ArrayList<>());

%>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>CRUD de Productos</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/jquery.dataTables.min.css">

</head>
<body>
    
    <style>
        .bg-custom {
            background: #29363c;
        }
        
        .navbar-brand {
            color: #fff;
            font-weight: 600;
            font-size: 32px;
        }
        
        .nav-link {
            color: #fff;
        }
    </style>
    
    <nav class="navbar navbar-expand-lg bg-custom">
        <div class="container">
             <a class="navbar-brand" href="#">Calzado Store</a>
<div class="collapse navbar-collapse" id="navbarSupportedContent">
    <ul class="navbar-nav ml-auto">
      <li class="nav-item active">
        <a class="nav-link" href="./ventas.jsp">Ventas</a>
      </li>
 
  </div>
        </div>
</nav>

    <div class="container py-5">

        
        <!-- Botón modal para crear un nuevo producto -->
        <button type="button" class="btn btn-primary mb-4" data-toggle="modal" data-target="#crearProductoModal">Crear Nuevo Producto</button>

        <!-- Modal de Creación -->
        <div class="modal fade" id="crearProductoModal" tabindex="-1" role="dialog" aria-labelledby="crearProductoModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="crearProductoModalLabel">Crear Nuevo Producto</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <form method="POST" action="crear-producto.jsp">
                            <div class="form-group">
                                <label for="nombre">Nombre:</label>
                                <input type="text" class="form-control" id="nombre" name="nombre" required>
                            </div>
                            <div class="form-group">
                                <label for="stock">Stock:</label>
                                <input type="number" class="form-control" id="stock" name="stock" required>
                            </div>
                            <div class="form-group">
                                <label for="marca">Marca:</label>
                                <input type="text" class="form-control" id="marca" name="marca" required>
                            </div>
                            <div class="form-group">
                                <label for="precio">Precio:</label>
                                <input type="number" step="0.01" class="form-control" id="precio" name="precio" required>
                            </div>
                            <button type="submit" class="btn btn-primary">Crear</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

 
                <div class="container">
                     <table id="productosTable" class="display">
            <thead>
                <tr>
                    <th>Nombre</th>
                    <th>Stock</th>
                    <th>Marca</th>
                    <th>Precio</th>
                    <th>Opciones</th>
                </tr>
            </thead>
            <tbody>
                <% for (Document producto : productos) { %>
                    <tr>
                        <td><%= producto.getString("nombre") %></td>
                        <td><%= producto.getInteger("stock") %></td>
                        <td><%= producto.getString("marca") %></td>
                        <td><%= currencyFormatter.format(producto.getDouble("precio")) %></td>
                        <td>
                            <div class="btn-group" role="group" aria-label="Opciones">
                                <form method="POST" action="eliminar-producto.jsp" onsubmit="return confirm('¿Estás seguro de eliminar este producto?')">
                                    <input type="hidden" name="id" value="<%= producto.getObjectId("_id").toString() %>">
                                    <button type="submit" class="btn btn-danger px-2">Eliminar</button>
                                </form>
                                <button type="button" class="btn btn-primary ml-3" data-toggle="modal" data-target="#editarProductoModal<%= producto.getObjectId("_id").toString() %>">Editar</button>
                            </div>
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>
                </div>

     
        <!-- Modal de Edición -->
        <% for (Document producto : productos) { %>
            <div class="modal fade" id="editarProductoModal<%= producto.getObjectId("_id").toString() %>" tabindex="-1" role="dialog" aria-labelledby="editarProductoModalLabel<%= producto.getObjectId("_id").toString() %>" aria-hidden="true">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="editarProductoModalLabel<%= producto.getObjectId("_id").toString() %>">Editar Producto</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <form method="POST" action="editar-producto.jsp">
                                <input type="hidden" name="id" value="<%= producto.getObjectId("_id").toString() %>">
                                <div class="form-group">
                                    <label for="nombre<%= producto.getObjectId("_id").toString() %>">Nombre:</label>
                                    <input type="text" class="form-control" id="nombre<%= producto.getObjectId("_id").toString() %>" name="nombre" value="<%= producto.getString("nombre") %>" required>
                                </div>
                                <div class="form-group">
                                    <label for="stock<%= producto.getObjectId("_id").toString() %>">Stock:</label>
                                    <input type="number" class="form-control" id="stock<%= producto.getObjectId("_id").toString() %>" name="stock" value="<%= producto.getInteger("stock") %>" required>
                                </div>
                                <div class="form-group">
                                    <label for="marca<%= producto.getObjectId("_id").toString() %>">Marca:</label>
                                    <input type="text" class="form-control" id="marca<%= producto.getObjectId("_id").toString() %>" name="marca" value="<%= producto.getString("marca") %>" required>
                                </div>
                                <div class="form-group">
                                    <label for="precio<%= producto.getObjectId("_id").toString() %>">Precio:</label>
                                    <input type="number" step="0.01" class="form-control" id="precio<%= producto.getObjectId("_id").toString() %>" name="precio" value="<%= producto.getDouble("precio") %>" required>
                                </div>
                                <button type="submit" class="btn btn-primary">Guardar Cambios</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        <% } %>
        
     <div class="row py-3">
            <!-- Suma total de stock -->
            <div class="col-6">
                <div class="card mb-3">
                    <div class="card-header">
                        Suma Total de Stock
                    </div>
                    <div class="card-body">
                        <h5 class="card-title">
                            <% int totalStock = 0;
                               for (Document producto : productos) {
                                   totalStock += producto.getInteger("stock");
                               }
                               out.println(totalStock); %>
                        </h5>
                    </div>
                </div>
            </div>

            <!-- Suma total de precios -->
            <div class="col-6">
                <div class="card mb-3">
                    <div class="card-header">
                        Suma Total de Precios
                    </div>
                    <div class="card-body">
                        <h5 class="card-title">
                            <% double totalPrecio = 0;
                               for (Document producto : productos) {
                                   totalPrecio += producto.getDouble("precio");
                               }
                               out.println(currencyFormatter.format(totalPrecio)); %>
                        </h5>
                    </div>
                </div>
            </div>
        </div>
        <script src="https://code.jquery.com/jquery-3.5.1.js"></script> 
        <script src="https://cdn.jsdelivr.net/npm/popper.js@1.14.3/dist/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
        <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
        
        <script>
            $(document).ready(function() {
            $('#productosTable').DataTable({
                language: {
                    "sProcessing": "Procesando...",
                    "sLengthMenu": "Mostrar _MENU_ registros",
                    "sZeroRecords": "No se encontraron resultados",
                    "sEmptyTable": "No hay datos para mostrar en la tabla",
                    "sInfo": "Mostrando registros del _START_ al _END_ de un total de _TOTAL_ registros",
                    "sInfoEmpty": "Mostrando registros del 0 al 0 de un total de 0 registros",
                    "sInfoFiltered": "(filtrado de un total de _MAX_ registros)",
                    "sInfoPostFix": "",
                    "sSearch": "Buscar:",
                    "sUrl": "",
                    "sInfoThousands": ",",
                    "sLoadingRecords": "Cargando...",
                    "oPaginate": {
                        "sFirst": "Primero",
                        "sLast": "Último",
                        "sNext": "Siguiente",
                        "sPrevious": "Anterior"
                    },
                    "oAria": {
                        "sSortAscending": ": Activar para ordenar la columna de manera ascendente",
                        "sSortDescending": ": Activar para ordenar la columna de manera descendente"
                    }
                }
            });
        });
        </script>
    </body>
    </html>

    
    
    <%
        } catch (Exception e) {
            e.printStackTrace();
        }
    %>
    
