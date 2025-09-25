// src/layouts/pages/company/RentVehicle.tsx
import React, { useState, useEffect } from 'react';
import { fetchNui } from '../../../utils/fetchNui';
import { IconTruck, IconLock, IconPhotoOff } from '@tabler/icons-react';
import AppHeader from '../../components/AppHeader';
import { FullCompanyInfo } from '../../../types';

// Interface atualizada
interface RentableVehicle {
    key: string | number; // Identificador único
    model: string;        // Nome do modelo para a imagem
    label: string;
    capacity: number;
    level: number;
    rentPrice: number;
}

interface FetchResponse {
    trucks: RentableVehicle[];
    playerLevel: number;
}

interface Props {
    companyData: FullCompanyInfo;
    onBack: () => void;
    onSuccess: (message: string) => void;
}

const VehicleImage: React.FC<{ modelName: string; vehicleLabel: string }> = ({ modelName, vehicleLabel }) => {
    const [error, setError] = useState(false);
    const imgSrc = `https://docs.fivem.net/vehicles/${modelName.toLowerCase()}.webp`;

    if (error) {
        return (
            <div className="w-full h-40 bg-gray-900/50 flex items-center justify-center rounded-t-lg">
                <IconPhotoOff size={48} className="text-gray-600" />
            </div>
        );
    }
    
    return <img src={imgSrc} alt={vehicleLabel} className="w-full h-40 object-cover" onError={() => setError(true)} />;
};

export const RentVehicle: React.FC<Props> = ({ companyData, onBack, onSuccess }) => {
    const [vehicles, setVehicles] = useState<RentableVehicle[]>([]);
    const [playerLevel, setPlayerLevel] = useState(1);
    const [isLoading, setIsLoading] = useState(true);

    if (!companyData || !companyData.company_data) {
        return <div className="p-8 text-white w-full h-full flex items-center justify-center">A carregar...</div>;
    }

    useEffect(() => {
        setIsLoading(true);
        fetchNui<FetchResponse>('getCompanyRentableVehicles')
            .then(data => {
                setVehicles(data?.trucks || []);
                setPlayerLevel(data?.playerLevel || 1);
                setIsLoading(false);
            })
            .catch(() => setIsLoading(false));
    }, []);

    const handleRent = async (vehicleKey: string | number) => {
        // Enviamos a CHAVE para o NUI callback
        const result = await fetchNui<{ success: boolean; message: string }>('rentCompanyVehicle', { vehicleName: vehicleKey });
        if (result && result.success) {
            onSuccess(result.message || 'Veículo alugado com sucesso!');
            onBack();
        }
    };

    return (
        <div className="w-full h-full p-8 flex flex-col bg-gray-900 relative">
            <AppHeader title="Alugar Veículos para a Frota" onBack={onBack} logoUrl={companyData.company_data.logo_url} />
            <main className="flex-1 bg-black/20 rounded-lg p-4 overflow-y-auto mt-4">
                {isLoading ? ( <p className="text-center text-gray-400">A carregar veículos...</p> ) : (
                    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">
                        {vehicles.map(vehicle => {
                            const canRent = playerLevel >= vehicle.level;
                            return (
                                <div key={vehicle.key} className={`bg-gray-800 rounded-lg shadow-lg flex flex-col overflow-hidden transition-all duration-300 ${!canRent ? 'opacity-60' : 'hover:scale-105 hover:shadow-cyan-500/20'}`}>
                                    {/* Usamos vehicle.model para a imagem */}
                                    <VehicleImage modelName={vehicle.model} vehicleLabel={vehicle.label} />
                                    <div className="p-4 flex flex-col flex-grow">
                                        <h3 className="text-lg font-bold text-white truncate">{vehicle.label}</h3>
                                        <div className="text-sm text-gray-400 mt-1 space-y-1">
                                            <p>Capacidade: <span className="font-semibold text-gray-300">{vehicle.capacity}</span></p>
                                            <p>Custo: <span className="font-semibold text-green-400">${vehicle.rentPrice.toLocaleString()}</span></p>
                                        </div>
                                        <div className="mt-auto pt-4">
                                            <button
                                                onClick={() => canRent && handleRent(vehicle.key)} // Enviamos a CHAVE ao clicar
                                                disabled={!canRent}
                                                className={`w-full py-2 px-4 rounded-lg font-semibold flex items-center justify-center gap-2 transition-all duration-200 ${ canRent ? 'bg-green-600 hover:bg-green-500 text-white cursor-pointer' : 'bg-gray-700 text-gray-400 cursor-not-allowed'}`}>
                                                {canRent ? <><IconTruck size={18} /> Alugar Agora</> : <><IconLock size={18} /> Reputação {vehicle.level}</>}
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            );
                        })}
                    </div>
                )}
            </main>
        </div>
    );
};