// auth.js
import axios from 'axios';

const TOKEN_KEY = 'auth_token';
const USER_ROLE_KEY = 'user_role';

export const checkAuthentication = () => {
  const token = localStorage.getItem(TOKEN_KEY);
  return !!token; // Retourne true si le token existe, false sinon
};

export const getUserRole = () => {
  return localStorage.getItem(USER_ROLE_KEY);
};

export const login = async (email, password) => {
  try {
    const response = await axios.post('http://localhost:4000/api/auth/login', { email, password });
    const { token, user } = response.data;
    localStorage.setItem(TOKEN_KEY, token);
    localStorage.setItem(USER_ROLE_KEY, user.role);
    axios.defaults.headers.common['Authorization'] = `Bearer ${token}`;
    return user;
  } catch (error) {
    console.error('Login failed:', error);
    throw error;
  }
};

export const logout = () => {
  localStorage.removeItem(TOKEN_KEY);
  localStorage.removeItem(USER_ROLE_KEY);
  delete axios.defaults.headers.common['Authorization'];
};

export const setAuthHeader = () => {
  const token = localStorage.getItem(TOKEN_KEY);
  if (token) {
    axios.defaults.headers.common['Authorization'] = `Bearer ${token}`;
  }
};