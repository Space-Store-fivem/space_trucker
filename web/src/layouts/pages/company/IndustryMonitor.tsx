// web/src/layouts/pages/company/IndustryMonitor.tsx (VERSÃO FINAL CORRIGIDA)

import React, { useState, useEffect, useMemo } from 'react';
import { fetchNui } from '../../../utils/fetchNui';
import { IconArrowLeft, IconRefresh, IconSearch } from '@tabler/icons-react';

// Tipos de dados (sem alterações)
interface StockItem {
  label: string;
  stock: number;
  needed?: number;
  capacity?: number;
  price: number;
}
interface IndustryStatus {
  name: string;
  label: string;
  tier: number; // O servidor envia o número do Tier
  owner: string;
  status: 'Produzindo' | 'Parado' | 'Inativo';
  reason: string;
  inputs: StockItem[];
  outputs: StockItem[];
}

// Componente de item de estoque (sem alterações)
const StockItemDisplay: React.FC<{ item: StockItem; type: 'input' | 'output' }> = ({ item, type }) => {
    const isInput = type === 'input';
    const hasEnough = isInput ? item.stock >= (item.needed ?? 1) : false;
    const percentage = isInput ? Math.min((item.stock / (item.needed ?? 1)) * 100, 100) : Math.min((item.stock / (item.capacity ?? 100)) * 100, 100);
  
    return (
      <div>
          <div className="flex justify-between items-center text-xs text-gray-300">
              <span>{item.label}</span>
              <span className="font-mono text-cyan-400">${item.price.toLocaleString()}/un</span>
          </div>
          <div className="flex justify-between items-center text-xs text-gray-300 mt-0.5">
              <span className={`font-semibold ${isInput && !hasEnough ? 'text-red-400' : 'text-white'}`}>
                  {item.stock}
              </span>
              <span>{isInput ? `/ ${item.needed}` : `/ ${item.capacity}`}</span>
          </div>
        <div className="w-full bg-gray-700 rounded-full h-1.5 mt-1">
          <div 
            className={`h-1.5 rounded-full ${isInput ? (hasEnough ? 'bg-green-500' : 'bg-red-500') : 'bg-blue-500'}`} 
            style={{ width: `${percentage}%` }}
          ></div>
        </div>
      </div>
    );
};


