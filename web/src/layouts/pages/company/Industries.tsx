import React, { useState, useEffect, useCallback } from 'react';
import { fetchNui } from '../../../utils/fetchNui';
import { CompanyData } from '../../../types';
import { useNuiEvent } from '../../../hooks/useNuiEvent';
import ConfirmationModal from '../../components/ConfirmationModal';
import IndustryManagement from './IndustryManagement'; // Importe o novo component


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
  onSuccess: () => void;
}

const AppHeader: React.FC<{ title: string; onBack: () => void }> = ({ title, onBack }) => (
    <header className="flex items-center p-4 border-b border-white/10 sticky top-0 bg-gray-900/80 backdrop-blur-sm z-10">
        <button onClick={onBack} className="mr-4 text-white hover:text-blue-400 transition-colors">
            <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M15 19l-7-7 7-7" /></svg>
        </button>
        <h1 className="text-xl font-bold text-white">{title}</h1>
    </header>
);

export const Industries: React.FC<IndustriesProps> = ({ onBack, companyData, onSuccess }) => {
  const [industries, setIndustries] = useState<Industry[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [ownershipData, setOwnershipData] = useState<Record<string, string>>({});
  const [modalState, setModalState] = useState<{isOpen: boolean; title: string; description: string; onConfirm: () => void} | null>(null);
  const [managingIndustry, setManagingIndustry] = useState<Industry | null>(null);
  // ✨ ESTADO ADICIONADO PARA CONTROLAR O MODAL DE ERRO ✨
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  useNuiEvent<string>('setCompanyIndustries', (jsonData) => {
    try {
        const industryList = JSON.parse(jsonData);
        const combinedData = industryList.map((ind: Industry) => ({ ...ind, ownerName: ownershipData[ind.name] || undefined }));
        combinedData.sort((a: Industry, b: Industry) => a.label.localeCompare(b.label));
        setIndustries(combinedData);
    } catch (e) {
        console.error("Falha ao processar lista de indústrias:", e);
    } finally {
        setIsLoading(false);
    }
  });

  useNuiEvent<Record<string, string>>('setIndustryOwnership', (owners) => {
      setOwnershipData(owners || {});
      fetchNui('requestCompanyIndustries');
  });

  const fetchAllData = useCallback(() => {
    setIsLoading(true);
    fetchNui('requestIndustryOwnership');
  }, []);

  useEffect(() => {
    fetchAllData();
  }, [fetchAllData]);

  const openBuyModal = (industry: Industry) => setModalState({ isOpen: true, title: "Confirmar Compra", description: `Deseja comprar a indústria ${industry.label}?`, onConfirm: () => handleBuyIndustry(industry.name) });
  const openSellModal = (industry: Industry) => setModalState({ isOpen: true, title: "Confirmar Venda", description: `Deseja vender a indústria ${industry.label}?`, onConfirm: () => handleSellIndustry(industry.name) });

  const handleBuyIndustry = async (industryName: string) => {
    const result = await fetchNui<{ success: boolean; message: string }>('buyIndustry', { industryName });
    if (result) {
        if (result.success) {
            onSuccess();
            fetchAllData(); 
        } else {
            // ✨ AQUI DEFINIMOS A MENSAGEM DE ERRO PARA EXIBIR O MODAL ✨
            setErrorMessage(result.message || 'Ocorreu um erro desconhecido.');
        }
    }
    setModalState(null);
  };

  const handleSellIndustry = async (industryName: string) => {
    const result = await fetchNui<{ success: boolean; message: string }>('sellIndustry', { industryName });
    if (result) {
        if (result.success) {
            onSuccess(); 
            fetchAllData(); 
        } else {
            // ✨ TAMBÉM PODEMOS USAR PARA ERROS NA VENDA ✨
            setErrorMessage(result.message || 'Ocorreu um erro desconhecido.');
        }
    }
    setModalState(null);
  };

  // CORREÇÃO APLICADA AQUI
  const getTierLabel = (tier: number) => {
    if (tier === 1) return { text: 'Primária', color: 'bg-green-500' };
    if (tier === 2) return { text: 'Secundária', color: 'bg-blue-500' };
    if (tier === 3) return { text: 'Terciária', color: 'bg-yellow-500' };
    return { text: 'Desconhecido', color: 'bg-gray-500' };
  };

  const renderActionButton = (industry: Industry) => {
    if (industry.ownerName) {
      if (industry.ownerName === companyData.name) {
        return (
          <div className="flex space-x-2">
            <button onClick={() => setManagingIndustry(industry)} className="bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-lg transition-colors text-sm">Gerenciar</button>
            <button onClick={() => openSellModal(industry)} className="bg-red-600 hover:bg-red-700 text-white font-bold py-2 px-4 rounded-lg transition-colors text-sm">Vender</button>
          </div>
        );
      } else {
        return <p className="text-sm text-gray-400 text-right">Proprietário:<br/><span className="font-bold">{industry.ownerName}</span></p>;
      }
    } else {
      return <button onClick={() => openBuyModal(industry)} className="bg-green-600 hover:bg-green-700 text-white font-bold py-2 px-4 rounded-lg transition-colors text-sm">Comprar</button>;
    }
  };

  if (managingIndustry) {
    return <IndustryManagement industry={managingIndustry} onBack={() => setManagingIndustry(null)} companyData={companyData} onRefresh={onSuccess} />;
  }
  return (
    <>
      <ConfirmationModal
        isOpen={modalState?.isOpen || false}
        title={modalState?.title || ''}
        description={modalState?.description || ''}
        onConfirm={() => modalState?.onConfirm()}
        onClose={() => setModalState(null)}
      />

      {/* ✨ INÍCIO DO MODAL DE ERRO ✨ */}
      {errorMessage && (
          <div className="absolute inset-0 bg-black/60 flex items-center justify-center z-50">
              <div className="bg-gray-800 p-6 rounded-lg border border-red-500/50 max-w-sm text-center">
                  <h3 className="text-xl font-bold text-red-500 mb-4">Atenção!</h3>
                  <p className="text-gray-300 mb-6">{errorMessage}</p>
                  <div className="flex justify-center">
                      <button
                          onClick={() => setErrorMessage(null)}
                          className="bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-8 rounded-lg"
                      >
                          Ok
                      </button>
                  </div>
              </div>
          </div>
      )}
      {/* ✨ FIM DO MODAL DE ERRO ✨ */}

      <div className="flex flex-col w-full h-full bg-gray-900/80 backdrop-blur-md text-white">
        <AppHeader title="Gestão de Indústrias" onBack={onBack} />
        <div className="flex-grow p-6 overflow-y-auto">
          {isLoading ? (
            <div className="flex justify-center items-center h-full"><p className="text-lg text-gray-400 animate-pulse">A carregar...</p></div>
          ) : (
            <div className="space-y-4">
              {industries.map(industry => (
                  <div key={industry.name} className="bg-gray-800 p-4 rounded-lg flex justify-between items-center border border-white/5 shadow-md">
                    <div>
                      <h3 className="text-lg font-bold">{industry.label}</h3>
                      <span className={`px-2 py-1 text-xs font-semibold rounded-full text-white ${getTierLabel(industry.tier).color}`}>{getTierLabel(industry.tier).text}</span>
                    </div>
                    <div>{renderActionButton(industry)}</div>
                  </div>
              ))}
            </div>
          )}
        </div>
      </div>
    </>
  );
};

export default Industries;