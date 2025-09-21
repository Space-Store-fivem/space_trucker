// NO FICHEIRO: web/src/layouts/pages/company/IndustryManagementPanel.tsx

import React, { useState, useEffect, useCallback } from 'react';
import { CompanyData } from '../../../types';
import { fetchNui } from '../../../utils/fetchNui';
import ConfirmationModal from '../../components/ConfirmationModal';
import { useNuiEvent } from '../../../hooks/useNuiEvent';

// --- TIPAGENS ---
interface Industry { name: string; label: string; }
interface ManagementData { investment_level: number; npc_workers: number; }
interface StockItem { inStock: number; storageSize: number; }
interface TradeData { FORSALE: Record<string, StockItem>; WANTED: Record<string, StockItem>; }
interface FullIndustryData { management: ManagementData; stock: TradeData; }

// --- PROPRIEDADES ---
interface IndustryManagementPanelProps {
  industry: Industry;
  companyData: CompanyData;
  onBack: () => void;
  onRefresh: () => void;
}

// --- COMPONENTES AUXILIARES ---
const AppHeader: React.FC<{ title: string; onBack: () => void }> = ({ title, onBack }) => (
    <header className="flex items-center p-4 border-b border-white/10 sticky top-0 bg-gray-900/80 backdrop-blur-sm z-10">
        <button onClick={onBack} className="mr-4 text-white hover:text-blue-400 transition-colors">
            <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M15 19l-7-7 7-7" /></svg>
        </button>
        <h1 className="text-xl font-bold text-white">{title}</h1>
    </header>
);
const StatCard: React.FC<{ label: string; value: string | number; }> = ({ label, value }) => (
    <div className="bg-gray-700 p-4 rounded-md text-center">
        <p className="text-sm text-gray-400">{label}</p>
        <p className="text-2xl font-bold text-white">{value}</p>
    </div>
);
const StockProgressBar: React.FC<{ current: number; max: number }> = ({ current, max }) => {
    const percentage = max > 0 ? (current / max) * 100 : 0;
    return (
        <div className="w-full bg-gray-700 rounded-full h-4">
            <div className="bg-blue-500 h-4 rounded-full" style={{ width: `${percentage}%` }}></div>
        </div>
    );
};

// --- PAINEL PRINCIPAL ---
export const IndustryManagementPanel: React.FC<IndustryManagementPanelProps> = ({ industry, onBack, onRefresh }) => {
  const [fullData, setFullData] = useState<FullIndustryData | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [modalState, setModalState] = useState<{isOpen: boolean; title: string; description: string; onConfirm: () => void} | null>(null);

  const fetchManagementData = useCallback(() => {
    setIsLoading(true);
    fetchNui<{ success: boolean; data: FullIndustryData }>('getIndustryManagementData', { industryName: industry.name })
      .then(result => {
        if (result && result.success) setFullData(result.data);
      }).finally(() => setIsLoading(false));
  }, [industry.name]);

  useEffect(() => { fetchManagementData(); }, [fetchManagementData]);

  // Ouve o "aviso" do servidor para recarregar os dados
  useNuiEvent<void>('managementUpdate', () => {
    onRefresh(); // Atualiza o saldo da empresa no painel principal
    fetchManagementData(); // Recarrega os dados deste painel
  });

  const handleInvest = () => {
    setModalState({
      isOpen: true,
      title: "Confirmar Investimento",
      description: `Deseja investir na indústria ${industry.label}?`,
      onConfirm: () => {
        fetchNui('investInIndustry', { industryName: industry.name });
        setModalState(null);
      }
    });
  };

  const handleHireNpc = () => {
    setModalState({
        isOpen: true,
        title: "Confirmar Contratação",
        description: `Deseja contratar um novo funcionário para ${industry.label}?`,
        onConfirm: () => {
            fetchNui('hireNpcForIndustry', { industryName: industry.name });
            setModalState(null);
        }
    });
  };

  const managementData = fullData?.management;
  const stockData = fullData?.stock;

  return (
    <>
      <ConfirmationModal
        isOpen={modalState?.isOpen || false}
        title={modalState?.title || ''}
        description={modalState?.description || ''}
        onConfirm={() => modalState?.onConfirm()}
        onClose={() => setModalState(null)}
      />
      <div className="flex flex-col w-full h-full bg-gray-900/80 backdrop-blur-md text-white">
        <AppHeader title={`Gerindo: ${industry.label}`} onBack={onBack} />
        {isLoading ? (
          <div className="flex justify-center items-center h-full"><p className="text-lg text-gray-400 animate-pulse">A carregar...</p></div>
        ) : (
          <div className="flex-grow p-6 overflow-y-auto space-y-8">
            <section className="bg-gray-800 p-4 rounded-lg border border-white/5">
                <h2 className="text-xl font-bold mb-4 text-blue-400">Produção e Stock</h2>
                <div className="space-y-4">
                    {stockData && Object.keys(stockData.FORSALE).length > 0 ? (
                        Object.entries(stockData.FORSALE).map(([itemName, itemData]) => (
                            <div key={itemName}>
                                <div className="flex justify-between items-center mb-1">
                                    <span className="font-bold capitalize">{itemName}</span>
                                    <span className="text-sm text-gray-400">{itemData.inStock} / {itemData.storageSize}</span>
                                </div>
                                <StockProgressBar current={itemData.inStock} max={itemData.storageSize} />
                            </div>
                        ))
                    ) : <p className="text-gray-500">Esta indústria não produz itens.</p>}
                </div>
            </section>
            <section className="bg-gray-800 p-4 rounded-lg border border-white/5">
              <h2 className="text-xl font-bold mb-4 text-cyan-400">Investimento</h2>
              <div className="grid grid-cols-2 gap-4">
                  <StatCard label="Nível de Investimento" value={managementData?.investment_level || 'N/A'} />
                  <StatCard label="Bónus de Produção" value={`${((managementData?.investment_level || 1) - 1) * 10}%`} />
              </div>
              <div className="mt-4">
                  <button onClick={handleInvest} className="w-full bg-cyan-600 hover:bg-cyan-700 text-white font-bold py-2 px-4 rounded-lg transition-colors">Investir</button>
              </div>
            </section>
            <section className="bg-gray-800 p-4 rounded-lg border border-white/5">
              <h2 className="text-xl font-bold mb-4 text-green-400">Funcionários</h2>
              <div className="grid grid-cols-2 gap-4">
                  <StatCard label="Funcionários Contratados" value={managementData?.npc_workers || 'N/A'} />
                  <StatCard label="Bónus de Eficiência" value={`${(managementData?.npc_workers || 0) * 2}%`} />
              </div>
              <div className="mt-4">
                  <button onClick={handleHireNpc} className="w-full bg-green-600 hover:bg-green-700 text-white font-bold py-2 px-4 rounded-lg transition-colors">Contratar</button>
              </div>
            </section>
          </div>
        )}
      </div>
    </>
  );
};

export default IndustryManagementPanel;