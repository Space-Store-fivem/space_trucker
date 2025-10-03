// web/src/layouts/pages/company/ProfileManagement.tsx (VERSÃO FINAL COM LOGS E CORREÇÕES)

import React, { useState, useEffect } from 'react';
import { fetchNui } from '../../../utils/fetchNui';
import { ProfileData, TrukerData } from '../../../types';

// Componente de Cabeçalho
const AppHeader: React.FC<{ title: string; onBack: () => void }> = ({ title, onBack }) => (
    <header className="flex items-center p-4 border-b border-white/10 sticky top-0 bg-gray-900/80 backdrop-blur-sm z-10">
        <button onClick={onBack} className="mr-4 text-white hover:text-blue-400 transition-colors">
            {/* [CORREÇÃO] O atributo viewBox precisa de 4 números. Estava faltando o último '24'. */}
            <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M15 19l-7-7 7-7" /></svg>
        </button>
        <h1 className="text-xl font-bold text-white">{title}</h1>
    </header>
);

// Componentes StatCard e MissionHistoryCard (sem alterações)
const StatCard: React.FC<{ label: string; value: string | number; }> = ({ label, value }) => (
    <div className="bg-gray-800/50 p-4 rounded-lg text-center">
        <p className="text-sm text-gray-400">{label}</p>
        <p className="text-2xl font-bold text-white">{value}</p>
    </div>
);
const MissionHistoryCard: React.FC<{ mission: any }> = ({ mission }) => (
    <div className="bg-gray-900/60 p-3 rounded-lg border border-white/5">
        <p className="text-sm text-white">
            De <span className="font-semibold text-amber-300">{mission.source_industry}</span> para <span className="font-semibold text-amber-300">{mission.destination_business}</span>
        </p>
        <p className="text-xs text-gray-400 mt-1">
            Item: {mission.item} ({mission.amount} unidades)
        </p>
        <div className="flex justify-between items-center mt-2 text-xs">
            <p className="text-green-400 font-medium">Lucro: ${mission.profit.toLocaleString()}</p>
            <p className="text-blue-400 font-medium">Distância: {mission.distance.toFixed(2)} km</p>
        </div>
    </div>
);


export const ProfileManagement: React.FC<{ onBack: () => void; profile: ProfileData | null }> = ({ onBack, profile }) => {
    const [stats, setStats] = useState<TrukerData | null>(null);
    const [history, setHistory] = useState<any[]>([]);
    const [name, setName] = useState(profile?.profile_name || '');
    const [avatar, setAvatar] = useState(profile?.profile_picture || '');
    
    useEffect(() => {
        console.log("[LOG-UI] A carregar estatísticas e histórico...");
        fetchNui<TrukerData>('loadPlayerStats').then(data => {
            console.log("[LOG-UI] Estatísticas recebidas:", data);
            setStats(data || { totalProfit: 0, totalDistance: 0, totalPackage: 0, level: 0 });
        }).catch(e => console.error("[LOG-UI] Erro ao carregar estatísticas:", e));

        fetchNui<any[]>('loadMissionHistory').then(data => {
            console.log("[LOG-UI] Histórico recebido:", data);
            setHistory(data || []);
        }).catch(e => console.error("[LOG-UI] Erro ao carregar histórico:", e));
    }, []);
    
    const handleSaveChanges = async () => {
        console.log("[LOG-UI] A tentar salvar o perfil com os dados:", { name, avatar });
        
        // A chamada está correta, usando o nome completo do callback
        const result = await fetchNui<{ success: boolean, message: string }>(
            'space_trucker:callback:updateProfile', 
            {
                profile_name: name,
                profile_picture: avatar,
            }
        ).catch(e => console.error("[LOG-UI] Erro na chamada NUI para updateProfile:", e));

        if (result && result.success) {
            console.log("[LOG-UI] Servidor confirmou o salvamento do perfil.");
        } else {
            console.log("[LOG-UI] Servidor retornou erro ou falhou ao salvar o perfil.", result);
        }
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
                    <h2 className="text-lg font-bold text-cyan-400 mb-4">Histórico de Contratos</h2>
                    {history.length > 0 ? (
                        <div className="space-y-3 max-h-60 overflow-y-auto pr-2">
                            {history.map((mission, index) => (
                                <MissionHistoryCard key={mission.id || index} mission={mission} />
                            ))}
                        </div>
                    ) : (
                        <p className="text-gray-500">
                            Nenhum contrato concluído ainda.
                        </p>
                    )}
                </div>
            </div>
        </div>
    );
};