import React from 'react';

interface AppHeaderProps {
  title: string;
  logoUrl?: string; // A logo é opcional
  onBack: () => void;
}

const AppHeader: React.FC<AppHeaderProps> = ({ title, logoUrl, onBack }) => (
    <header className="flex items-center pb-4 border-b border-gray-700 mb-8 flex-shrink-0">
        <button onClick={onBack} className="p-2 rounded-full hover:bg-gray-700 transition-colors mr-4">
            <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 19l-7-7 7-7" /></svg>
        </button>
        <h1 className="text-3xl font-bold text-white">{title}</h1>
        <div className="flex-grow" />
        {logoUrl && (
            <img
                src={logoUrl}
                alt="Logo da Empresa"
                className="w-12 h-12 rounded-md object-cover bg-gray-700"
                onError={(e) => { e.currentTarget.src = 'https://placehold.co/48x48/374151/FFFFFF?text=Logo'; }}
            />
        )}
    </header>
);

export default AppHeader;
