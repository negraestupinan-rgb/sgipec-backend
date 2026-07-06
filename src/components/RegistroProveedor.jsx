/**
 * @file RegistroProveedor.jsx
 * @module Proveedores
 * @description Módulo para el registro de nuevos proveedores en el sistema SGIPEC.
 * @author Heydi Estupiñan Estupiñán — SENA ADSO Ficha 3186650
 */

import React, { useState } from 'react';
import { InputText } from 'primereact/inputtext';
import { Button } from 'primereact/button';
import { Card } from 'primereact/card';

const RegistroProveedor = () => {
    // Estado inicial del formulario
    const [proveedor, setProveedor] = useState({
        nit: '',
        razon_social: '',
        tipo_servicio: '',
        contacto: '',
        telefono: ''
    });

    /**
     * Maneja los cambios en los inputs del formulario
     * @param {Object} e - Evento de cambio
     */
    const handleChange = (e) => {
        const { name, value } = e.target;
        setProveedor(prev => ({ ...prev, [name]: value }));
    };

    /**
     * Envía los datos al backend (Simulado)
     */
    const handleSubmit = async (e) => {
        e.preventDefault();
        console.log("Enviando datos a la base de datos:", proveedor);
        // Aquí realizarías el fetch a tu API Java
    };

    return (
        <Card title="Registro de Nuevo Proveedor" className="p-shadow-3">
            <form onSubmit={handleSubmit} className="p-fluid">
                <div className="p-field p-mb-3">
                    <label htmlFor="nit">NIT</label>
                    <InputText id="nit" name="nit" value={proveedor.nit} onChange={handleChange} required />
                </div>
                <div className="p-field p-mb-3">
                    <label htmlFor="razon_social">Razón Social</label>
                    <InputText id="razon_social" name="razon_social" value={proveedor.razon_social} onChange={handleChange} required />
                </div>
                <div className="p-field p-mb-3">
                    <label htmlFor="tipo_servicio">Tipo de Servicio</label>
                    <InputText id="tipo_servicio" name="tipo_servicio" value={proveedor.tipo_servicio} onChange={handleChange} />
                </div>
                <Button label="Registrar Proveedor" icon="pi pi-check" type="submit" />
            </form>
        </Card>
    );
};

export default RegistroProveedor;
