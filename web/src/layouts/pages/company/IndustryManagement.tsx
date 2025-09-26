// web/src/layouts/pages/company/IndustryManagement.tsx

import React, { useState, useEffect } from 'react';
import { fetchNui } from '../../../utils/fetchNui';
import { CompanyData, Industry } from '../../../types';
import { useNuiEvent } from '../../../hooks/useNuiEvent';
import { CreateOrderModal } from './CreateOrderModal'; // Importamos o novo modal

interface IndustryManagementProps {
  industry: Industry;
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

const IndustryManagement: React.FC<IndustryManagementProps> = ({ industry, onBack, companyData, onRefresh }) => {
  const [activeTab, setActiveTab] = useState('invest');
  const [industryDetails, setIndustryDetails] = useState<any>(null);
  const [isLoading, setIsLoading] = useState(true);

  // --- NOVO: Estados para gerir o modal de criação de encomenda ---
  const [isOrderModalOpen, setOrderModalOpen] = useState(false);
  const [selectedItemToOrder, setSelectedItemToOrder] = useState<{ name: string; label: string } | null>(null);

  useEffect(() => {
    fetchNui('getIndustryDetails', { industryName: industry.name }).then(details => {
      setIndustryDetails(details);
      setIsLoading(false);
    });
  }, [industry.name]);

  const handleInvest = () => {
    fetchNui('investInIndustry', { industryName: industry.name }).then(response => {
        if(response.success) {
            setIndustryDetails(response.updatedData);
            onRefresh();
        }
    });
  };

  const handleHireNpc = () => {
    fetchNui('hireNpcForIndustry', { industryName: industry.name }).then(response => {
        if(response.success) {
            setIndustryDetails(response.updatedData);
            onRefresh();
        }
    });
  };
  
  // --- NOVO: Função para abrir o modal de encomenda ---
  const handleOpenOrderModal = (itemName: string, itemLabel: string) => {
    setSelectedItemToOrder({ name: itemName, label: itemLabel });
    setOrderModalOpen(true);
  };

  return (
    <>
      {/* --- NOVO: Renderização condicional do modal --- */}
      {isOrderModalOpen && selectedItemToOrder && (
        <CreateOrderModal 
            itemName={selectedItemToOrder.name}
            itemLabel={selectedItemToOrder.label}
            industryName={industry.name}
            onClose={() => setOrderModalOpen(false)}
            onSuccess={() => {
                onRefresh(); // Atualiza os dados da empresa
                fetchNui('getIndustryDetails', { industryName: industry.name }).then(setIndustryDetails); // Atualiza os detalhes da indústria
            }}
        />
      )}

      <div className="flex flex-col w-full h-full bg-gray-900/80 backdrop-blur-md text-white">
        <AppHeader title={`Gerenciando: ${industry.label}`} onBack={onBack} />
        <div className="flex-grow p-6 overflow-y-auto">
          <div className="border-b border-gray-700 mb-4">
            <nav className="-mb-px flex space-x-8">
              <button onClick={() => setActiveTab('invest')} className={`whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm ${activeTab === 'invest' ? 'border-blue-500 text-blue-400' : 'border-transparent text-gray-400 hover:text-gray-200 hover:border-gray-500'}`}>Investir</button>
              <button onClick={() => setActiveTab('npcs')} className={`whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm ${activeTab === 'npcs' ? 'border-blue-500 text-blue-400' : 'border-transparent text-gray-400 hover:text-gray-200 hover:border-gray-500'}`}>Funcionários NPC</button>
              {/* --- NOVO: Aba de Matérias-Primas --- */}
              <button onClick={() => setActiveTab('inputs')} className={`whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm ${activeTab === 'inputs' ? 'border-blue-500 text-blue-400' : 'border-transparent text-gray-400 hover:text-gray-200 hover:border-gray-500'}`}>Matérias-Primas</button>
              <button onClick={() => setActiveTab('stock')} className={`whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm ${activeTab === 'stock' ? 'border-blue-500 text-blue-400' : 'border-transparent text-gray-400 hover:text-gray-200 hover:border-gray-500'}`}>Estoque</button>
            </nav>
          </div>

          {isLoading ? (
            <div className="flex justify-center items-center h-full"><p className="text-lg text-gray-400 animate-pulse">A carregar...</p></div>
          ) : (
            <div>
              {activeTab === 'invest' && (
                <div>
                  <h2 className="text-2xl font-bold mb-4">Investimento</h2>
                  <div className="bg-gray-800 p-4 rounded-lg">
                    <p className="mb-2">Nível de Investimento Atual: <span className="font-bold text-green-400">{industryDetails?.investment_level || 0}</span></p>
                    <p className="mb-4">Cada nível de investimento aumenta a produção.</p>
                    <button onClick={handleInvest} className="bg-green-600 hover:bg-green-700 text-white font-bold py-2 px-4 rounded-lg">Investir $50,000</button>
                  </div>
                </div>
              )}

              {activeTab === 'npcs' && (
                <div>
                  <h2 className="text-2xl font-bold mb-4">Funcionários NPC</h2>
                  <div className="bg-gray-800 p-4 rounded-lg">
                    <p className="mb-2">NPCs Contratados: <span className="font-bold text-blue-400">{industryDetails?.npc_workers || 0} / 10</span></p>
                    <p className="mb-4">NPCs aumentam a eficiência da produção.</p>
                    <button onClick={handleHireNpc} className="bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-lg">Contratar NPC por $10,000</button>
                  </div>
                </div>
              )}

              {/* --- NOVO: Conteúdo da Aba de Matérias-Primas --- */}
              {activeTab === 'inputs' && (
                  <div>
                      <h2 className="text-2xl font-bold mb-4">Matérias-Primas Necessárias</h2>
                      <div className="space-y-4">
                          {industryDetails?.inputs && Object.keys(industryDetails.inputs).length > 0 ? (
                              Object.entries(industryDetails.inputs).map(([itemName, itemData]: [string, any]) => (
                                  <div key={itemName} className="bg-gray-800 p-4 rounded-lg flex justify-between items-center">
                                      <div>
                                          <h3 className="text-lg font-bold">{itemData.label}</h3>
                                          <p className="text-sm text-gray-400">Em estoque: {itemData.inStock} / {itemData.storageSize}</p>
                                      </div>
                                      <button 
                                          onClick={() => handleOpenOrderModal(itemName, itemData.label)}
                                          className="bg-amber-600 hover:bg-amber-700 text-white font-bold py-2 px-4 rounded-lg transition-colors text-sm"
                                      >
                                          Encomendar
                                      </button>
                                  </div>
                              ))
                          ) : (
                              <p className="text-gray-500">Esta indústria não necessita de matérias-primas.</p>
                          )}
                      </div>
                  </div>
              )}

              {activeTab === 'stock' && (
                <div>
                  <h2 className="text-2xl font-bold mb-4">Estoque de Produtos</h2>
                    <div className="space-y-4">
                        {industryDetails?.products && Object.keys(industryDetails.products).length > 0 ? (
                            Object.entries(industryDetails.products).map(([productName, productData]: [string, any]) => (
                                <div key={productName} className="bg-gray-800 p-4 rounded-lg flex justify-between items-center">
                                    <div>
                                        <h3 className="text-lg font-bold">{productData.label}</h3>
                                        <p className="text-sm text-gray-400">Em estoque: {productData.inStock} / {productData.storageSize}</p>
                                    </div>
                                    <div className="text-right">
                                        <p className="font-bold text-green-400">${productData.price}</p>
                                        <p className="text-xs text-gray-500">por unidade</p>
                                    </div>
                                </div>
                            ))
                        ) : (
                            <p>Esta indústria não vende produtos diretamente.</p>
                        )}
                    </div>
                </div>
              )}
            </div>
          )}
        </div>
      </div>
    </>
  );
};

export default IndustryManagement;