// web/src/layouts/pages/company/HomeScreen.tsx

import React, { useMemo, useState, useEffect } from 'react';
import { CompanyData, ProfileData } from '../../../types';

// Interface de propriedades atualizada
interface HomeScreenProps {
    company?: CompanyData | null;
    profile?: ProfileData | null;
    isOwner: boolean;
    playerRole?: string;
    onAppSelect: (app: string) => void;
}

// Componente SVG para Ícones. Agora recebe o caminho do SVG diretamente.
const AppIcon: React.FC<{ path: string; className?: string }> = ({ path, className = "w-9 h-9" }) => (
    <svg className={className} fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" d={path}></path>
    </svg>
);

// Componente de botão atualizado para usar o AppIcon com caminho de SVG
const AppButton: React.FC<{ iconPath: string; iconClassName?: string; label: string; onClick: () => void, size?: 'normal' | 'large' }> = ({ iconPath, iconClassName, label, onClick, size = 'normal' }) => {
    const sizeClasses = size === 'large' ? 'w-20 h-20' : 'w-16 h-16';
    return (
        <button onClick={onClick} className="flex flex-col items-center justify-center text-center gap-2 text-white font-medium hover:bg-white/10 p-3 rounded-xl transition-all duration-300 transform hover:scale-105">
            <div className={`${sizeClasses} bg-gray-800/70 backdrop-blur-sm border border-white/5 shadow-lg rounded-2xl flex items-center justify-center`}>
                <AppIcon path={iconPath} className={iconClassName} />
            </div>
            <span className="text-sm font-semibold">{label}</span>
        </button>
    );
};


// Componente para quando o jogador não tem empresa
const NoCompanyView: React.FC<{ onAppSelect: (app: string) => void }> = ({ onAppSelect }) => {
    return (
        <div className="w-full h-full p-8 flex flex-col items-center justify-center text-center bg-gradient-to-br from-gray-900 to-blue-900/50 rounded-xl">
            <AppIcon path="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" className="w-16 h-16 text-blue-300 mb-4 drop-shadow-lg" />
            <h1 className="text-4xl font-bold text-white">Bem-vindo(a), Trabalhador(a)!</h1>
            <p className="text-gray-300 mt-2 max-w-lg">Você ainda não faz parte de uma empresa. Explore as vagas disponíveis ou abra o seu próprio negócio.</p>
            <div className="flex gap-8 mt-10">
                <button onClick={() => onAppSelect('recruitment')} className="flex flex-col items-center gap-3 text-white p-6 bg-blue-600/50 hover:bg-blue-500/70 rounded-lg transition-colors shadow-xl border border-white/10">
                    <AppIcon path="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M15 21v-1a6 6 0 00-5.197-5.93M15 21V15" className="w-12 h-12" />
                    <span className="font-semibold">Procurar Vagas</span>
                </button>
                <button onClick={() => onAppSelect('createCompany')} className="flex flex-col items-center gap-3 text-white p-6 bg-green-600/50 hover:bg-green-500/70 rounded-lg transition-colors shadow-xl border border-white/10">
                    <AppIcon path="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 4h5m-5 4h5" className="w-12 h-12" />
                    <span className="font-semibold">Criar Empresa</span>
                </button>
            </div>
        </div>
    );
};

