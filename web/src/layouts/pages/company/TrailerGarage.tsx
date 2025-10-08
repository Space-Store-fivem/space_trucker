import React, { useState, useEffect, useCallback } from 'react';
import { fetchNui } from '../../../utils/fetchNui';
import AppHeader from '../../components/AppHeader';

// Interfaces
interface OwnedTrailer {
    id: number;
    model: string;
    plate: string;
    status: string;
}

interface TrailerForSale {
    key: string;
    label: string;
    model: string;
    price: number;
}

type ActiveTab = 'garage' | 'dealership';

export const TrailerGarage: React.FC<{onBack: () => void}> = ({ onBack }) => {
    const [activeTab, setActiveTab] = useState<ActiveTab>('garage');
    const [ownedTrailers, setOwnedTrailers] = useState<OwnedTrailer[]>([]);
    const [trailersForSale, setTrailersForSale] = useState<TrailerForSale[]>([]);
    const [isLoading, setIsLoading] = useState(true);

    const fetchOwnedTrailers = () => {
        setIsLoading(true);
        fetchNui<OwnedTrailer[]>('getCompanyTrailers')
            .then(data => setOwnedTrailers(data || []))
            .finally(() => setIsLoading(false));
    };

    const fetchTrailersForSale = () => {
        setIsLoading(true);
        fetchNui<TrailerForSale[]>('getTrailersForSale')
            .then(data => setTrailersForSale(data.sort((a, b) => a.label.localeCompare(b.label)) || []))
            .finally(() => setIsLoading(false));
    };

    useEffect(() => {
        if (activeTab === 'garage') {
            fetchOwnedTrailers();
        } else {
            fetchTrailersForSale();
        }
    }, [activeTab]); // Removido callbacks da dependência para simplificar

    const handleWithdraw = (trailerId: number) => {
        fetchNui<{success: boolean}>('requestTrailerSpawn', { trailerId }).then(result => {
            if (result.success) {
                fetchNui('hideFrame');
            }
        });
    };

    // ✨ FUNÇÃO DE COMPRA CORRIGIDA ✨
    const handlePurchase = async (trailerKey: string) => {
        setIsLoading(true);
        const result = await fetchNui<{success: boolean}>('requestTrailerPurchase', { trailerKey });

        // Se a compra foi um sucesso, o servidor retorna 'success: true'
        if (result && result.success) {
            // Ao mudar a aba, o useEffect será acionado e recarregará a lista da garagem
            setActiveTab('garage');
        } else {
            // Se falhou, apenas para de carregar. O servidor já enviou a notificação de erro.
            setIsLoading(false);
        }
    };

    const GarageView = () => (
        isLoading ? <p className="text-center text-gray-400 animate-pulse">A carregar sua garagem...</p> :
        ownedTrailers.length === 0 ? <p className="text-center text-gray-500">Nenhum trailer encontrado na sua empresa.</p> :
        <div className="space-y-3">
            {ownedTrailers.map((trailer) => (
                <div key={trailer.id} className="bg-gray-800/50 p-4 rounded-lg flex justify-between items-center border border-white/5">
                    <div>
                        <p className="font-bold text-lg uppercase">{trailer.model}</p>
                        <p className="text-sm text-gray-400">{trailer.plate}</p>
                    </div>
                    {trailer.status === 'Na Garagem' ? (
                        <button onClick={() => handleWithdraw(trailer.id)} className="bg-green-600 hover:bg-green-700 text-white font-bold py-2 px-4 rounded-lg transition-colors text-sm">Retirar</button>
                    ) : (
                        <p className="text-sm text-yellow-400 font-semibold">{trailer.status}</p>
                    )}
                </div>
            ))}
        </div>
    );

    const DealershipView = () => (
        isLoading ? <p className="text-center text-gray-400 animate-pulse">A carregar catálogo...</p> :
        trailersForSale.length === 0 ? <p className="text-center text-gray-500">Nenhum trailer configurado para venda.</p> :
        <div className="space-y-3">
            {trailersForSale.map((trailer) => (
                <div key={trailer.key} className="bg-gray-800/50 p-4 rounded-lg flex justify-between items-center border border-white/5">
                    <div>
                        <p className="font-bold text-lg uppercase">{trailer.label}</p>
                        <p className="text-sm text-green-400 font-semibold">${trailer.price.toLocaleString()}</p>
                    </div>
                    <button onClick={() => handlePurchase(trailer.key)} className="bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-6 rounded-lg transition-colors text-sm">Comprar</button>
                </div>
            ))}
        </div>
    );

    return (
        <div className="flex flex-col w-full h-full">
            <AppHeader title="Garagem e Concessionária" onBack={onBack} />
            <div className="flex p-2 bg-gray-900/50">
                <button onClick={() => setActiveTab('garage')} className={`flex-1 p-2 font-semibold text-center rounded-lg ${activeTab === 'garage' ? 'bg-blue-600 text-white' : 'text-gray-300 hover:bg-white/5'}`}>Minha Garagem</button>
                <button onClick={() => setActiveTab('dealership')} className={`flex-1 p-2 font-semibold text-center rounded-lg ${activeTab === 'dealership' ? 'bg-blue-600 text-white' : 'text-gray-300 hover:bg-white/5'}`}>Concessionária</button>
            </div>
            <div className="p-4 overflow-y-auto">
                {activeTab === 'garage' ? <GarageView /> : <DealershipView />}
            </div>
        </div>
    );
};