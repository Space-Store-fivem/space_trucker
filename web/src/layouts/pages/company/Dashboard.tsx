import React from 'react';
import { FullCompanyInfo } from '../../../types';
import AppHeader from '../../components/AppHeader';

interface DashboardProps {
    companyData: FullCompanyInfo;
    onBack: () => void;
}

export const Dashboard: React.FC<DashboardProps> = ({ companyData, onBack }) => {
    // Adiciona uma verificação para garantir que os dados da empresa existem antes de os renderizar
    const { company_data, employees, fleet, transactions } = companyData;

    if (!company_data || !employees || !fleet || !transactions) {
        // Mostra uma mensagem de carregamento se os dados ainda não estiverem disponíveis
        return <div className="p-8 text-white w-full h-full flex items-center justify-center">A carregar dados da empresa...</div>;
    }

    return (
        <div className="w-full h-full p-8 flex flex-col bg-gray-900">
            <AppHeader title="Dashboard" onBack={onBack} logoUrl={company_data.logo_url} />
            
            <div className="overflow-y-auto pr-2">
                <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
                    {/* Card de Saldo */}
                    <div className="bg-gray-800 p-6 rounded-lg">
                        <h3 className="text-sm font-medium text-gray-400">Saldo da Empresa</h3>
                        <p className="mt-2 text-3xl font-bold text-green-400">${company_data.balance.toLocaleString()}</p>
                    </div>
                    {/* Card de Funcionários */}
                    <div className="bg-gray-800 p-6 rounded-lg">
                        <h3 className="text-sm font-medium text-gray-400">Total de Funcionários</h3>
                        <p className="mt-2 text-3xl font-bold text-white">{employees.length}</p>
                    </div>
                    {/* Card de Veículos */}
                    <div className="bg-gray-800 p-6 rounded-lg">
                        <h3 className="text-sm font-medium text-gray-400">Veículos na Frota</h3>
                        <p className="mt-2 text-3xl font-bold text-white">{fleet.length}</p>
                    </div>
                    {/* Card de Reputação */}
                    <div className="bg-gray-800 p-6 rounded-lg">
                        <h3 className="text-sm font-medium text-gray-400">Reputação</h3>
                        <p className="mt-2 text-3xl font-bold text-blue-400">{company_data.reputation}</p>
                    </div>
                </div>
                
                <div className="mt-8 bg-gray-800 p-6 rounded-lg">
                    <h2 className="text-xl font-semibold text-white mb-4">Atividade Recente</h2>
                    <div className="space-y-4">
                        {transactions.slice(0, 5).map(tx => (
                            <div key={tx.id} className="flex justify-between items-center text-sm border-b border-gray-700 pb-2 last:border-b-0">
                                <p className="text-gray-300">{tx.description}</p>
                                <p className={`font-semibold ${tx.amount >= 0 ? 'text-green-500' : 'text-red-500'}`}>
                                    ${tx.amount.toLocaleString()}
                                </p>
                                <p className="text-gray-500">{new Date(tx.timestamp).toLocaleString()}</p>
                            </div>
                        ))}
                        {transactions.length === 0 && (
                            <p className="text-gray-500 text-center py-4">Nenhuma transação recente.</p>
                        )}
                    </div>
                </div>
            </div>
        </div>
    );
};
