// src/layouts/pages/company/Settings.tsx

import React, { useState } from 'react';
import { FullCompanyInfo } from '../../../types';
import { fetchNui } from '../../../utils/fetchNui';
import ConfirmationModal from '../../components/ConfirmationModal';
import AppHeader from '../../components/AppHeader';
import { TransferOwnershipModal } from './TransferOwnershipModal';
import SwitchToggle from '../../components/SwitchToggle';

interface PermissionsState {
    canManageDashboard: boolean;
    canManageEmployees: boolean;
    canManageFleet: boolean;
    canManageFinances: boolean;
}

export const Settings: React.FC<{
    companyData: FullCompanyInfo;
    updateCompanyData: (data: Partial<FullCompanyInfo>) => void;
    onBack: () => void;
    onSuccess: () => void;
}> = ({ companyData, updateCompanyData, onBack, onSuccess }) => {

    if (!companyData.company_data || !companyData.employees) {
        return <div className="p-8 text-white w-full h-full flex items-center justify-center">A carregar...</div>;
    }

    const [companyName, setCompanyName] = useState(companyData.company_data.name);
    const [companyLogo, setCompanyLogo] = useState(companyData.company_data.logo_url);
    const [isSaving, setIsSaving] = useState(false);
    const [saveSuccess, setSaveSuccess] = useState(false);
    const [isSellModalOpen, setIsSellModalOpen] = useState(false);
    const [isTransferModalOpen, setIsTransferModalOpen] = useState(false);

    const [permissions, setPermissions] = useState<PermissionsState>(() => {
        try {
            const permsString = companyData.company_data?.permissions;
            if (permsString) {
                return JSON.parse(permsString);
            }
        } catch (e) {
            console.error("Falha ao fazer parse das permissões:", e);
        }
        return {
            canManageDashboard: true,
            canManageEmployees: true,
            canManageFleet: true,
            canManageFinances: true,
        };
    });
    
    // --- NOVO: Estado para o pagamento automático de salários ---
    const [autoSalary, setAutoSalary] = useState(!!companyData.company_data.salary_payment_enabled);

    const handleSaveChanges = async () => {
        if (isSaving || saveSuccess) return;
        setIsSaving(true);
        if (!companyName.trim()) {
            alert("O nome da empresa não pode ficar vazio.");
            setIsSaving(false);
            return;
        }
        const result = await fetchNui<any>('updateCompanySettings', {
            name: companyName,
            logo: companyLogo
        });
        setIsSaving(false);
        if (result.success) {
            updateCompanyData(result.updatedData);
            setSaveSuccess(true);
            setTimeout(() => setSaveSuccess(false), 2000);
        } else {
            alert(`Erro: ${result.message}`);
        }
    };

    const handleConfirmSellCompany = async () => {
        const result = await fetchNui<any>('sellCompany', {});
        setIsSellModalOpen(false);
        if (result.success) {
            onSuccess();
        } else {
            alert(`Erro: ${result.message}`);
        }
    };

    const handleConfirmTransfer = async (targetEmployeeId: number) => {
        const result = await fetchNui<any>('transferOwnership', { targetEmployeeId });
        setIsTransferModalOpen(false);
        if (result.success) {
            onSuccess();
        } else {
            alert(`Erro: ${result.message}`);
        }
    };

    const handleSavePermissions = async () => {
        setIsSaving(true);
        const result = await fetchNui<any>('updateManagerPermissions', { permissions });
        if (result.success) {
            updateCompanyData(result.updatedData);
            setSaveSuccess(true);
            setTimeout(() => setSaveSuccess(false), 2000);
        } else {
            alert(`Erro: ${result.message}`);
        }
        setIsSaving(false);
    };

    const togglePermission = (perm: keyof PermissionsState) => {
        setPermissions(prev => ({ ...prev, [perm]: !prev[perm] }));
    };

    // --- NOVA FUNÇÃO: Para ligar/desligar o pagamento automático ---
    const handleToggleAutoSalary = async () => {
        const newStatus = !autoSalary;
        setAutoSalary(newStatus);
        
        const result = await fetchNui<any>('toggleAutoSalary', { enabled: newStatus });
        
        if (result.success) {
            updateCompanyData(result.updatedData);
        } else {
            alert(`Erro: ${result.message}`);
            setAutoSalary(!newStatus);
        }
    };

    return (
        <div className="w-full h-full p-8 flex flex-col bg-gray-900">
            <AppHeader title="Configurações" onBack={onBack} logoUrl={companyData.company_data.logo_url} />
            <div className="overflow-y-auto pr-2">
                
                <div className="bg-gray-800 p-6 rounded-lg">
                    <h2 className="text-xl font-semibold text-white mb-4">Informações Gerais</h2>
                    <div className="space-y-4">
                        <div>
                            <label htmlFor="companyName" className="block text-sm font-medium text-gray-300 mb-1">Nome da Empresa</label>
                            <input
                                type="text" id="companyName" value={companyName} onChange={(e) => setCompanyName(e.target.value)}
                                className="w-full p-2 bg-gray-700 rounded-md text-white placeholder-gray-400 border border-gray-600 focus:outline-none focus:ring-2 focus:ring-blue-500"
                            />
                        </div>
                        <div>
                            <label htmlFor="companyLogo" className="block text-sm font-medium text-gray-300 mb-1">URL do Logo</label>
                            <div className="flex items-center gap-4 mt-2">
                                <img
                                    src={companyLogo} alt="Pré-visualização do Logo" className="w-16 h-16 rounded-md object-cover bg-gray-700"
                                    onError={(e) => { e.currentTarget.src = 'https://placehold.co/64x64/374151/FFFFFF?text=Logo'; }}
                                />
                                <input
                                    type="text" id="companyLogo" value={companyLogo} onChange={(e) => setCompanyLogo(e.target.value)}
                                    className="flex-1 p-2 bg-gray-700 rounded-md text-white placeholder-gray-400 border border-gray-600 focus:outline-none focus:ring-2 focus:ring-blue-500"
                                />
                            </div>
                        </div>
                    </div>

                    {/* NOVO: Opção de pagamento automático de salários */}
                    <div className="mt-6 pt-4 border-t border-gray-700">
                        <div className="flex justify-between items-center">
                            <div>
                                <p className="font-medium text-white">Pagamento Automático de Salários</p>
                                <p className="text-sm text-gray-400">Paga automaticamente os salários de todos os funcionários a cada hora.</p>
                            </div>
                            <SwitchToggle enabled={autoSalary} setEnabled={handleToggleAutoSalary} />
                        </div>
                    </div>

                    <div className="mt-6 flex justify-end">
                        <button
                            onClick={handleSaveChanges} disabled={isSaving || saveSuccess}
                            className={`py-2 px-5 rounded-md font-semibold transition-colors ${saveSuccess ? 'bg-green-600' : 'bg-blue-600 hover:bg-blue-500'} disabled:opacity-70`}
                        >
                            {isSaving ? 'A guardar...' : saveSuccess ? 'Guardado!' : 'Guardar Alterações'}
                        </button>
                    </div>
                </div>

                <div className="mt-8 bg-gray-800 p-6 rounded-lg">
                    <h2 className="text-xl font-semibold text-white mb-4">Permissões de Gerente</h2>
                    <p className="text-sm text-gray-400 mb-6">Controle a que painéis os seus gerentes têm acesso. Estas permissões não se aplicam a si.</p>
                    <div className="space-y-4">
                        <div className="flex justify-between items-center">
                            <span className="font-medium text-white">Acesso ao Dashboard</span>
                            <SwitchToggle enabled={permissions.canManageDashboard} setEnabled={() => togglePermission('canManageDashboard')} />
                        </div>
                        <div className="flex justify-between items-center">
                            <span className="font-medium text-white">Gerir Funcionários</span>
                            <SwitchToggle enabled={permissions.canManageEmployees} setEnabled={() => togglePermission('canManageEmployees')} />
                        </div>
                        <div className="flex justify-between items-center">
                            <span className="font-medium text-white">Gerir Frota</span>
                            <SwitchToggle enabled={permissions.canManageFleet} setEnabled={() => togglePermission('canManageFleet')} />
                        </div>
                        <div className="flex justify-between items-center">
                            <span className="font-medium text-white">Aceder às Finanças</span>
                            <SwitchToggle enabled={permissions.canManageFinances} setEnabled={() => togglePermission('canManageFinances')} />
                        </div>
                    </div>
                    <div className="mt-6 flex justify-end">
                        <button
                            onClick={handleSavePermissions} disabled={isSaving || saveSuccess}
                            className={`py-2 px-5 rounded-md font-semibold transition-colors ${saveSuccess ? 'bg-green-600' : 'bg-blue-600 hover:bg-blue-500'} disabled:opacity-70`}
                        >
                            {isSaving ? 'A guardar...' : saveSuccess ? 'Guardado!' : 'Guardar Permissões'}
                        </button>
                    </div>
                </div>

                <div className="mt-8 bg-red-900/50 border border-red-700 p-6 rounded-lg">
                    <h2 className="text-xl font-semibold text-red-300 mb-4">Zona de Perigo</h2>
                    <div className="flex justify-between items-center">
                        <div>
                            <p className="font-medium text-white">Vender a Empresa</p>
                            <p className="text-sm text-gray-300">Esta ação não pode ser desfeita. Todos os dados serão apagados.</p>
                        </div>
                        <button onClick={() => setIsSellModalOpen(true)} className="py-2 px-5 bg-red-600 hover:bg-red-500 rounded-md font-semibold transition-colors">Vender Empresa</button>
                    </div>
                    <div className="mt-4 pt-4 border-t border-red-700/50 flex justify-between items-center">
                        <div>
                            <p className="font-medium text-white">Transferir Propriedade</p>
                            <p className="text-sm text-gray-300">Transfere a posse total para outro funcionário.</p>
                        </div>
                        <button onClick={() => setIsTransferModalOpen(true)} className="py-2 px-5 bg-orange-600 hover:bg-orange-500 rounded-md font-semibold transition-colors">Transferir</button>
                    </div>
                </div>
            </div>

            <ConfirmationModal isOpen={isSellModalOpen} onClose={() => setIsSellModalOpen(false)} onConfirm={handleConfirmSellCompany} title="Confirmar Venda da Empresa" description="Esta ação é irreversível e irá apagar permanentemente a sua empresa." requiredConfirmationText={companyData.company_data.name} />
            <TransferOwnershipModal isOpen={isTransferModalOpen} onClose={() => setIsTransferModalOpen(false)} onConfirm={handleConfirmTransfer} employees={companyData.employees} companyName={companyData.company_data.name} />
        </div>
    );
};