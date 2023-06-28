package com.calzados_store.proyect_calzado_store.models;

public class Producto {
    private String nombre;
    private double precio;

    public Producto() {
        // Constructor vacío requerido para deserialización JSON
    }

    public Producto(String nombre, double precio) {
        this.nombre = nombre;
        this.precio = precio;
    }

    // Getters y setters

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public double getPrecio() {
        return precio;
    }

    public void setPrecio(double precio) {
        this.precio = precio;
    }
}
