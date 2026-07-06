package co.sgipec.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * @file    ConexionDB.java
 * @package co.sgipec.db
 *
 * @description Clase que implementa el patrón de diseño Singleton para
 *              gestionar la conexión JDBC con la base de datos MySQL del
 *              sistema SGIPEC (sistema_carcelario).
 *
 *              El patrón Singleton garantiza que exista una única instancia
 *              de la conexión durante todo el ciclo de vida de la aplicación,
 *              evitando el agotamiento de recursos del servidor MySQL y
 *              centralizando la configuración de acceso a datos.
 *
 * @author  Heydi Estupiñan Estupiñán
 * @version 1.0.0
 * @since   2026
 *
 * Proyecto: SGIPEC — Sistema de Gestión de Ingresos de Proveedores
 *           en Establecimiento Carcelario
 * SENA ADSO — Ficha 3186650
 */
public class ConexionDB {

    // ── Constantes de configuración de la conexión ─────────────────────
    /** Driver JDBC del conector oficial de MySQL */
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    /** URL de conexión a la base de datos MySQL del SGIPEC */
    private static final String URL =
        "jdbc:mysql://localhost:3306/sistema_carcelario"
        + "?useSSL=false"
        + "&serverTimezone=America/Bogota"
        + "&characterEncoding=UTF-8"
        + "&allowPublicKeyRetrieval=true";

    /** Usuario de la base de datos MySQL */
    private static final String USUARIO = "root";

    /** Contraseña de la base de datos MySQL.
     *  En producción, cargar desde variables de entorno o archivo .properties */
    private static final String CLAVE = "";

    // ── Instancia única del Singleton ───────────────────────────────────
    /** Referencia estática a la única instancia de la clase */
    private static ConexionDB instancia;

    /** Objeto Connection de JDBC que representa la conexión activa */
    private Connection conexion;

    // ── Constructor privado — impide instanciación externa ──────────────

    /**
     * Constructor privado del Singleton.
     * Registra el driver JDBC y establece la conexión con MySQL.
     *
     * @throws RuntimeException si no se puede establecer la conexión
     */
    private ConexionDB() {
        try {
            // Cargar el driver JDBC de MySQL en memoria
            Class.forName(DRIVER);

            // Establecer la conexión con la BD sistema_carcelario
            this.conexion = DriverManager.getConnection(URL, USUARIO, CLAVE);

            System.out.println("[SGIPEC] Conexión a MySQL establecida — BD: sistema_carcelario");

        } catch (ClassNotFoundException e) {
            throw new RuntimeException(
                "[SGIPEC] Error: Driver MySQL no encontrado. "
                + "Verifique que mysql-connector-j está en el classpath.",
                e
            );
        } catch (SQLException e) {
            throw new RuntimeException(
                "[SGIPEC] Error al conectar con MySQL: " + e.getMessage()
                + " | Código SQL: " + e.getSQLState(),
                e
            );
        }
    }

    // ── Método de acceso a la instancia única ───────────────────────────

    /**
     * Retorna la instancia única de ConexionDB (Singleton).
     * Si la conexión no existe o está cerrada, crea una nueva.
     *
     * @return la instancia única de ConexionDB
     */
    public static ConexionDB obtenerInstancia() {
        try {
            // Verificar si la instancia existe y si la conexión está activa
            if (instancia == null || instancia.conexion.isClosed()) {
                instancia = new ConexionDB();
            }
        } catch (SQLException e) {
            // Si isClosed() lanza excepción, recrear la instancia
            instancia = new ConexionDB();
        }
        return instancia;
    }

    /**
     * Retorna el objeto Connection de JDBC para ejecutar consultas SQL.
     *
     * @return objeto {@link Connection} activo con MySQL
     */
    public Connection getConexion() {
        return this.conexion;
    }

    /**
     * Cierra la conexión JDBC con MySQL y libera los recursos.
     * Debe llamarse al cerrar la aplicación.
     */
    public void cerrarConexion() {
        if (this.conexion != null) {
            try {
                if (!this.conexion.isClosed()) {
                    this.conexion.close();
                    System.out.println("[SGIPEC] Conexión a MySQL cerrada correctamente.");
                }
            } catch (SQLException e) {
                System.err.println("[SGIPEC] Error al cerrar conexión: " + e.getMessage());
            }
        }
    }
}