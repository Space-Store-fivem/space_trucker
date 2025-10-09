// Em web/src/layouts/pages/company/TrailerGarage.tsx

import React, { useState, useEffect } from 'react';
import { fetchNui } from '../../../utils/fetchNui';
import AppHeader from '../../components/AppHeader';

// ✨ Interfaces atualizadas para incluir a imagem ✨
interface OwnedTrailer {
    id: number;
    model: string;
    plate: string;
    status: string;
    image?: string; // Adicionado
}

interface TrailerForSale {
    key: string;
    label: string;
    model: string;
    price: number;
    image?: string; // Adicionado
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
    }, [activeTab]);

    const handleWithdraw = (trailerId: number) => {
        fetchNui<{success: boolean}>('requestTrailerSpawn', { trailerId });
        // O fechamento do NUI agora é feito no client/c_trailer_garage.lua
    };

    const handlePurchase = async (trailerKey: string) => {
        setIsLoading(true);
        const result = await fetchNui<{success: boolean}>('requestTrailerPurchase', { trailerKey });
        if (result && result.success) {
            setActiveTab('garage');
        } else {
            setIsLoading(false);
        }
    };

    const renderTrailerCard = (children: React.ReactNode, image?: string) => (
        <div className="bg-gray-800/50 p-4 rounded-lg flex items-center border border-white/5 gap-4">
            {image && (
                <div className="w-32 h-20 flex-shrink-0 bg-black/30 rounded-md overflow-hidden">
                    <img src={image} alt="Trailer" className="w-full h-full object-cover" />
                </div>
            )}
            <div className="flex-grow flex justify-between items-center">
                {children}
            </div>
        </div>
    );

    const GarageView = () => (
        isLoading ? <p className="text-center text-gray-400 animate-pulse">A carregar sua garagem...</p> :
        ownedTrailers.length === 0 ? <p className="text-center text-gray-500">Nenhum trailer encontrado na sua empresa.</p> :
        <div className="space-y-3">
            {ownedTrailers.map((trailer) => (
                renderTrailerCard(
                    <>
                        <div>
                            <p className="font-bold text-lg uppercase">{trailer.model}</p>
                            <p className="text-sm text-gray-400">{trailer.plate}</p>
                        </div>
                        {trailer.status === 'Na Garagem' ? (
                            <button onClick={() => handleWithdraw(trailer.id)} className="bg-green-600 hover:bg-green-700 text-white font-bold py-2 px-4 rounded-lg transition-colors text-sm">Retirar</button>
                        ) : (
                            <p className="text-sm text-yellow-400 font-semibold">{trailer.status}</p>
                        )}
                    </>,
                    trailer.image
                )
            ))}
        </div>
    );

    const DealershipView = () => (
        isLoading ? <p className="text-center text-gray-400 animate-pulse">A carregar catálogo...</p> :
        trailersForSale.length === 0 ? <p className="text-center text-gray-500">Nenhum trailer configurado para venda.</p> :
        <div className="space-y-3">
            {trailersForSale.map((trailer) => (
                 renderTrailerCard(
                    <>
                        <div>
                            <p className="font-bold text-lg uppercase">{trailer.label}</p>
                            <p className="text-sm text-green-400 font-semibold">${trailer.price.toLocaleString()}</p>
                        </div>
                        <button onClick={() => handlePurchase(trailer.key)} className="bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-6 rounded-lg transition-colors text-sm">Comprar</button>
                    </>,
                    trailer.image
                )
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