// Em web/src/layouts/pages/company/TrailerGarage.tsx

import React, { useState, useEffect } from 'react';
import { fetchNui } from '../../../utils/fetchNui';
import AppHeader from '../../components/AppHeader';
import { CompanyData } from '../../../types';
import { IconPhotoOff } from '@tabler/icons-react'; // Ícone para quando a imagem falha

// ## SEU COMPONENTE DE IMAGEM ADICIONADO AQUI ##
const VehicleImage: React.FC<{ modelName: string; vehicleLabel: string }> = ({ modelName, vehicleLabel }) => {
    const [error, setError] = useState(false);
    // URL dinâmica para as imagens dos veículos
    const imgSrc = `https://docs.fivem.net/vehicles/${modelName.toLowerCase()}.webp`;

    if (error || !modelName) {
        return (
            <div className="w-32 h-20 flex-shrink-0 bg-black/30 flex items-center justify-center rounded-md">
                <IconPhotoOff size={32} className="text-gray-600" />
            </div>
        );
    }
    
    return <img src={imgSrc} alt={vehicleLabel} className="w-32 h-20 flex-shrink-0 object-cover rounded-md bg-black/30" onError={() => setError(true)} />;
};

// Interfaces atualizadas (sem a propriedade 'image')
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

const handleCloseNui = () => {
    fetchNui('hide');
};

export const TrailerGarage: React.FC<{onBack: () => void, companyData: CompanyData}> = ({ onBack, companyData }) => {
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
        fetchNui('requestTrailerSpawn', { trailerId });
        handleCloseNui();
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

    // Card de exibição do trailer (agora usa o VehicleImage)
    const renderTrailerCard = (children: React.ReactNode, modelName: string, label: string) => (
        <div className="bg-gray-800/50 p-4 rounded-lg flex items-center border border-white/5 gap-4">
            <VehicleImage modelName={modelName} vehicleLabel={label} />
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
                    trailer.model, // Passa o nome do modelo para a imagem
                    trailer.model  // Passa o nome do modelo como label alternativo
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
                     trailer.model, // Passa o nome do modelo para a imagem
                     trailer.label  // Passa o label para a imagem
                 )
            ))}
        </div>
    );

    return (
        // ## LAYOUT CORRIGIDO, IDÊNTICO AO DAS CONFIGURAÇÕES ##
        <div className="w-full h-full p-8 flex flex-col bg-gray-900">
            <AppHeader title="Garagem de Trailers" onBack={onBack} logoUrl={companyData?.logo_url} />

            <div className="flex flex-col flex-grow mt-4 overflow-hidden">
                <div className="flex p-2 bg-gray-900/50">
                    <button onClick={() => setActiveTab('garage')} className={`flex-1 p-2 font-semibold text-center rounded-lg ${activeTab === 'garage' ? 'bg-blue-600 text-white' : 'text-gray-300 hover:bg-white/5'}`}>Minha Garagem</button>
                    <button onClick={() => setActiveTab('dealership')} className={`flex-1 p-2 font-semibold text-center rounded-lg ${activeTab === 'dealership' ? 'bg-blue-600 text-white' : 'text-gray-300 hover:bg-white/5'}`}>Concessionária</button>
                </div>
                <div className="p-4 overflow-y-auto flex-grow">
                    {activeTab === 'garage' ? <GarageView /> : <DealershipView />}
                </div>
            </div>
        </div>
    );
};