// Componente principal da HomeScreen
export const HomeScreen: React.FC<HomeScreenProps> = ({ company, profile, isOwner, playerRole, onAppSelect }) => {
    const [currentTime, setCurrentTime] = useState(new Date());

    useEffect(() => {
        const timer = setInterval(() => { setCurrentTime(new Date()); }, 1000);
        return () => clearInterval(timer);
    }, []);

    const timeFormatter = new Intl.DateTimeFormat('pt-BR', { hour: '2-digit', minute: '2-digit', hour12: false });
    const dateFormatter = new Intl.DateTimeFormat('pt-BR', { weekday: 'long', day: '2-digit', month: 'long' });

    if (!company) {
        return <NoCompanyView onAppSelect={onAppSelect} />;
    }

    const permissions = useMemo(() => {
        try {
            if (typeof company.permissions === 'string' && company.permissions) {
                return JSON.parse(company.permissions);
            }
        } catch (e) {
            console.error("Falha ao fazer parse das permissões JSON:", e);
        }
        return { canManageDashboard: false, canManageEmployees: false, canManageFleet: false, canManageFinances: false, canManageIndustries: false };
    }, [company.permissions]);

    const canAccess = (perm: keyof typeof permissions) => {
        if (isOwner) return true;
        if (playerRole === 'manager') return permissions[perm];
        return false;
    };

    return (
        <div className="w-full h-full p-6 flex flex-col bg-gray-900/80 backdrop-blur-md text-white">
            <header className="flex justify-between items-center pb-4 mb-4 border-b border-white/10">
                <div className="flex items-center gap-3">
                    <img src={profile?.profile_picture || 'https://i.imgur.com/default-avatar.png'} alt="Avatar" className="w-12 h-12 rounded-full object-cover border-2 border-blue-400" />
                    <div>
                        <p className="text-lg font-semibold">{profile?.profile_name || 'Usuário'}</p>
                        <p className="text-sm text-gray-400 capitalize">{playerRole === 'owner' ? 'Proprietário(a)' : playerRole}</p>
                    </div>
                </div>
                <div className="text-right">
                    <p className="text-2xl font-bold flex items-center gap-2">
                        <AppIcon path="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" className="w-6 h-6" /> {timeFormatter.format(currentTime)}
                    </p>
                    <p className="text-sm text-gray-400 flex items-center gap-2 justify-end">
                        <AppIcon path="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" className="w-4 h-4" /> {dateFormatter.format(currentTime)}
                    </p>
                </div>
            </header>

            <main className="flex-1 flex flex-col">
                <div className="flex items-center gap-4 mb-6">
                    <img src={company.logo_url} alt="Logo" className="w-16 h-16 rounded-lg object-cover shadow-lg" />
                    <div>
                        <h1 className="text-3xl font-bold">{company.name}</h1>
                        <p className="text-gray-300">Painel de Gestão da Empresa</p>
                    </div>
                </div>

                <section>
                    <h2 className="text-lg font-semibold text-gray-400 mb-3">Gerenciamento</h2>
                    <div className="grid grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-4">
                        {canAccess('canManageDashboard') && <AppButton iconPath="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" iconClassName="text-cyan-400 w-9 h-9" label="Dashboard" onClick={() => onAppSelect('dashboard')} />}
                        {canAccess('canManageEmployees') && <AppButton iconPath="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" iconClassName="text-green-400 w-9 h-9" label="Funcionários" onClick={() => onAppSelect('employees')} />}
                        {canAccess('canManageFleet') && <AppButton iconPath="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z M15 11a3 3 0 11-6 0 3 3 0 016 0z" iconClassName="text-orange-400 w-9 h-9" label="Frota" onClick={() => onAppSelect('fleet')} />}
                        {canAccess('canManageFinances') && <AppButton iconPath="M17 9V7a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2m2 4h10a2 2 0 002-2v-6a2 2 0 00-2-2H9a2 2 0 00-2 2v6a2 2 0 002 2zm7-5a2 2 0 11-4 0 2 2 0 014 0z" iconClassName="text-yellow-400 w-9 h-9" label="Finanças" onClick={() => onAppSelect('finance')} />}
                        
                        {(isOwner || canAccess('canManageIndustries')) && <AppButton iconPath="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 4h5m-5 4h5" iconClassName="text-purple-400 w-9 h-9" label="Indústrias" onClick={() => onAppSelect('industries')} />}

                        {isOwner && <AppButton iconPath="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0 3.35a1.724 1.724 0 001.066 2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" iconClassName="text-gray-400 w-9 h-9" label="Ajustes" onClick={() => onAppSelect('settings')} />}
                    </div>
                </section>

                <div className="my-6 border-t border-white/10"></div>

                <section>
                    <h2 className="text-lg font-semibold text-gray-400 mb-3">Geral</h2>
                    <div className="grid grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-4">
                        <AppButton iconPath="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M15 21v-1a6 6 0 00-5.197-5.93M15 21V15" iconClassName="text-blue-400 w-9 h-9" label="Recrutamento" onClick={() => onAppSelect('recruitment')} />
                        
                        {/* BOTÃO PARA O APP DE MISSÕES ADICIONADO AQUI */}
                        <AppButton iconPath="M9 20l-5.447-2.724A1 1 0 013 16.382V5.618a1 1 0 011.447-.894L9 7m0 13l6-3m-6 3V7m6 10l5.447 2.724A1 1 0 0021 16.382V5.618a1 1 0 00-1.447-.894L15 7m0 10V7m0 10L9 7" iconClassName="text-teal-400 w-9 h-9" label="Missões" onClick={() => onAppSelect('missions')} />
                    </div>
                </section>
            </main>
        </div>
    );
};

export default HomeScreen;