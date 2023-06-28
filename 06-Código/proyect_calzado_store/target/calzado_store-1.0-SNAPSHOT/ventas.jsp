<%@ page import="com.mongodb.MongoClient" %>
<%@ page import="com.mongodb.MongoClientURI" %>
<%@ page import="com.mongodb.client.MongoCollection" %>
<%@ page import="com.mongodb.client.MongoDatabase" %>
<%@ page import="org.bson.Document" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Locale" %>
<%

    try {
        MongoClient mongoClient = new MongoClient(new MongoClientURI("mongodb+srv://admin_db:tSAy7QHqmwcrAafy@cluster0.qltezap.mongodb.net/calzados_store?retryWrites=true&w=majority"));
        MongoDatabase database = mongoClient.getDatabase("calzados_store");
        MongoCollection<Document> collection = database.getCollection("productos");

        // Obtener todos los productos
        List<Document> zapatos = collection.find().into(new ArrayList<>());

        // Obtener la fecha actual
        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault());
        Date fechaActual = new Date();
        String fecha = dateFormat.format(fechaActual);
%>


<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Formulario de Ventas</title>
        <link rel="stylesheet" href="https://cdn.datatables.net/1.10.25/css/jquery.dataTables.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css">
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
                            <a class="nav-link" href="./productos.jsp">Productos</a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>




        <div class="container py-4">
            <div class="container">

                <div class="row">
                    <div class="col-6">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Total Vendido en Productos</h5>
                                <p class="card-text" id="total-vendido"></p>
                            </div>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Total de Ventas por Día</h5>
                                <p class="card-text" id="total-ventas"></p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <button type="button" class="btn btn-primary py-2 mt-3" data-toggle="modal" data-target="#agregarVentaModal">Agregar Venta</button>
        </div>


        <div class="container py-3">
            <table id="ventas-table" class="table table-striped">
                <thead>
                    <tr>
                        <th>Fecha</th>
                        <th>Cédula</th>
                        <th>Nombre</th>
                        <th>Zapato</th>
                        <th>Precio (sin impuestos)</th>
                        <th>Precio (con IVA)</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        MongoCollection<Document> ventasCollection = database.getCollection("ventas");
                        List<Document> ventas = ventasCollection.find().into(new ArrayList<>());

                        NumberFormat currencyFormat = NumberFormat.getCurrencyInstance();

                        for (Document venta : ventas) {
                            String ventaFecha = venta.getString("fecha");
                            String ventaCedula = venta.getString("cedula");
                            String ventaNombre = venta.getString("nombre");
                            String ventaZapato = venta.getString("zapato");
                            double ventaPrecio = venta.getDouble("precio");
                            double ventaPrecioIVA = venta.getDouble("precioIVA");

                            out.println("<tr>");
                            out.println("<td>" + ventaFecha + "</td>");
                            out.println("<td>" + ventaCedula + "</td>");
                            out.println("<td>" + ventaNombre + "</td>");
                            out.println("<td>" + ventaZapato + "</td>");
                            out.println("<td>" + currencyFormat.format(ventaPrecio) + "</td>");
                            out.println("<td>" + currencyFormat.format(ventaPrecioIVA) + "</td>");
                            out.println("</tr>");
                        }
                    %>
                </tbody>
            </table>
        </div>

        <!-- Modal para agregar venta -->
        <div class="modal fade" id="agregarVentaModal" tabindex="-1" role="dialog" aria-labelledby="agregarVentaModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="agregarVentaModalLabel">Agregar Venta</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <!-- Formulario de venta -->
                        <form method="POST" action="registrar-venta.jsp" onsubmit="setDefaultValues()">
                            <div class="form-group">
                                <label for="cedula">Identificación del cliente:</label>
                                <input type="text" class="form-control" id="cedula" name="cedula" placeholder="Ingrese la cédula del cliente">
                            </div>
                            <div class="form-group">
                                <label for="nombre">Nombre del cliente:</label>
                                <input type="text" class="form-control" id="nombre" name="nombre" placeholder="Ingrese el nombre del cliente">
                            </div>
                            <div class="form-group">
                                <label for="zapato">Zapato:</label>
                                <select class="form-control" id="zapato" name="zapato" onchange="actualizarPrecio()">
                                    <option value="">Seleccione un zapato</option>
                                    <% for (Document zapato : zapatos) {%>
                                    <option value="<%= zapato.getString("nombre")%>" data-precio="<%= zapato.getDouble("precio")%>"><%= zapato.getString("nombre")%></option>
                                    <% } %>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="nombre-zapato">Nombre del zapato:</label>
                                <span id="nombre-zapato"></span>
                            </div>
                            <div class="form-group">
                                <label for="precio">Precio (sin impuestos):</label>
                                <input type="text" class="form-control" id="precio" name="precio" placeholder="Ingrese el precio sin impuestos">
                            </div>
                            <div class="form-group">
                                <label for="precio-iva">Precio (con IVA 12%):</label>
                                <input type="text" class="form-control" id="precio-iva" name="precio-iva" readonly>
                            </div>


                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cerrar</button>
                        <button type="submit" class="btn btn-primary">Registrar Venta</button>
                    </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.14.3/dist/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
    <script src="https://cdn.datatables.net/1.10.25/js/jquery.dataTables.min.js"></script>


    <script>

                                    $(document).ready(function () {
                                        $('#ventas-table').DataTable();
                                    });

                                    function setDefaultValues() {
                                        var cedulaElement = document.getElementById("cedula");
                                        var nombreElement = document.getElementById("nombre");

                                        if (cedulaElement.value === "") {
                                            cedulaElement.value = "00000000000000000000000000";
                                        }

                                        if (nombreElement.value === "") {
                                            nombreElement.value = "Consumidor Final";
                                        }
                                    }

                                    function actualizarPrecio() {
                                        var selectElement = document.getElementById("zapato");
                                        var precioElement = document.getElementById("precio");
                                        var precioIVAElement = document.getElementById("precio-iva");

                                        var selectedOption = selectElement.options[selectElement.selectedIndex];
                                        var nombreZapato = selectedOption.textContent;
                                        var precio = parseFloat(selectedOption.getAttribute("data-precio"));

                                        precioElement.value = precio.toFixed(2);
                                        precioIVAElement.value = (precio * 1.12).toFixed(2);

                                        // Mostrar el nombre del zapato
                                        var nombreElement = document.getElementById("nombre-zapato");
                                        nombreElement.textContent = nombreZapato;
                                    }


                                    function actualizarValores() {
                                        calcularTotalVendido();
                                        actualizarTotalVentas();
                                    }

                                    function calcularTotalVendido() {
                                        var ventasTable = document.getElementById("ventas-table");
                                        var filas = ventasTable.getElementsByTagName("tr");
                                        var totalVendido = 0;

                                        for (var i = 1; i < filas.length; i++) {
                                            var celdas = filas[i].getElementsByTagName("td");
                                            var ventaPrecio = parseFloat(celdas[5].textContent.replace(/[^0-9,-]+/g, "").replace(",", "."));
                                            totalVendido += ventaPrecio;
                                        }

                                        document.getElementById("total-vendido").textContent = "$" + totalVendido.toFixed(2);
                                    }



                                    function actualizarTotalVentas() {
                                        var fechaActual = getFechaActual();
                                        var totalVentas = getTotalVentasPorFecha(fechaActual);
                                        document.getElementById("total-ventas").textContent = totalVentas;
                                    }

                                    function getFechaActual() {
                                        var fechaActual = new Date();
                                        var anio = fechaActual.getFullYear();
                                        var mes = (fechaActual.getMonth() + 1).toString().padStart(2, "0");
                                        var dia = fechaActual.getDate().toString().padStart(2, "0");
                                        var fecha = anio + "-" + mes + "-" + dia;

                                        return fecha;
                                    }

                                    function getTotalVentasPorFecha(fecha) {
                                        var ventasTable = document.getElementById("ventas-table");
                                        var filas = ventasTable.getElementsByTagName("tr");
                                        var total = 0;

                                        for (var i = 1; i < filas.length; i++) {
                                            var celdas = filas[i].getElementsByTagName("td");
                                            var ventaFecha = celdas[0].textContent;

                                            if (ventaFecha === fecha) {
                                                total++;
                                            }
                                        }

                                        return total;
                                    }

                                    // Inicializar los valores al cargar la página
                                    actualizarValores();
    </script>
</body>
</html>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
