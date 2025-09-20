// src/layouts/pages/company/HomeScreen.tsx

import React, { useMemo, useState, useEffect } from 'react';
import { CompanyData, ProfileData } from '../../../types';
import { IconBuildingSkyscraper, IconUsers, IconCar, IconPigMoney, IconSettings, IconBuildingFactory2, IconBriefcase, IconClock, IconCalendar } from '@tabler/icons-react';
import IconRecruitment from '../../components/IconRecruitment';

// Interface de propriedades atualizada para incluir dados do perfil do jogador
interface HomeScreenProps {
    company?: CompanyData | null;
    profile?: ProfileData | null; // Adicionado para obter o nome do jogador
    isOwner: boolean;
    playerRole?: string;
    onAppSelect: (app: string) => void;
}

// Componente para os botões dos aplicativos com estilo aprimorado
const AppButton: React.FC<{ icon: React.ReactNode; label: string; onClick: () => void, size?: 'normal' | 'large' }> = ({ icon, label, onClick, size = 'normal' }) => {
    const sizeClasses = size === 'large' ? 'w-20 h-20' : 'w-16 h-16';
    return (
        <button onClick={onClick} className="flex flex-col items-center justify-center text-center gap-2 text-white font-medium hover:bg-white/10 p-3 rounded-xl transition-all duration-300 transform hover:scale-105">
            <div className={`${sizeClasses} bg-gray-800/70 backdrop-blur-sm border border-white/5 shadow-lg rounded-2xl flex items-center justify-center`}>{icon}</div>
            <span className="text-sm font-semibold">{label}</span>
        </button>
    );
};

// Componente para quando o jogador não tem empresa
const NoCompanyView: React.FC<{ onAppSelect: (app: string) => void }> = ({ onAppSelect }) => {
    return (
        <div className="w-full h-full p-8 flex flex-col items-center justify-center text-center bg-gradient-to-br from-gray-900 to-blue-900/50 rounded-xl">
            <IconBriefcase size={64} className="text-blue-300 mb-4 drop-shadow-lg" />
            <h1 className="text-4xl font-bold text-white">Bem-vindo(a), Trabalhador(a)!</h1>
            <p className="text-gray-300 mt-2 max-w-lg">Você ainda não faz parte de uma empresa. Explore as vagas disponíveis ou abra o seu próprio negócio.</p>
            <div className="flex gap-8 mt-10">
                <button onClick={() => onAppSelect('recruitment')} className="flex flex-col items-center gap-3 text-white p-6 bg-blue-600/50 hover:bg-blue-500/70 rounded-lg transition-colors shadow-xl border border-white/10">
                    <IconRecruitment className="w-12 h-12" />
                    <span className="font-semibold">Procurar Vagas</span>
                </button>
                <button onClick={() => onAppSelect('createCompany')} className="flex flex-col items-center gap-3 text-white p-6 bg-green-600/50 hover:bg-green-500/70 rounded-lg transition-colors shadow-xl border border-white/10">
                    <IconBuildingFactory2 size={48} />
                    <span className="font-semibold">Criar Empresa</span>
                </button>
            </div>
        </div>
    );
};

