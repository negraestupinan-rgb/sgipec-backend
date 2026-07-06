/**
 * @file    Login.jsx
 * @module  Autenticación
 * @desc    Módulo de inicio de sesión del SGIPEC.
 *          Permite a los usuarios (Administrador, Guardia de Control
 *          y Operador de Ingresos) autenticarse con email y contraseña.
 *          Al autenticarse correctamente, redirige al Dashboard según el rol.
 *
 * @author  Heydi Estupiñan Estupiñán
 * @version 1.0.0
 * @since   2026
 *
 * Proyecto : SGIPEC — Sistema de Gestión de Ingresos de Proveedores
 *            en Establecimiento Carcelario
 * SENA ADSO Ficha 3186650
 * Repositorio: https://github.com/heydi-estupinan/SGIPEC
 */

import React, { useState } from 'react';
import { authService } from '../services/authService';
import '../styles/Login.css';

/**
 * @component Login
 * @description Componente de inicio de sesión del SGIPEC.
 *              Gestiona el formulario de autenticación con validación
 *              local antes de enviar la petición al servidor.
 *
 * @returns {JSX.Element} Formulario de inicio de sesión
 */
const Login = () => {

  // ── Estado del formulario ───────────────────────────────────────────
  /** Datos ingresados por el usuario en el formulario */
  const [form, setForm] = useState({
    email:      '',
    contrasena: '',
  });

  /** Errores de validación por campo */
  const [errores, setErrores] = useState({});

  /** Indica si hay una petición en curso al servidor */
  const [cargando, setCargando] = useState(false);

  /** Mensaje de error general (credenciales incorrectas, servidor caído, etc.) */
  const [mensajeError, setMensajeError] = useState('');

  /** Controla si la contraseña se muestra en texto plano */
  const [mostrarClave, setMostrarClave] = useState(false);

  // ── Manejadores de eventos ──────────────────────────────────────────

  /**
   * Actualiza el estado del formulario al cambiar un campo.
   * Borra el error del campo modificado para dar retroalimentación inmediata.
   *
   * @param {React.ChangeEvent<HTMLInputElement>} e - Evento de cambio
   */
  const handleChange = (e) => {
    const { name, value } = e.target;

    // Actualizar el campo modificado manteniendo el resto del estado
    setForm((prev) => ({ ...prev, [name]: value }));

    // Limpiar el error del campo que el usuario está corrigiendo
    if (errores[name]) {
      setErrores((prev) => ({ ...prev, [name]: '' }));
    }

    // Limpiar mensaje de error general al retomar la escritura
    if (mensajeError) setMensajeError('');
  };

  /**
   * Valida los campos del formulario antes de enviar al servidor.
   * Evita peticiones innecesarias con datos incompletos o mal formados.
   *
   * @returns {boolean} true si todos los campos son válidos
   */
  const validarFormulario = () => {
    const nuevosErrores = {};

    // Validar email: requerido y formato correcto
    if (!form.email.trim()) {
      nuevosErrores.email = 'El correo electrónico es requerido.';
    } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(form.email)) {
      nuevosErrores.email = 'Ingrese un correo electrónico válido.';
    }

    // Validar contraseña: requerida y longitud mínima de 6 caracteres
    if (!form.contrasena) {
      nuevosErrores.contrasena = 'La contraseña es requerida.';
    } else if (form.contrasena.length < 6) {
      nuevosErrores.contrasena = 'La contraseña debe tener al menos 6 caracteres.';
    }

    setErrores(nuevosErrores);

    // Retorna true solo si no hay errores
    return Object.keys(nuevosErrores).length === 0;
  };

  /**
   * Maneja el envío del formulario de inicio de sesión.
   * Valida, llama al servicio de autenticación y redirige según el rol.
   *
   * @param {React.FormEvent<HTMLFormElement>} e - Evento de envío del formulario
   */
  const handleSubmit = async (e) => {
    e.preventDefault(); // Evitar recarga de la página

    // No continuar si la validación local falla
    if (!validarFormulario()) return;

    setCargando(true);
    setMensajeError('');

    try {
      // Llamar al servicio de autenticación con las credenciales
      const respuesta = await authService.login(form.email, form.contrasena);

      // Guardar el token JWT en sessionStorage para peticiones posteriores
      sessionStorage.setItem('token', respuesta.token);
      sessionStorage.setItem('rol',   respuesta.usuario.rol);
      sessionStorage.setItem('nombre',respuesta.usuario.nombre);

      // Redirigir al dashboard (la navegación real usaría React Router)
      window.location.href = '/dashboard';

    } catch (error) {
      // Mostrar el mensaje de error devuelto por el servidor
      setMensajeError(
        error.message || 'Credenciales incorrectas. Intente nuevamente.'
      );
    } finally {
      // Restaurar el estado de carga siempre, sin importar el resultado
      setCargando(false);
    }
  };

  // ── Renderizado del componente ──────────────────────────────────────
  return (
    <div className="login-fondo">
      <div className="login-contenedor">

        {/* Encabezado con logo e identificación del sistema */}
        <div className="login-encabezado">
          <div className="login-logo">
            {/* Ícono representativo del establecimiento carcelario */}
            <span className="login-logo-icono" aria-hidden="true">🔒</span>
          </div>
          <h1 className="login-titulo">SGIPEC</h1>
          <p className="login-subtitulo">
            Sistema de Gestión de Ingresos de Proveedores
          </p>
          <p className="login-subtitulo-dos">
            Establecimiento Carcelario
          </p>
        </div>

        {/* Formulario de autenticación */}
        <form
          className="login-formulario"
          onSubmit={handleSubmit}
          noValidate
          aria-label="Formulario de inicio de sesión"
        >

          {/* Mensaje de error general (credenciales incorrectas, etc.) */}
          {mensajeError && (
            <div className="login-alerta-error" role="alert" aria-live="polite">
              <span className="alerta-icono" aria-hidden="true">⚠️</span>
              {mensajeError}
            </div>
          )}

          {/* Campo: Correo electrónico */}
          <div className="campo-grupo">
            <label
              htmlFor="email"
              className="campo-etiqueta"
            >
              Correo electrónico
            </label>
            <div className="campo-contenedor">
              <span className="campo-icono" aria-hidden="true">✉️</span>
              <input
                id="email"
                type="email"
                name="email"
                value={form.email}
                onChange={handleChange}
                placeholder="usuario@sgipec.gov.co"
                className={`campo-input ${errores.email ? 'campo-input-error' : ''}`}
                autoComplete="email"
                aria-describedby={errores.email ? 'email-error' : undefined}
                aria-invalid={!!errores.email}
                disabled={cargando}
              />
            </div>
            {/* Mensaje de error del campo email */}
            {errores.email && (
              <span id="email-error" className="campo-mensaje-error" role="alert">
                {errores.email}
              </span>
            )}
          </div>

          {/* Campo: Contraseña */}
          <div className="campo-grupo">
            <label
              htmlFor="contrasena"
              className="campo-etiqueta"
            >
              Contraseña
            </label>
            <div className="campo-contenedor">
              <span className="campo-icono" aria-hidden="true">🔑</span>
              <input
                id="contrasena"
                type={mostrarClave ? 'text' : 'password'}
                name="contrasena"
                value={form.contrasena}
                onChange={handleChange}
                placeholder="••••••••"
                className={`campo-input ${errores.contrasena ? 'campo-input-error' : ''}`}
                autoComplete="current-password"
                aria-describedby={errores.contrasena ? 'contrasena-error' : undefined}
                aria-invalid={!!errores.contrasena}
                disabled={cargando}
              />
              {/* Botón para mostrar u ocultar la contraseña */}
              <button
                type="button"
                className="campo-ojo"
                onClick={() => setMostrarClave((v) => !v)}
                aria-label={mostrarClave ? 'Ocultar contraseña' : 'Mostrar contraseña'}
              >
                {mostrarClave ? '🙈' : '👁️'}
              </button>
            </div>
            {errores.contrasena && (
              <span id="contrasena-error" className="campo-mensaje-error" role="alert">
                {errores.contrasena}
              </span>
            )}
          </div>

          {/* Botón de envío */}
          <button
            type="submit"
            className="login-boton"
            disabled={cargando}
            aria-busy={cargando}
          >
            {cargando ? (
              <>
                <span className="spinner" aria-hidden="true" />
                Verificando...
              </>
            ) : (
              'Iniciar sesión'
            )}
          </button>

        </form>

        {/* Pie del panel de login */}
        <div className="login-pie">
          <p className="login-pie-texto">
            Acceso restringido al personal autorizado del establecimiento.
          </p>
          <p className="login-pie-version">SGIPEC v1.0.0 — SENA ADSO 2026</p>
        </div>

      </div>
    </div>
  );
};

export default Login;