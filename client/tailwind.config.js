// tailwind.config.js
export const purge = ['./index.html', './src/**/*.{vue,js,ts,jsx,tsx}'];
export const darkMode = false;
export const theme = {
  extend: {
    colors: {
      'bat-black': '#0A0A0A',
      'bat-gray': '#1E1E1E',
      'bat-yellow': '#FFFF00',
      'bat-blue': '#0066CC',
      'bat-silver': '#C0C0C0',
    },
    fontFamily: {
      'gotham': ['Gotham', 'sans-serif'],
    },
    boxShadow: {
      'bat': '0 4px 6px -1px rgba(255, 255, 0, 0.1), 0 2px 4px -1px rgba(255, 255, 0, 0.06)',
    },
  },
};
export const variants = {
  extend: {},
};
export const plugins = [];