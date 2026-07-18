import React, { useEffect, useState } from 'react';

const AuthCheck = () => {
    const [isAuthenticated, setIsAuthenticated] = useState(false);

    useEffect(() => {
        const checkAuth = async () => {
            const response = await fetch('/api/auth/check');
            if (response.ok) {
                const data = await response.json();
                setIsAuthenticated(data.authenticated);
            } else {
                setIsAuthenticated(false);
            }
        };

        checkAuth();
    }, []);

    return (
        <div>
            {isAuthenticated ? (
                <p>Estás autenticado.</p>
            ) : (
                <p>No estás autenticado.</p>
            )}
        </div>
    );
};

export default AuthCheck;
