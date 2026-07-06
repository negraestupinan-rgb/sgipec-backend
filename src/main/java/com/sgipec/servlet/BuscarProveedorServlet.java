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
import java.util.stream.Collectors;

/**
 * Servlet para la búsqueda de proveedores en el SGIPEC.
 * Utiliza el método HTTP GET para recibir el parámetro de búsqueda
 * y devolver los resultados filtrados a la vista JSP.
 *
 * GET → Busca proveedor por cédula o nombre y retorna resultados.
 *
 * URL: /BuscarProveedor
 *
 * @author Heydi Estupiñán Estupiñán
 * @version 1.0
 */
@WebServlet("/BuscarProveedor")
public class BuscarProveedorServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    /**
     * Método GET:
     * Recibe el parámetro "criterio" desde el formulario de búsqueda.
     * Filtra la lista de proveedores por cédula o nombre.
     * Envía los resultados al JSP de búsqueda.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // Obtener el criterio de búsqueda del parámetro GET
        String criterio = request.getParameter("criterio");

        // Obtener lista de proveedores de la sesión
        HttpSession session = request.getSession(false);
        List<Proveedor> listaProveedores = new ArrayList<>();

        if (session != null && session.getAttribute("listaProveedores") != null) {
            @SuppressWarnings("unchecked")
            List<Proveedor> lista =
                    (List<Proveedor>) session.getAttribute("listaProveedores");
            listaProveedores = lista;
        }

        List<Proveedor> resultados = new ArrayList<>();

        // Filtrar por criterio si existe
        if (criterio != null && !criterio.trim().isEmpty()) {
            final String criterioBusqueda = criterio.trim().toLowerCase();
            resultados = listaProveedores.stream()
                    .filter(p -> p.getCedula().toLowerCase().contains(criterioBusqueda)
                            || p.getNombre().toLowerCase().contains(criterioBusqueda)
                            || p.getEmpresa().toLowerCase().contains(criterioBusqueda))
                    .collect(Collectors.toList());

            if (resultados.isEmpty()) {
                request.setAttribute("sinResultados",
                        "No se encontraron proveedores con el criterio: \"" + criterio + "\"");
            }
        } else {
            // Si no hay criterio, mostrar todos
            resultados = listaProveedores;
        }

        // Enviar datos al JSP
        request.setAttribute("resultados", resultados);
        request.setAttribute("criterio", criterio);
        request.setAttribute("totalResultados", resultados.size());

        request.getRequestDispatcher("/jsp/buscarProveedor.jsp")
               .forward(request, response);
    }
}
