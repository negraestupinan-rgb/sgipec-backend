// src/services/authService.js
export const authService = {
    login: async (email, contrasena) => {
        const response = await fetch('http://localhost:8080/api/auth/login', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ email, contrasena })
        });
        
        if (!response.ok) throw new Error('Credenciales incorrectas');
        return await response.json();
    }
};
