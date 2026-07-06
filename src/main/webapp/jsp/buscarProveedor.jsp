<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sgipec.modelo.Proveedor" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%--
    JSP: buscarProveedor.jsp
    Módulo: Búsqueda de Proveedores - SGIPEC
    Descripción: Formulario de búsqueda con método GET.
                 Muestra resultados filtrados por cédula, nombre o empresa.
    Autor: Heydi Estupiñán Estupiñán
    Versión: 1.0
--%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SGIPEC - Búsqueda de Proveedores</title>
    <link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@400;600&family=IBM+Plex+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --negro: #0A0A0A;
            --verde: #1A4D2E;
            --verde-acento: #4CAF7D;
            --blanco: #F5F5F0;
            --gris: #E8E8E0;
            --gris-medio: #AAAAAA;
            --fuente: 'IBM Plex Sans', sans-serif;
            --mono: 'IBM Plex Mono', monospace;
        }
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:var(--fuente); background:var(--negro); color:var(--blanco); min-height:100vh; }

        .header {
            background:var(--verde); padding:0 2rem;
            display:flex; align-items:center; justify-content:space-between;
            height:64px; border-bottom:2px solid var(--verde-acento);
        }
        .header-logo { font-family:var(--mono); font-size:1.1rem; font-weight:600; letter-spacing:0.15em; color:var(--verde-acento); }
        .header-sub { font-size:0.75rem; color:#AAAAAA; font-family:var(--mono); }
        .nav-links { display:flex; gap:1.5rem; }
        .nav-links a { color:var(--gris); text-decoration:none; font-size:0.875rem; padding:0.4rem 0.8rem; border-radius:4px; }
        .nav-links a:hover { background:rgba(76,175,125,0.15); color:var(--verde-acento); }

        .contenedor { max-width:900px; margin:2rem auto; padding:0 1.5rem; }
        .titulo-pagina { font-family:var(--mono); font-size:1.5rem; color:var(--verde-acento); margin-bottom:0.4rem; }
        .subtitulo { font-size:0.875rem; color:#AAAAAA; margin-bottom:2rem; font-family:var(--mono); }

        /* ── FORMULARIO GET ─────────────────────────────────────────────── */
        .form-busqueda {
            background:#111; border:1px solid #222; border-radius:8px;
            padding:1.75rem; margin-bottom:2rem;
        }
        .form-busqueda-titulo {
            font-family:var(--mono); font-size:0.875rem; color:var(--verde-acento);
            text-transform:uppercase; letter-spacing:0.1em;
            margin-bottom:1.25rem; padding-bottom:0.75rem; border-bottom:1px solid #222;
        }
        .form-fila { display:flex; gap:1rem; align-items:flex-end; }
        .campo-busqueda { flex:1; }
        .campo-busqueda label {
            display:block; font-size:0.8rem; color:#AAAAAA;
            margin-bottom:0.4rem; font-family:var(--mono);
            text-transform:uppercase; letter-spacing:0.08em;
        }
        .campo-busqueda input {
            width:100%; background:#1A1A1A; border:1px solid #333;
            border-radius:4px; padding:0.65rem 0.875rem; color:var(--blanco);
            font-family:var(--fuente); font-size:0.9rem; outline:none;
        }
        .campo-busqueda input:focus { border-color:var(--verde-acento); }
        .campo-busqueda input::placeholder { color:#444; font-style:italic; }

        .btn-buscar {
            background:var(--verde); color:var(--blanco); border:none;
            padding:0.65rem 1.5rem; border-radius:4px; font-size:0.875rem;
            font-weight:500; cursor:pointer; font-family:var(--mono);
            letter-spacing:0.1em; white-space:nowrap;
        }
        .btn-buscar:hover { background:#2D7A4F; }
        .btn-limpiar {
            background:transparent; color:#AAAAAA; border:1px solid #333;
            padding:0.65rem 1rem; border-radius:4px; font-size:0.875rem;
            cursor:pointer; font-family:var(--mono); text-decoration:none;
            display:inline-flex; align-items:center;
        }
        .btn-limpiar:hover { border-color:#555; color:var(--blanco); }

        /* ── RESULTADOS ─────────────────────────────────────────────────── */
        .tarjeta { background:#111; border:1px solid #222; border-radius:8px; padding:1.75rem; }
        .tarjeta-titulo {
            font-family:var(--mono); font-size:0.875rem; color:var(--verde-acento);
            text-transform:uppercase; letter-spacing:0.1em;
            margin-bottom:1.25rem; padding-bottom:0.75rem; border-bottom:1px solid #222;
            display:flex; justify-content:space-between; align-items:center;
        }
        .contador {
            font-size:0.75rem; color:#AAAAAA;
            background:#1A1A1A; padding:0.2rem 0.6rem; border-radius:20px;
        }

        table { width:100%; border-collapse:collapse; font-size:0.875rem; }
        th {
            background:#1A1A1A; color:var(--verde-acento);
            font-family:var(--mono); font-size:0.75rem;
            letter-spacing:0.1em; text-transform:uppercase;
            padding:0.75rem 1rem; text-align:left; border-bottom:1px solid #2D2D2D;
        }
        td { padding:0.7rem 1rem; border-bottom:1px solid #1A1A1A; color:var(--gris); }
        tr:hover td { background:#151515; }

        .badge { display:inline-block; padding:0.2rem 0.6rem; border-radius:20px; font-size:0.75rem; font-family:var(--mono); }
        .badge-pendiente { background:rgba(255,193,7,0.15); color:#FFC107; border:1px solid rgba(255,193,7,0.3); }
        .badge-activo    { background:rgba(76,175,125,0.15); color:var(--verde-acento); border:1px solid rgba(76,175,125,0.3); }

        .sin-datos { text-align:center; padding:2.5rem; color:#444; font-family:var(--mono); font-size:0.85rem; }
        .sin-resultados { text-align:center; padding:2rem; color:#C0392B; font-family:var(--mono); font-size:0.85rem; }

        .criterio-badge {
            display:inline-block; background:rgba(76,175,125,0.1);
            border:1px solid rgba(76,175,125,0.3); color:var(--verde-acento);
            padding:0.2rem 0.75rem; border-radius:20px;
            font-family:var(--mono); font-size:0.8rem; margin-left:0.5rem;
        }

        .volver {
            display:inline-block; margin-top:1.5rem;
            color:var(--verde-acento); font-family:var(--mono);
            font-size:0.8rem; text-decoration:none;
        }
        .volver:hover { text-decoration:underline; }
    </style>
</head>
<body>

<header class="header">
    <div>
        <div class="header-logo">SGIPEC</div>
        <div class="header-sub">Sistema de Gestión de Ingresos de Proveedores</div>
    </div>
    <nav class="nav-links">
        <a href="RegistroProveedor">Registro</a>
        <a href="BuscarProveedor">Búsqueda</a>
    </nav>
</header>

<div class="contenedor">

    <h1 class="titulo-pagina">// Búsqueda de Proveedores</h1>
    <p class="subtitulo">Consulta por cédula, nombre o empresa — método GET</p>

    <%-- ── FORMULARIO GET ─────────────────────────────────────────────────── --%>
    <%--
        Formulario con método GET → los parámetros van en la URL.
        Llama al doGet del BuscarProveedorServlet.
        URL resultado: /BuscarProveedor?criterio=valor
    --%>
    <div class="form-busqueda">
        <div class="form-busqueda-titulo">→ Criterio de búsqueda</div>
        <form action="BuscarProveedor" method="GET">
            <div class="form-fila">
                <div class="campo-busqueda">
                    <label>Cédula, nombre o empresa</label>
                    <%--
                        Expresión JSP para pre-llenar el campo con el criterio anterior
                    --%>
                    <input type="text" name="criterio"
                           value="<%= request.getParameter("criterio") != null ? request.getParameter("criterio") : "" %>"
                           placeholder="Ej: 1000001417 o Juan Pérez o Distribuidora ABC">
                </div>
                <button type="submit" class="btn-buscar">BUSCAR →</button>
                <a href="BuscarProveedor" class="btn-limpiar">✕ Limpiar</a>
            </div>
        </form>
    </div>

    <%-- ── RESULTADOS ─────────────────────────────────────────────────────── --%>
    <div class="tarjeta">
        <div class="tarjeta-titulo">
            <span>
                ≡ Resultados
                <%-- Mostrar criterio si existe (Expresión JSP) --%>
                <c:if test="${not empty criterio}">
                    <span class="criterio-badge">"${criterio}"</span>
                </c:if>
            </span>
            <span class="contador">${totalResultados} encontrado(s)</span>
        </div>

        <%-- Mensaje si no hay resultados para el criterio --%>
        <c:if test="${not empty sinResultados}">
            <div class="sin-resultados">⊘ ${sinResultados}</div>
        </c:if>

        <c:if test="${empty sinResultados}">
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Cédula</th>
                        <th>Nombre</th>
                        <th>Empresa</th>
                        <th>Email</th>
                        <th>Teléfono</th>
                        <th>Estado</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty resultados}">
                            <tr>
                                <td colspan="7" class="sin-datos">
                                    [ ingrese un criterio de búsqueda ]
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="p" items="${resultados}" varStatus="st">
                                <tr>
                                    <td>${st.count}</td>
                                    <td>${p.cedula}</td>
                                    <td>${p.nombre}</td>
                                    <td>${p.empresa}</td>
                                    <td>${p.email}</td>
                                    <td>${p.telefono}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${p.estado == 'Activo'}">
                                                <span class="badge badge-activo">Activo</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-pendiente">Pendiente</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </c:if>
    </div>

    <a href="RegistroProveedor" class="volver">← Volver al registro</a>
</div>

</body>
</html>
