// web/src/layouts/pages/company/Industries.tsx

import React, { useState, useEffect, useCallback } from 'react';
import { fetchNui } from '../../../utils/fetchNui';
import { CompanyData } from '../../../types';
import { useNuiEvent } from '../../../hooks/useNuiEvent';

// --- TIPAGEM E COMPONENTES AUXILIARES ---
interface Industry {
  name: string;
  label: string;
  tier: number;
  status: number;
  ownerName?: string;
}

interface IndustriesProps {
  onBack: () => void;
  companyData: CompanyData;
  onRefresh: () => void;
}

const AppHeader: React.FC<{ title: string; onBack: () => void }> = ({ title, onBack }) => (
    <header className="flex items-center p-4 border-b border-white/10 sticky top-0 bg-gray-900/80 backdrop-blur-sm z-10">
        <button onClick={onBack} className="mr-4 text-white hover:text-blue-400 transition-colors">
            <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M15 19l-7-7 7-7" /></svg>
        </button>
        <h1 className="text-xl font-bold text-white">{title}</h1>
    </header>
);

// --- COMPONENTE PRINCIPAL ---
export const Industries: React.FC<IndustriesProps> = ({ onBack, companyData, onRefresh }) => {
  const [industries, setIndustries] = useState<Industry[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [ownershipData, setOwnershipData] = useState<Record<string, string>>({});

  useNuiEvent<string>('setCompanyIndustries', (jsonData) => {
    try {
        const industryList = JSON.parse(jsonData);
        
        const combinedData = industryList.map((ind: Industry) => ({
          ...ind,
          ownerName: ownershipData[ind.name] || undefined,
        }));

        combinedData.sort((a: Industry, b: Industry) => a.label.localeCompare(b.label));
        setIndustries(combinedData);
    } catch (e) {
        console.error("Falha ao processar a lista de indústrias recebida:", e);
    } finally {
        setIsLoading(false);
    }
  });

  const fetchAllData = useCallback(async () => {
    setIsLoading(true);
    try {
      // A correção aqui é garantir que esperamos um objeto e temos um fallback
      const owners = await fetchNui<Record<string, string>>('getIndustryOwnershipData') || {};
      setOwnershipData(owners);
      
      // Agora que temos os donos, pedimos a lista completa de indústrias
      fetchNui('requestCompanyIndustries');
    } catch (err) {
      console.error("Erro ao iniciar o pedido de dados:", err);
      // Se a primeira chamada falhar, enviamos um pedido de indústrias mesmo assim.
      fetchNui('requestCompanyIndustries');
    }
  }, []);

  useEffect(() => {
    fetchAllData();
  }, [fetchAllData]);

  const handleBuyIndustry = async (industryName: string) => {
    const result = await fetchNui<{ success: boolean; message: string }>('buyIndustry', { industryName });
    if (result) {
        alert(result.message);
        if (result.success) {
            onRefresh();
            fetchAllData();
        }
    }
  };

  const handleSellIndustry = async (industryName: string) => {
    const result = await fetchNui<{ success: boolean; message: string }>('sellIndustry', { industryName });
    if (result) {
        alert(result.message);
        if (result.success) {
            onRefresh();
            fetchAllData();
        }
    }
  };

  const getTierLabel = (tier: number) => {
    if (tier === 1) return { text: 'Primária', color: 'bg-green-500' };
    if (tier === 2) return { text: 'Secundária', color: 'bg-blue-500' };
    if (tier === 3) return { text: 'Negócio', color: 'bg-purple-500' };
    return { text: 'Desconhecido', color: 'bg-gray-500' };
  };

  const renderActionButton = (industry: Industry) => {
    if (industry.ownerName) {
      if (industry.ownerName === companyData.name) {
        return <button onClick={() => handleSellIndustry(industry.name)} className="bg-red-600 hover:bg-red-700 text-white font-bold py-2 px-4 rounded-lg transition-colors text-sm">Vender</button>;
      } else {
        return <p className="text-sm text-gray-400 text-right">Proprietário:<br/><span className="font-bold">{industry.ownerName}</span></p>;
      }
    } else {
      return <button onClick={() => handleBuyIndustry(industry.name)} className="bg-green-600 hover:bg-green-700 text-white font-bold py-2 px-4 rounded-lg transition-colors text-sm">Comprar</button>;
    }
  };

  return (
    <div className="flex flex-col w-full h-full bg-gray-900/80 backdrop-blur-md text-white">
      <AppHeader title="Gestão de Indústrias" onBack={onBack} />
      <div className="flex-grow p-6 overflow-y-auto">
        {isLoading ? (
          <div className="flex justify-center items-center h-full"><p className="text-lg text-gray-400 animate-pulse">A carregar indústrias...</p></div>
        ) : (
          <div className="space-y-4">
            {industries.length > 0 ? (
              industries.map(industry => {
                const tierInfo = getTierLabel(industry.tier);
                return (
                  <div key={industry.name} className="bg-gray-800 p-4 rounded-lg flex justify-between items-center border border-white/5 shadow-md transition-transform hover:scale-[1.02]">
                    <div>
                      <h3 className="text-lg font-bold">{industry.label}</h3>
                      <span className={`px-2 py-1 text-xs font-semibold rounded-full text-white ${tierInfo.color}`}>{tierInfo.text}</span>
                    </div>
                    <div className="flex items-center gap-4">
                      {renderActionButton(industry)}
                    </div>
                  </div>
                )
              })
            ) : (
              <p className="text-center text-gray-500 mt-10">Nenhuma indústria encontrada no sistema.</p>
            )}
          </div>
        )}
      </div>
    </div>
  );
};

export default Industries;