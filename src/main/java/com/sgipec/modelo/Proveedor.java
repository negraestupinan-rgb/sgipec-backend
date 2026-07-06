package com.sgipec.modelo;

/**
 * Modelo de Proveedor para el SGIPEC.
 * Representa a un proveedor externo que solicita ingreso al establecimiento carcelario.
 *
 * @author Heydi Estupiñán Estupiñán
 * @version 1.0
 */
public class Proveedor {

    private int idProveedor;
    private String cedula;
    private String nombre;
    private String empresa;
    private String email;
    private String telefono;
    private String estado; // Pendiente, Activo, Inactivo

    // Constructor vacío
    public Proveedor() {
        this.estado = "Pendiente";
    }

    // Constructor completo
    public Proveedor(int idProveedor, String cedula, String nombre,
String empresa, String email, String telefono) {
        this.idProveedor = idProveedor;
        this.cedula = cedula;
        this.nombre = nombre;
        this.empresa = empresa;
        this.email = email;
        this.telefono = telefono;
        this.estado = "Pendiente";
    }

    // Getters y Setters
    public int getIdProveedor() { return idProveedor; }
    public void setIdProveedor(int idProveedor) { this.idProveedor = idProveedor; }

    public String getCedula() { return cedula; }
    public void setCedula(String cedula) { this.cedula = cedula; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getEmpresa() { return empresa; }
    public void setEmpresa(String empresa) { this.empresa = empresa; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    @Override
    public String toString() {
        return "Proveedor{" +
                "idProveedor=" + idProveedor +
                ", cedula='" + cedula + '\'' +
                ", nombre='" + nombre + '\'' +
                ", empresa='" + empresa + '\'' +
                ", estado='" + estado + '\'' +
                '}';
    }
}
