/**
 * @file Login.jsx
 * @module Autenticación
 * @description Componente para el inicio de sesión de usuarios en el sistema SGIPEC.
 */

import React, { useState } from 'react';
import { InputText } from 'primereact/inputtext';
import { Button } from 'primereact/button';
import { Toast } from 'primereact/toast';
import { authService } from '../services/authService'; // Asegúrate de que este archivo existe

const Login = () => {
    const [email, setEmail] = useState('');
    const [contrasena, setContrasena] = useState('');
    const toast = React.useRef(null);

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            const response = await authService.login(email, contrasena);
            // Aquí puedes redirigir al usuario a otra página, por ejemplo:
            // window.location.href = '/dashboard';
            toast.current.show({ severity: 'success', summary: 'Éxito', detail: 'Inicio de sesión exitoso', life: 3000 });
        } catch (error) {
            toast.current.show({ severity: 'error', summary: 'Error', detail: 'Credenciales incorrectas', life: 3000 });
        }
    };

    return (
        <div className="login-container">
            <Toast ref={toast} />
            <h2>Iniciar Sesión</h2>
            <form onSubmit={handleSubmit}>
                <div className="p-field">
                    <label htmlFor="email">Email</label>
                    <InputText id="email" value={email} onChange={(e) => setEmail(e.target.value)} required />
                </div>
                <div className="p-field">
                    <label htmlFor="contrasena">Contraseña</label>
                    <InputText id="contrasena" type="password" value={contrasena} onChange={(e) => setContrasena(e.target.value)} required />
                </div>
                <Button label="Iniciar Sesión" icon="pi pi-sign-in" type="submit" />
            </form>
        </div>
    );
};

export default Login;
