import React, { useEffect, useState } from 'react';

const DataLoader = () => {
    const [data, setData] = useState(null);
    const [error, setError] = useState(null);

    useEffect(() => {
        console.log("SGIPEC: Módulo de Gestión iniciado.");
        fetch('http://localhost:8080/api/solicitudes')
            .then(response => response.json())
            .then(data => {
                console.log("Datos recibidos:", data);
                setData(data);
            })
            .catch(err => {
                console.error("Error de conexión:", err);
                setError("No se pudo conectar con el servidor. Asegúrate de que tu aplicación Java esté ejecutándose.");
            });
    }, []);

    return (
        <div className="mensaje-sistema">
            {error ? (
                <div style={{ color: 'red' }}>
                    <strong>Error:</strong> {error}
                </div>
            ) : (
                <h3>{data ? "¡Datos cargados correctamente!" : "Conectando con SGIPEC Backend..."}</h3>
            )}
        </div>
    );
};

export default DataLoader;