// Componente principal da HomeScreen
export const HomeScreen: React.FC<HomeScreenProps> = ({ company, profile, isOwner, playerRole, onAppSelect }) => {
    const [currentTime, setCurrentTime] = useState(new Date());

    // Efeito para atualizar a hora a cada segundo
    useEffect(() => {
        const timer = setInterval(() => {
            setCurrentTime(new Date());
        }, 1000);
        return () => clearInterval(timer);
    }, []);

    // Formatação da data e hora para o padrão brasileiro
    const timeFormatter = new Intl.DateTimeFormat('pt-BR', { hour: '2-digit', minute: '2-digit', hour12: false });
    const dateFormatter = new Intl.DateTimeFormat('pt-BR', { weekday: 'long', day: '2-digit', month: 'long' });

    // Se não houver empresa, mostra a tela de boas-vindas
    if (!company) {
        return <NoCompanyView onAppSelect={onAppSelect} />;
    }

    // Lógica de permissões para gerentes
    const permissions = useMemo(() => {
        try {
            if (typeof company.permissions === 'string' && company.permissions) {
                return JSON.parse(company.permissions);
            }
        } catch (e) {
            console.error("Falha ao fazer parse das permissões JSON:", e);
        }
        return { canManageDashboard: false, canManageEmployees: false, canManageFleet: false, canManageFinances: false };
    }, [company.permissions]);

    const canAccess = (perm: keyof typeof permissions) => {
        if (isOwner) return true;
        if (playerRole === 'manager') {
            return permissions[perm];
        }
        return false;
    };

    return (
        <div className="w-full h-full p-6 flex flex-col bg-gray-900/80 backdrop-blur-md text-white">
            {/* Cabeçalho com informações do usuário e data/hora */}
            <header className="flex justify-between items-center pb-4 mb-4 border-b border-white/10">
                <div className="flex items-center gap-3">
                    <img src={profile?.profile_picture || 'https://i.imgur.com/default-avatar.png'} alt="Avatar" className="w-12 h-12 rounded-full object-cover border-2 border-blue-400" />
                    <div>
                        <p className="text-lg font-semibold">{profile?.profile_name || 'Usuário'}</p>
                        <p className="text-sm text-gray-400 capitalize">{playerRole === 'owner' ? 'Proprietário(a)' : playerRole}</p>
                    </div>
                </div>
                <div className="text-right">
                    <p className="text-2xl font-bold flex items-center gap-2"><IconClock size={24} /> {timeFormatter.format(currentTime)}</p>
                    <p className="text-sm text-gray-400 flex items-center gap-2 justify-end"><IconCalendar size={16} /> {dateFormatter.format(currentTime)}</p>
                </div>
            </header>

            {/* Corpo principal com os aplicativos */}
            <main className="flex-1 flex flex-col">
                <div className="flex items-center gap-4 mb-6">
                    <img src={company.logo_url} alt="Logo" className="w-16 h-16 rounded-lg object-cover shadow-lg" />
                    <div>
                        <h1 className="text-3xl font-bold">{company.name}</h1>
                        <p className="text-gray-300">Painel de Gestão da Empresa</p>
                    </div>
                </div>

                {/* Seção de Gerenciamento */}
                <section>
                    <h2 className="text-lg font-semibold text-gray-400 mb-3">Gerenciamento</h2>
                    <div className="grid grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-4">
                        {canAccess('canManageDashboard') && <AppButton icon={<IconBuildingSkyscraper size={36} className="text-cyan-400" />} label="Dashboard" onClick={() => onAppSelect('dashboard')} />}
                        {canAccess('canManageEmployees') && <AppButton icon={<IconUsers size={36} className="text-green-400" />} label="Funcionários" onClick={() => onAppSelect('employees')} />}
                        {canAccess('canManageFleet') && <AppButton icon={<IconCar size={36} className="text-orange-400" />} label="Frota" onClick={() => onAppSelect('fleet')} />}
                        {canAccess('canManageFinances') && <AppButton icon={<IconPigMoney size={36} className="text-yellow-400" />} label="Finanças" onClick={() => onAppSelect('finance')} />}
                        {isOwner && <AppButton icon={<IconSettings size={36} className="text-gray-400" />} label="Ajustes" onClick={() => onAppSelect('settings')} />}
                    </div>
                </section>

                <div className="my-6 border-t border-white/10"></div>

                {/* Seção Geral */}
                <section>
                    <h2 className="text-lg font-semibold text-gray-400 mb-3">Geral</h2>
                    <div className="grid grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-4">
                        <AppButton icon={<IconRecruitment className="w-9 h-9 text-blue-400" />} label="Recrutamento" onClick={() => onAppSelect('recruitment')} />
                    </div>
                </section>
            </main>
        </div>
    );
};

export default HomeScreen;
