// web/src/layouts/pages/company/ProfileManagement.tsx

import React, { useState, useEffect } from 'react';
import { fetchNui } from '../../../utils/fetchNui';
import { useNuiEvent } from '../../../hooks/useNuiEvent';
import { ProfileData } from '../../../types';
import { TrukerData } from '../../../types'; // Certifique-se que TrukerData está em types/index.ts

// Componente de Cabeçalho (Pode ser reutilizado)
const AppHeader: React.FC<{ title: string; onBack: () => void }> = ({ title, onBack }) => (
    <header className="flex items-center p-4 border-b border-white/10 sticky top-0 bg-gray-900/80 backdrop-blur-sm z-10">
        <button onClick={onBack} className="mr-4 text-white hover:text-blue-400 transition-colors">
            <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M15 19l-7-7 7-7" /></svg>
        </button>
        <h1 className="text-xl font-bold text-white">{title}</h1>
    </header>
);

// Componente para um card de estatística
const StatCard: React.FC<{ label: string; value: string | number; }> = ({ label, value }) => (
    <div className="bg-gray-800/50 p-4 rounded-lg text-center">
        <p className="text-sm text-gray-400">{label}</p>
        <p className="text-2xl font-bold text-white">{value}</p>
    </div>
);

export const ProfileManagement: React.FC<{ onBack: () => void; profile: ProfileData | null }> = ({ onBack, profile }) => {
    const [stats, setStats] = useState<TrukerData | null>(null);
    const [name, setName] = useState(profile?.profile_name || '');
    const [avatar, setAvatar] = useState(profile?.profile_picture || '');

    // Busca as estatísticas do jogador quando o painel é aberto
    useEffect(() => {
        fetchNui<TrukerData>('getTruckerStats').then(setStats);
    }, []);
    
    // Opcional: Escuta por atualizações de estatísticas em tempo real
    useNuiEvent<TrukerData>('setTruckerStats', setStats);

    const handleSaveChanges = () => {
        fetchNui('updateProfile', {
            profile_name: name,
            profile_picture: avatar,
        });
    };

    return (
        <div className="flex flex-col w-full h-full bg-gray-900/80 backdrop-blur-md text-white">
            <AppHeader title="Gerenciamento de Perfil" onBack={onBack} />
            
            <div className="flex-grow p-6 overflow-y-auto space-y-8">
                {/* Seção de Edição do Perfil */}
                <div className="bg-gray-800 p-6 rounded-lg border border-white/5">
                    <h2 className="text-lg font-bold text-amber-400 mb-4">Editar Perfil</h2>
                    <div className="flex items-center space-x-4">
                        <img src={avatar || 'https://via.placeholder.com/96'} alt="Avatar" className="w-24 h-24 rounded-full object-cover bg-gray-700"/>
                        <div className="w-full space-y-4">
                            <div>
                                <label className="block text-sm font-medium text-gray-300 mb-1">Nome de Caminhoneiro</label>
                                <input 
                                    type="text" 
                                    value={name}
                                    onChange={(e) => setName(e.target.value)}
                                    className="w-full p-2 rounded-lg bg-gray-700 border border-gray-600 focus:outline-none focus:border-blue-500"
                                />
                            </div>
                            <div>
                                <label className="block text-sm font-medium text-gray-300 mb-1">URL da Foto (Avatar)</label>
                                <input 
                                    type="text" 
                                    value={avatar}
                                    onChange={(e) => setAvatar(e.target.value)}
                                    className="w-full p-2 rounded-lg bg-gray-700 border border-gray-600 focus:outline-none focus:border-blue-500"
                                    placeholder="https://i.imgur.com/example.png"
                                />
                            </div>
                        </div>
                    </div>
                    <div className="text-right mt-4">
                        <button onClick={handleSaveChanges} className="bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-6 rounded-lg transition-colors">
                            Salvar Alterações
                        </button>
                    </div>
                </div>

                {/* Seção de Estatísticas */}
                <div className="bg-gray-800 p-6 rounded-lg border border-white/5">
                    <h2 className="text-lg font-bold text-green-400 mb-4">Estatísticas</h2>
                    {stats ? (
                        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                            <StatCard label="Distância Percorrida" value={`${(stats.totalDistance || 0).toFixed(2)} km`} />
                            <StatCard label="Entregas Concluídas" value={stats.totalPackage || 0} />
                            <StatCard label="Lucro Total" value={`$${(stats.totalProfit || 0).toLocaleString()}`} />
                            <StatCard label="Nível Atual" value={stats.level || 0} />
                        </div>
                    ) : (
                        <p className="text-gray-400">Carregando estatísticas...</p>
                    )}
                </div>

                {/* Seção de Histórico de Missões */}
                <div className="bg-gray-800 p-6 rounded-lg border border-white/5">
                    <h2 className="text-lg font-bold text-gray-400 mb-4">Histórico de Contratos (Em breve)</h2>
                    <p className="text-gray-500">
                        Aqui você poderá ver um histórico detalhado de todas as suas entregas. Esta funcionalidade ainda está em desenvolvimento.
                    </p>
                </div>
            </div>
        </div>
    );
};