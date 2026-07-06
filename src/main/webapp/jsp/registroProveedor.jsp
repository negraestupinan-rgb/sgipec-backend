<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sgipec.modelo.Proveedor" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%--
    JSP: registroProveedor.jsp
    Módulo: Registro de Proveedores - SGIPEC
    Descripción: Formulario de registro con métodos GET y POST.
                 Muestra la lista de proveedores registrados.
                 Utiliza elementos JSP: scriptlets, expresiones, directivas, JSTL.
    Autor: Heydi Estupiñán Estupiñán
    Versión: 1.0
--%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SGIPEC - Registro de Proveedores</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@400;600&family=IBM+Plex+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --negro: #0A0A0A;
            --verde: #1A4D2E;
            --verde-claro: #2D7A4F;
            --verde-acento: #4CAF7D;
            --blanco: #F5F5F0;
            --gris: #E8E8E0;
            --gris-medio: #AAAAAA;
            --error: #C0392B;
            --exito: #27AE60;
            --fuente: 'IBM Plex Sans', sans-serif;
            --mono: 'IBM Plex Mono', monospace;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: var(--fuente);
            background-color: var(--negro);
            color: var(--blanco);
            min-height: 100vh;
        }

        /* ── HEADER ─────────────────────────────────────────────────────── */
        .header {
            background: var(--verde);
            padding: 0 2rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            height: 64px;
            border-bottom: 2px solid var(--verde-acento);
        }
        .header-logo {
            font-family: var(--mono);
            font-size: 1.1rem;
            font-weight: 600;
            letter-spacing: 0.15em;
            color: var(--verde-acento);
        }
        .header-sub {
            font-size: 0.75rem;
            color: var(--gris-medio);
            font-family: var(--mono);
        }
        .nav-links { display: flex; gap: 1.5rem; }
        .nav-links a {
            color: var(--gris);
            text-decoration: none;
            font-size: 0.875rem;
            padding: 0.4rem 0.8rem;
            border-radius: 4px;
            transition: background 0.2s;
        }
        .nav-links a:hover { background: rgba(76,175,125,0.15); color: var(--verde-acento); }

        /* ── CONTENIDO PRINCIPAL ─────────────────────────────────────────── */
        .contenedor {
            max-width: 1100px;
            margin: 2rem auto;
            padding: 0 1.5rem;
        }

        .titulo-pagina {
            font-family: var(--mono);
            font-size: 1.5rem;
            color: var(--verde-acento);
            margin-bottom: 0.4rem;
            letter-spacing: 0.05em;
        }
        .subtitulo {
            font-size: 0.875rem;
            color: var(--gris-medio);
            margin-bottom: 2rem;
            font-family: var(--mono);
        }

        /* ── ALERTAS ─────────────────────────────────────────────────────── */
        .alerta {
            padding: 1rem 1.25rem;
            border-radius: 6px;
            margin-bottom: 1.5rem;
            font-size: 0.9rem;
            border-left: 4px solid;
        }
        .alerta-error { background: rgba(192,57,43,0.15); border-color: var(--error); color: #E74C3C; }
        .alerta-exito { background: rgba(39,174,96,0.15); border-color: var(--exito); color: var(--exito); }

        /* ── GRID DE DOS COLUMNAS ────────────────────────────────────────── */
        .grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 2rem; }

        /* ── TARJETA ─────────────────────────────────────────────────────── */
        .tarjeta {
            background: #111;
            border: 1px solid #222;
            border-radius: 8px;
            padding: 1.75rem;
        }
        .tarjeta-titulo {
            font-family: var(--mono);
            font-size: 0.875rem;
            color: var(--verde-acento);
            letter-spacing: 0.1em;
            text-transform: uppercase;
            margin-bottom: 1.5rem;
            padding-bottom: 0.75rem;
            border-bottom: 1px solid #222;
        }

        /* ── FORMULARIO ──────────────────────────────────────────────────── */
        .campo { margin-bottom: 1.25rem; }
        .campo label {
            display: block;
            font-size: 0.8rem;
            color: var(--gris-medio);
            margin-bottom: 0.4rem;
            font-family: var(--mono);
            text-transform: uppercase;
            letter-spacing: 0.08em;
        }
        .campo label .req { color: var(--verde-acento); margin-left: 2px; }

        .campo input, .campo select {
            width: 100%;
            background: #1A1A1A;
            border: 1px solid #333;
            border-radius: 4px;
            padding: 0.65rem 0.875rem;
            color: var(--blanco);
            font-family: var(--fuente);
            font-size: 0.9rem;
            transition: border-color 0.2s;
            outline: none;
        }
        .campo input:focus, .campo select:focus {
            border-color: var(--verde-acento);
            background: #1E1E1E;
        }
        .campo input::placeholder { color: #444; font-style: italic; }

        .btn-registrar {
            width: 100%;
            background: var(--verde);
            color: var(--blanco);
            border: none;
            padding: 0.8rem;
            border-radius: 4px;
            font-size: 0.9rem;
            font-weight: 500;
            cursor: pointer;
            font-family: var(--mono);
            letter-spacing: 0.1em;
            transition: background 0.2s, transform 0.1s;
            margin-top: 0.5rem;
        }
        .btn-registrar:hover { background: var(--verde-claro); }
        .btn-registrar:active { transform: scale(0.99); }

        /* ── TABLA ───────────────────────────────────────────────────────── */
        .tabla-wrap { overflow-x: auto; }
        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.875rem;
        }
        th {
            background: #1A1A1A;
            color: var(--verde-acento);
            font-family: var(--mono);
            font-size: 0.75rem;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            padding: 0.75rem 1rem;
            text-align: left;
            border-bottom: 1px solid #2D2D2D;
        }
        td {
            padding: 0.7rem 1rem;
            border-bottom: 1px solid #1A1A1A;
            color: var(--gris);
        }
        tr:hover td { background: #151515; }

        .badge {
            display: inline-block;
            padding: 0.2rem 0.6rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-family: var(--mono);
        }
        .badge-pendiente { background: rgba(255,193,7,0.15); color: #FFC107; border: 1px solid rgba(255,193,7,0.3); }
        .badge-activo    { background: rgba(76,175,125,0.15); color: var(--verde-acento); border: 1px solid rgba(76,175,125,0.3); }
        .badge-inactivo  { background: rgba(158,158,158,0.15); color: #9E9E9E; border: 1px solid rgba(158,158,158,0.3); }

        .sin-datos {
            text-align: center;
            padding: 2rem;
            color: #444;
            font-family: var(--mono);
            font-size: 0.85rem;
        }

        /* ── INFO SESIÓN (elemento JSP) ──────────────────────────────────── */
        .info-sesion {
            background: #0D0D0D;
            border: 1px solid #1E1E1E;
            border-radius: 6px;
            padding: 1rem 1.25rem;
            margin-bottom: 1.5rem;
            font-family: var(--mono);
            font-size: 0.78rem;
            color: #555;
            display: flex;
            gap: 2rem;
        }
        .info-sesion span { color: var(--verde-acento); }

        @media (max-width: 768px) {
            .grid-2 { grid-template-columns: 1fr; }
            .nav-links { display: none; }
        }
    </style>
</head>
<body>

<%-- ── HEADER ──────────────────────────────────────────────────────────────── --%>
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

<%-- ── CONTENIDO ────────────────────────────────────────────────────────────── --%>
<div class="contenedor">

    <%-- Título de la página --%>
    <h1 class="titulo-pagina">// Registro de Proveedores</h1>
    <p class="subtitulo">Módulo de ingreso de proveedores externos — SGIPEC v1.0</p>

    <%-- ── Información de sesión JSP (Scriptlet + Expresión JSP) ─────────── --%>
    <%
        // Scriptlet JSP: obtener información de la sesión
        String idSesion = session.getId().substring(0, 12) + "...";
        java.util.Date fechaCreacion = new java.util.Date(session.getCreationTime());
        int totalProveedores = 0;
        java.util.List<?> listaSesion = (java.util.List<?>) session.getAttribute("listaProveedores");
        if (listaSesion != null) totalProveedores = listaSesion.size();
    %>
    <div class="info-sesion">
        <div>Sesión ID: <span><%= idSesion %></span></div>
        <div>Iniciada: <span><%= fechaCreacion %></span></div>
        <div>Proveedores registrados: <span><%= totalProveedores %></span></div>
        <div>Usuario: <span>Admin SGIPEC</span></div>
    </div>

    <%-- ── ALERTAS (usando JSTL c:if) ────────────────────────────────────── --%>
    <c:if test="${not empty error}">
        <div class="alerta alerta-error">⚠ ${error}</div>
    </c:if>
    <c:if test="${not empty mensaje}">
        <div class="alerta alerta-exito">✓ ${mensaje}</div>
    </c:if>

    <%-- ── GRID: FORMULARIO + LISTA ────────────────────────────────────────── --%>
    <div class="grid-2">

        <%-- ── FORMULARIO POST ──────────────────────────────────────────────── --%>
        <div class="tarjeta">
            <div class="tarjeta-titulo">→ Nuevo Proveedor</div>

            <%--
                Formulario con método POST → llama al doPost del servlet.
                action="RegistroProveedor" apunta al @WebServlet definido.
            --%>
            <form action="RegistroProveedor" method="POST">

                <div class="campo">
                    <label>Cédula <span class="req">*</span></label>
                    <input type="text" name="cedula"
                           placeholder="Ej: 1000001417"
                           pattern="[0-9]{6,10}"
                           maxlength="10"
                           title="Solo números, entre 6 y 10 dígitos"
                           required>
                </div>

                <div class="campo">
                    <label>Nombre completo <span class="req">*</span></label>
                    <input type="text" name="nombre"
                           placeholder="Ej: Juan Pérez Gómez"
                           maxlength="100" required>
                </div>

                <div class="campo">
                    <label>Empresa <span class="req">*</span></label>
                    <input type="text" name="empresa"
                           placeholder="Ej: Distribuidora ABC S.A.S"
                           maxlength="100" required>
                </div>

                <div class="campo">
                    <label>Correo electrónico <span class="req">*</span></label>
                    <input type="email" name="email"
                           placeholder="Ej: proveedor@empresa.com"
                           maxlength="100" required>
                </div>

                <div class="campo">
                    <label>Teléfono</label>
                    <input type="tel" name="telefono"
                           placeholder="Ej: 3001234567"
                           maxlength="15">
                </div>

                <button type="submit" class="btn-registrar">
                    REGISTRAR PROVEEDOR →
                </button>
            </form>
        </div>

        <%-- ── LISTA DE PROVEEDORES ────────────────────────────────────────── --%>
        <div class="tarjeta">
            <div class="tarjeta-titulo">
                ≡ Proveedores Registrados
                <%-- Expresión JSP para mostrar total --%>
                (<%= totalProveedores %>)
            </div>

            <div class="tabla-wrap">
                <table>
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Cédula</th>
                            <th>Nombre</th>
                            <th>Empresa</th>
                            <th>Estado</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%-- JSTL c:choose para manejar lista vacía --%>
                        <c:choose>
                            <c:when test="${empty proveedores}">
                                <tr>
                                    <td colspan="5" class="sin-datos">
                                        [ sin proveedores registrados ]
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <%-- JSTL c:forEach para iterar la lista --%>
                                <c:forEach var="proveedor" items="${proveedores}" varStatus="estado">
                                    <tr>
                                        <td>${estado.count}</td>
                                        <td>${proveedor.cedula}</td>
                                        <td>${proveedor.nombre}</td>
                                        <td>${proveedor.empresa}</td>
                                        <td>
                                            <%-- JSTL para badge de estado --%>
                                            <c:choose>
                                                <c:when test="${proveedor.estado == 'Activo'}">
                                                    <span class="badge badge-activo">Activo</span>
                                                </c:when>
                                                <c:when test="${proveedor.estado == 'Inactivo'}">
                                                    <span class="badge badge-inactivo">Inactivo</span>
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
            </div>

            <%-- Enlace GET a búsqueda --%>
            <div style="margin-top:1.25rem; text-align:right;">
                <a href="BuscarProveedor" style="color:var(--verde-acento);
                   font-family:var(--mono); font-size:0.8rem; text-decoration:none;">
                    → Buscar proveedor
                </a>
            </div>
        </div>
    </div>
</div>

</body>
</html>
