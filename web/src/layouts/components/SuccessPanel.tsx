import React from 'react';
import { fetchNui } from '../../utils/fetchNui';

interface SuccessPanelProps {
  message: string;
}

const SuccessPanel: React.FC<SuccessPanelProps> = ({ message }) => {
  return (
    // O painel ocupa o lugar do painel de configurações
    <div className="flex flex-col items-center justify-center h-full w-full bg-gray-900 p-8">
      {/* Ícone de sucesso */}
      <svg className="w-16 h-16 text-green-500 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
      </svg>
      <h2 className="text-2xl font-bold text-white">Sucesso!</h2>
      <p className="text-gray-300 mt-2 mb-6 text-center">{message}</p>
      <button
        onClick={() => fetchNui('closePanel')}
        className="py-2 px-6 bg-green-600 hover:bg-green-500 rounded-md font-semibold transition-colors"
      >
        Fechar
      </button>
    </div>
  );
};

export default SuccessPanel;
