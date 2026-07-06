package com.sgipec.servlet;

import com.sgipec.modelo.Proveedor;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Servlet para el registro y consulta de proveedores del SGIPEC.
 * Maneja los métodos HTTP GET y POST.
 *
 * GET  → Muestra el formulario de registro o la lista de proveedores.
 * POST → Procesa el registro de un nuevo proveedor.
 *
 * URL: /RegistroProveedor
 *
 * @author Heydi Estupiñán Estupiñán
 * @version 1.0
 */
@WebServlet("/RegistroProveedor")
public class RegistroProveedorServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    /**
     * Método GET:
     * Muestra el formulario de registro de proveedor.
     * También recupera la lista de proveedores registrados en la sesión
     * para mostrarla en la vista JSP.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Establecer codificación de caracteres
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // Obtener la sesión actual o crear una nueva
        HttpSession session = request.getSession(true);

        // Recuperar la lista de proveedores de la sesión
        // (simula la base de datos para efectos del módulo)
        @SuppressWarnings("unchecked")
        List<Proveedor> listaProveedores =
                (List<Proveedor>) session.getAttribute("listaProveedores");

        if (listaProveedores == null) {
            listaProveedores = new ArrayList<>();
            session.setAttribute("listaProveedores", listaProveedores);
        }

        // Enviar la lista a la vista JSP mediante atributo de request
        request.setAttribute("proveedores", listaProveedores);
        request.setAttribute("accion", "formulario");

        // Redirigir al JSP de registro de proveedores
        request.getRequestDispatcher("/jsp/registroProveedor.jsp")
               .forward(request, response);
    }

    /**
     * Método POST:
     * Procesa los datos del formulario de registro de proveedor.
     * Valida los campos, crea el objeto Proveedor y lo guarda en sesión.
     * Redirige a la vista con mensaje de éxito o error.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Establecer codificación
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // ── Capturar parámetros del formulario ──────────────────────────────
        String cedula    = request.getParameter("cedula");
        String nombre    = request.getParameter("nombre");
        String empresa   = request.getParameter("empresa");
        String email     = request.getParameter("email");
        String telefono  = request.getParameter("telefono");

        // ── Validación básica de campos obligatorios ────────────────────────
        if (cedula == null || cedula.trim().isEmpty() ||
            nombre == null || nombre.trim().isEmpty() ||
            empresa == null || empresa.trim().isEmpty() ||
            email == null || email.trim().isEmpty()) {

            request.setAttribute("error", "Todos los campos obligatorios deben ser diligenciados.");
            request.setAttribute("accion", "formulario");
            request.getRequestDispatcher("/jsp/registroProveedor.jsp")
                   .forward(request, response);
            return;
        }

        // ── Validación de cédula (solo números, 6 a 10 dígitos) ─────────────
        if (!cedula.matches("^[0-9]{6,10}$")) {
            request.setAttribute("error", "La cédula debe contener entre 6 y 10 dígitos numéricos.");
            request.setAttribute("accion", "formulario");
            request.getRequestDispatcher("/jsp/registroProveedor.jsp")
                   .forward(request, response);
            return;
        }

        // ── Crear objeto Proveedor ──────────────────────────────────────────
        HttpSession session = request.getSession(true);

        @SuppressWarnings("unchecked")
        List<Proveedor> listaProveedores =
                (List<Proveedor>) session.getAttribute("listaProveedores");

        if (listaProveedores == null) {
            listaProveedores = new ArrayList<>();
        }

        // Verificar si ya existe un proveedor con esa cédula
        boolean cedulaDuplicada = listaProveedores.stream()
                .anyMatch(p -> p.getCedula().equals(cedula.trim()));

        if (cedulaDuplicada) {
            request.setAttribute("error", "Ya existe un proveedor registrado con esa cédula.");
            request.setAttribute("accion", "formulario");
            request.getRequestDispatcher("/jsp/registroProveedor.jsp")
                   .forward(request, response);
            return;
        }

        // Crear y registrar el nuevo proveedor
        Proveedor nuevoProveedor = new Proveedor();
        nuevoProveedor.setIdProveedor(listaProveedores.size() + 1);
        nuevoProveedor.setCedula(cedula.trim());
        nuevoProveedor.setNombre(nombre.trim());
        nuevoProveedor.setEmpresa(empresa.trim());
        nuevoProveedor.setEmail(email.trim());
        nuevoProveedor.setTelefono(telefono != null ? telefono.trim() : "");
        nuevoProveedor.setEstado("Pendiente");

        listaProveedores.add(nuevoProveedor);
        session.setAttribute("listaProveedores", listaProveedores);

        // ── Enviar mensaje de éxito y lista actualizada a la vista ──────────
        request.setAttribute("mensaje", "Proveedor " + nombre.trim() +
                " registrado exitosamente con estado: Pendiente.");
        request.setAttribute("proveedores", listaProveedores);
        request.setAttribute("accion", "lista");

        request.getRequestDispatcher("/jsp/registroProveedor.jsp")
               .forward(request, response);
    }
}