export const IndustryMonitor: React.FC<{ onBack: () => void }> = ({ onBack }) => {
  const [allIndustries, setAllIndustries] = useState<IndustryStatus[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [filter, setFilter] = useState('all');

  const fetchData = () => {
    setIsLoading(true);
    fetchNui<IndustryStatus[]>('getIndustryStatus')
      .then(data => {
        data.sort((a, b) => (a.tier - b.tier) || a.label.localeCompare(b.label));
        setAllIndustries(data);
      })
      .catch(err => console.error("Erro ao buscar status das indústrias:", err))
      .finally(() => setIsLoading(false));
  };

  useEffect(() => {
    fetchData();
  }, []);

  const filteredIndustries = useMemo(() => {
    return allIndustries.filter(ind => {
      const matchesFilter = 
        filter === 'all' ||
        (filter === 'player' && ind.owner !== 'Sistema') ||
        (filter === 'system' && ind.owner === 'Sistema') ||
        (filter === 'producing' && ind.status === 'Produzindo') ||
        (filter === 'stopped' && ind.status === 'Parado') ||
        (filter === 'primary' && ind.tier === 1) ||
        (filter === 'secondary' && ind.tier === 2) ||
        (filter === 'tertiary' && ind.tier === 3);

      const matchesSearch = ind.label.toLowerCase().includes(searchTerm.toLowerCase());
      
      return matchesFilter && matchesSearch;
    });
  }, [allIndustries, searchTerm, filter]);

  const getStatusColor = (status: IndustryStatus['status']) => {
    if (status === 'Produzindo') return 'text-green-400';
    if (status === 'Parado') return 'text-red-400';
    return 'text-yellow-400';
  };

  // [[ CORREÇÃO DO TIER APLICADA AQUI ]]
  const getTierLabel = (tier: number) => {
    if (tier === 1) return 'Primária';
    if (tier === 2) return 'Secundária';
    if (tier === 3) return 'Terciária'; // Agora reconhece o número 3 corretamente
    return 'Desconhecido';
  }

  const FilterButton: React.FC<{ label: string; filterValue: string; }> = ({ label, filterValue }) => (
    <button 
        onClick={() => setFilter(filterValue)}
        className={`px-3 py-1 text-xs font-semibold rounded-full transition-colors ${filter === filterValue ? 'bg-blue-600 text-white' : 'bg-gray-700 hover:bg-gray-600 text-gray-300'}`}
    >
        {label}
    </button>
  );

  return (
    <div className="w-full h-full p-6 flex flex-col bg-gray-900 text-white">
      <header className="flex items-center justify-between pb-4 border-b border-white/10">
        <div className="flex items-center gap-4">
            <button onClick={onBack} className="text-gray-400 hover:text-white transition-colors">
                <IconArrowLeft size={24} />
            </button>
            <h1 className="text-2xl font-bold">Monitor da Economia</h1>
        </div>
        <button 
          onClick={fetchData} 
          className="p-2 bg-blue-600 hover:bg-blue-700 rounded-full transition-colors disabled:bg-gray-500"
          disabled={isLoading}
        >
          <IconRefresh className={isLoading ? 'animate-spin' : ''} size={20} />
        </button>
      </header>

      <div className="py-4 space-y-3">
        <div className="relative">
            <IconSearch className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-500" size={20} />
            <input 
                type="text"
                placeholder="Pesquisar indústria..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="w-full bg-gray-800 border border-white/10 rounded-lg pl-10 pr-4 py-2 text-white focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
        </div>
        <div className="flex flex-wrap gap-2">
            <FilterButton label="Todas" filterValue="all" />
            <FilterButton label="Produzindo" filterValue="producing" />
            <FilterButton label="Paradas" filterValue="stopped" />
            <FilterButton label="Primárias" filterValue="primary" />
            <FilterButton label="Secundárias" filterValue="secondary" />
            <FilterButton label="Terciárias" filterValue="tertiary" />
            <FilterButton label="Sistema" filterValue="system" />
            <FilterButton label="Jogadores" filterValue="player" />
        </div>
      </div>
      
      <div className="flex-grow overflow-y-auto pr-2 space-y-4 border-t border-white/10 pt-4">
        {isLoading ? (
          <p className="text-center text-gray-400">A carregar dados da economia...</p>
        ) : (
          filteredIndustries.map(ind => (
            <div key={ind.name} className="bg-gray-800 p-4 rounded-lg border border-white/10">
              <div className="flex justify-between items-start mb-3">
                <div>
                  <h2 className="text-lg font-bold">{ind.label}</h2>
                  <span className="text-xs font-semibold bg-gray-700 text-gray-300 px-2 py-0.5 rounded-full mr-2">{getTierLabel(ind.tier)}</span>
                  <span className="text-xs font-semibold bg-blue-900/50 text-blue-300 px-2 py-0.5 rounded-full">{ind.owner}</span>
                </div>
                <div className="text-right">
                  <p className={`font-bold text-lg ${getStatusColor(ind.status)}`}>{ind.status}</p>
                  {ind.status === 'Parado' && <p className="text-xs text-gray-400">{ind.reason}</p>}
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-x-6 gap-y-4">
                <div>
                  <h3 className="text-sm font-semibold text-gray-400 mb-2 border-b border-gray-700 pb-1">Matéria-Prima (Inputs)</h3>
                  <div className="space-y-3">
                    {ind.inputs.length > 0 ? (
                      ind.inputs.map(item => <StockItemDisplay key={item.label} item={item} type="input" />)
                    ) : ( <p className="text-xs text-gray-500">Nenhuma</p> )}
                  </div>
                </div>
                <div>
                  <h3 className="text-sm font-semibold text-gray-400 mb-2 border-b border-gray-700 pb-1">Produção (Outputs)</h3>
                  <div className="space-y-3">
                    {ind.outputs.length > 0 ? (
                      ind.outputs.map(item => <StockItemDisplay key={item.label} item={item} type="output" />)
                    ) : ( <p className="text-xs text-gray-500">Nenhuma</p> )}
                  </div>
                </div>
              </div>
            </div>
          ))
        )}
        {!isLoading && filteredIndustries.length === 0 && (
            <p className="text-center text-gray-500 py-8">Nenhuma indústria encontrada com os filtros atuais.</p>
        )}
      </div>
    </div>
  );
};