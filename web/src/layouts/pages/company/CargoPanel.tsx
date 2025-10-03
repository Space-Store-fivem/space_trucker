import React, { useState, useEffect, useMemo } from 'react';
import { fetchNui } from '../../../utils/fetchNui';
import { Search, ChevronDown } from 'lucide-react';

// Tipagens
interface VehicleInfo {
    label: string;
    capacity: number;
}
interface CargoInfo {
    itemName: string;
    itemLabel: string;
    transType: string;
    compatibleVehicles: VehicleInfo[];
}

// ==================================================================
// ============ ✨ 1. CABEÇALHO COPIADO DO LOGISTICS HUB ✨ ===========
// ==================================================================
const AppHeader: React.FC<{ title: string; onBack: () => void }> = ({ title, onBack }) => (
    <header className="flex items-center p-4 border-b border-white/10 sticky top-0 bg-gray-900/80 backdrop-blur-sm z-10">
        <button onClick={onBack} className="mr-4 text-white hover:text-blue-400 transition-colors">
            <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M15 19l-7-7 7-7" /></svg>
        </button>
        <h1 className="text-xl font-bold text-white">{title}</h1>
    </header>
);

// Componente para um item da lista expansível (Acordeão)
const CargoListItem: React.FC<{ cargo: CargoInfo }> = ({ cargo }) => {
    const [isOpen, setIsOpen] = useState(false);

    return (
        <div className="bg-gray-800/60 border border-white/10 rounded-lg overflow-hidden">
            <button 
                onClick={() => setIsOpen(!isOpen)}
                className="w-full flex justify-between items-center p-4 text-left hover:bg-white/5 transition-colors"
            >
                <div>
                    <h3 className="text-lg font-bold text-amber-400">{cargo.itemLabel}</h3>
                    <p className="text-xs text-gray-400">Tipo: <span className="font-semibold">{cargo.transType}</span></p>
                </div>
                <ChevronDown 
                    size={24} 
                    className={`text-gray-400 transition-transform duration-300 ${isOpen ? 'rotate-180' : ''}`} 
                />
            </button>

            {isOpen && (
                <div className="bg-black/30 px-4 pb-4 pt-2 border-t border-white/10">
                    <h4 className="text-md font-semibold text-white mb-2">Veículos Compatíveis:</h4>
                    <div className="space-y-1 text-sm pr-2 max-h-40 overflow-y-auto">
                        {cargo.compatibleVehicles.length > 0 ? (
                            cargo.compatibleVehicles.map((vehicle, index) => (
                                <div key={index} className="flex justify-between bg-black/40 px-3 py-1.5 rounded">
                                    <span>{vehicle.label}</span>
                                    <span className="text-gray-300">Capacidade: {vehicle.capacity}</span>
                                </div>
                            ))
                        ) : (
                            <p className="text-sm text-gray-500">Nenhum veículo compatível encontrado.</p>
                        )}
                    </div>
                </div>
            )}
        </div>
    );
};

// Componente principal do painel com layout corrigido
export const CargoPanel: React.FC<{ onBack: () => void }> = ({ onBack }) => {
    const [allCargoData, setAllCargoData] = useState<CargoInfo[]>([]);
    const [loading, setLoading] = useState(true);
    const [searchTerm, setSearchTerm] = useState('');

    useEffect(() => {
        setLoading(true);
        fetchNui<CargoInfo[]>('getCargoAndVehicleData').then(data => {
            setAllCargoData(data || []);
            setLoading(false);
        }).catch(() => {
            setLoading(false);
        });
    }, []);

    const filteredData = useMemo(() => {
        if (!searchTerm) return allCargoData;
        return allCargoData.filter(cargo => 
            cargo.itemLabel.toLowerCase().includes(searchTerm.toLowerCase())
        );
    }, [searchTerm, allCargoData]);

    return (
        <div className="flex flex-col w-full h-full bg-gray-900/80 backdrop-blur-md text-white">
            
            <AppHeader title="Painel de Cargas" onBack={onBack} />

            <div className="p-4 bg-gray-800/50 border-b border-white/10">
                <div className="relative">
                    <input
                        type="text"
                        placeholder="Pesquisar por nome da carga..."
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                        className="w-full bg-gray-700 border border-gray-600 rounded-lg py-2 pl-10 pr-4 focus:outline-none focus:border-blue-500"
                    />
                    <div className="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none">
                        <Search size={20} className="text-gray-400" />
                    </div>
                </div>
            </div>
            
            <div className="flex-grow p-4 overflow-y-auto">
                {loading ? (
                    <p className="text-center text-gray-400">A carregar dados das cargas...</p>
                ) : (
                    <div className="space-y-3">
                        {filteredData.length > 0 ? (
                             filteredData
                                .sort((a, b) => a.itemLabel.localeCompare(b.itemLabel))
                                .map(cargo => <CargoListItem key={cargo.itemName} cargo={cargo} />)
                        ) : (
                            <p className="text-center text-gray-500 col-span-full mt-10">Nenhuma carga encontrada com esse nome.</p>
                        )}
                    </div>
                )}
            </div>
        </div>
    );
};