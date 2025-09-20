import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import * as path from 'path'
// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  base: './',
  publicDir: 'public',
  build: {
    outDir: 'build',
    target: 'esnext',
    // A secção 'rollupOptions' foi removida para garantir que tudo seja incluído no build final.
  },
  esbuild: {
    logOverride: { 'this-is-undefined-in-esm': 'silent' },
  },
  resolve: {
    alias: {
      '@assets': path.resolve(__dirname, './src/assets'),
      '@utils': path.resolve(__dirname, './src/utils'),
      '@hooks': path.resolve(__dirname, './src/hooks'),
      '@providers': path.resolve(__dirname, './src/providers'),
      '@state': path.resolve(__dirname, './src/state'),
      '@types': path.resolve(__dirname, './src/types')
    },
  },
});
