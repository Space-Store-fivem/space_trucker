import React, { useMemo, useState, useEffect } from 'react';
import { CompanyData, ProfileData } from '../../../types';

// Interface de propriedades (sem alterações)
interface HomeScreenProps {
    company?: CompanyData | null;
    profile?: ProfileData | null;
    isOwner: boolean;
    playerRole?: string;
    onAppSelect: (app: string) => void;
}

// Componente SVG para Ícones (sem alterações)
const AppIcon: React.FC<{ path: string; className?: string }> = ({ path, className = "w-9 h-9" }) => (
    <svg className={className} fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" d={path}></path>
    </svg>
);

// Componente de botão (sem alterações)
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


// Componente para quando o jogador não tem empresa (sem alterações)
const NoCompanyView: React.FC<{ onAppSelect: (app: string) => void }> = ({ onAppSelect }) => {
    return (
        <div className="w-full h-full p-8 flex flex-col items-center justify-center text-center bg-gradient-to-br from-gray-900 to-blue-900/50 rounded-xl">
            <AppIcon path="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" className="w-16 h-16 text-blue-300 mb-4 drop-shadow-lg" />
            <h1 className="text-4xl font-bold text-white">Bem-vindo(a), Trabalhador(a)!</h1>
            <p className="text-gray-300 mt-2 max-w-lg">Você ainda não faz parte de uma empresa. Explore as vagas disponíveis ou abra o seu próprio negócio.</p>
            <div className="flex gap-8 mt-10">
                <button onClick={() => onAppSelect('recruitment')} className="flex flex-col items-center gap-3 text-white p-6 bg-blue-600/50 hover:bg-blue-500/70 rounded-lg transition-colors shadow-xl border border-white/10">
                    <AppIcon path="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" className="w-12 h-12" />
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

// Componente principal da HomeScreen (com ícones atualizados)
export const HomeScreen: React.FC<HomeScreenProps> = ({ company, profile, isOwner, playerRole, onAppSelect }) => {
    const [currentTime, setCurrentTime] = useState(new Date());

    useEffect(() => {
        const timer = setInterval(() => { setCurrentTime(new Date()); }, 1000);
        return () => clearInterval(timer);
    }, []);

    const timeFormatter = new Intl.DateTimeFormat('pt-BR', { hour: '2-digit', minute: '2-digit', hour12: false });
    const dateFormatter = new Intl.DateTimeFormat('pt-BR', { weekday: 'long', day: '2-digit', month: 'long' });

    // ========= ✨ VISÃO PARA JOGADOR SEM EMPRESA (COM BOTÃO DE PERFIL) ✨ =========
    if (!company) {
        return (
            <div className="flex flex-col h-full">
                <NoCompanyView onAppSelect={onAppSelect} />
                <div className="p-6">
                      <h2 className="text-lg font-semibold text-gray-400 mb-3">Serviços Públicos</h2>
                      <div className="grid grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-4">
                            {/* Botão de Perfil */}
                            <AppButton 
                                iconPath="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" 
                                iconClassName="text-green-400 w-9 h-9" 
                                label="Meu Perfil" 
                                onClick={() => onAppSelect('profile')} 
                            />
                            {/* Botão da Central de Logística */}
                            <AppButton 
                                iconPath="M8 16H5.373a2 2 0 01-1.99-2.226l.5-4a2 2 0 012-1.774H14V4H6a2 2 0 00-2 2v12a2 2 0 002 2h12a2 2 0 002-2v-5M15 1v4h4" 
                                iconClassName="text-amber-400 w-9 h-9" 
                                label="Central de Logística" 
                                onClick={() => onAppSelect('logisticsHub')} 
                            />
                      </div>
                </div>
            </div>
        )
    }

    const permissions = useMemo(() => {
        try {
            if (typeof company.permissions === 'string' && company.permissions) {
                return JSON.parse(company.permissions);
            }
        } catch (e) {
            console.error("Falha ao fazer parse das permissões JSON:", e);
        }
        return { canManageDashboard: false, canManageEmployees: false, canManageFleet: false, canManageFinances: false, canManageIndustries: false, canAccessGps: true };
    }, [company.permissions]);

    const canAccess = (perm: keyof typeof permissions) => {
        if (isOwner) return true;
        if (playerRole === 'manager' || playerRole === 'employee') {
            return permissions[perm] !== false;
        }
        return false;
    };

    // ========= ✨ VISÃO PARA JOGADOR COM EMPRESA (COM BOTÃO DE PERFIL) ✨ =========
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
                        {canAccess('canManageDashboard') && <AppButton iconPath="M9 17v-4m3 4v-2m3 2v-6m-9 8h12a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" iconClassName="text-cyan-400 w-9 h-9" label="Dashboard" onClick={() => onAppSelect('dashboard')} />}
                        {canAccess('canManageEmployees') && <AppButton iconPath="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0z" iconClassName="text-green-400 w-9 h-9" label="Funcionários" onClick={() => onAppSelect('employees')} />}
                        {canAccess('canManageFleet') && <AppButton iconPath="M11 16l-4-4m0 0l4-4m-4 4h14m-5 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h7a3 3 0 013 3v1" iconClassName="text-orange-400 w-9 h-9" label="Frota" onClick={() => onAppSelect('fleet')} />}
                        {canAccess('canAccessGps') && <AppButton iconPath="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z" iconClassName="text-red-400 w-9 h-9" label="GPS da Frota" onClick={() => onAppSelect('gps')} />}
                        {canAccess('canManageFinances') && <AppButton iconPath="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z" iconClassName="text-yellow-400 w-9 h-9" label="Finanças" onClick={() => onAppSelect('finance')} />}
                        {(isOwner || canAccess('canManageIndustries')) && <AppButton iconPath="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 4h5m-5 4h5" iconClassName="text-purple-400 w-9 h-9" label="Indústrias" onClick={() => onAppSelect('industries')} />}
                        {isOwner && <AppButton iconPath="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065zM12 15a3 3 0 100-6 3 3 0 000 6z" iconClassName="text-gray-400 w-9 h-9" label="Ajustes" onClick={() => onAppSelect('settings')} />}
                        {isOwner && <AppButton iconPath="M3 12l2-2 4 4 6-6 4 4" iconClassName="text-teal-400 w-9 h-9" label="Monitor" onClick={() => onAppSelect('industryMonitor')} />}
                    </div>
                </section>

                <div className="my-6 border-t border-white/10"></div>

                <section>
                    <h2 className="text-lg font-semibold text-gray-400 mb-3">Geral</h2>
                    <div className="grid grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-4">
                         {/* Botão de Perfil */}
                         <AppButton 
                            iconPath="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" 
                            iconClassName="text-green-400 w-9 h-9" 
                            label="Meu Perfil" 
                            onClick={() => onAppSelect('profile')} 
                        />
                        <AppButton iconPath="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z" iconClassName="text-blue-400 w-9 h-9" label="Recrutamento" onClick={() => onAppSelect('recruitment')} />
                        <AppButton 
                            iconPath="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01" 
                            iconClassName="text-teal-400 w-9 h-9" 
                            label="Contratos" 
                            onClick={() => onAppSelect('missions')} 
                        />
                        <AppButton 
                            iconPath="M8 16H5.373a2 2 0 01-1.99-2.226l.5-4a2 2 0 012-1.774H14V4H6a2 2 0 00-2 2v12a2 2 0 002 2h12a2 2 0 002-2v-5M15 1v4h4" 
                            iconClassName="text-amber-400 w-9 h-9" 
                            label="Central de Logística" 
                            onClick={() => onAppSelect('logisticsHub')} 
                        />
                    </div>
                </section>
            </main>
        </div>
    );
};

export default HomeScreen;
