// src/layouts/pages/company/RentVehicleModal.tsx
import React, { useState, useEffect } from 'react';
import { fetchNui } from '../../../utils/fetchNui';
import { IconX, IconTruck, IconLock } from '@tabler/icons-react';

interface RentableVehicle {
    name: string;
    label: string;
    capacity: number;
    level: number;
    rentPrice: number;
    transType: string[];
}

interface FetchResponse {
    trucks: RentableVehicle[];
    playerLevel: number; // Note: This now represents company reputation
}

interface Props {
    isOpen: boolean;
    onClose: () => void;
    onSuccess: (message: string) => void;
}

export const RentVehicleModal: React.FC<Props> = ({ isOpen, onClose, onSuccess }) => {
    const [vehicles, setVehicles] = useState<RentableVehicle[]>([]);
    const [playerLevel, setPlayerLevel] = useState(1); // Represents company reputation
    const [isLoading, setIsLoading] = useState(false);

    useEffect(() => {
        if (isOpen) {
            setIsLoading(true);
            fetchNui<FetchResponse>('getCompanyRentableVehicles')
                .then(data => {
                    setVehicles(data?.trucks || []);
                    setPlayerLevel(data?.playerLevel || 1);
                    setIsLoading(false);
                })
                .catch(() => setIsLoading(false));
        }
    }, [isOpen]);

    const handleRent = async (vehicleName: string) => {
        const result = await fetchNui<any>('rentCompanyVehicle', { vehicleName });
        if (result && result.success) {
            onSuccess(result.message || 'Veículo alugado com sucesso e adicionado à sua garagem!');
            onClose();
        }
    };

    if (!isOpen) return null;

    return (
        <div className="fixed inset-0 bg-black/70 flex items-center justify-center z-50">
            <div className="bg-gray-800 rounded-lg shadow-xl w-full max-w-2xl max-h-[80vh] flex flex-col">
                <div className="p-4 flex justify-between items-center border-b border-gray-700">
                    <h2 className="text-xl font-semibold text-white">Alugar Veículo para a Frota</h2>
                    <button onClick={onClose} className="text-gray-400 hover:text-white">
                        <IconX />
                    </button>
                </div>
                <div className="flex-1 p-4 overflow-y-auto">
                    {isLoading ? (
                        <p className="text-center text-gray-400">A carregar veículos...</p>
                    ) : (
                        <div className="space-y-3">
                            {vehicles.map(vehicle => {
                                const companyRep = parseInt(String(playerLevel), 10);
                                const requiredRep = parseInt(String(vehicle.level), 10);
                                const canRent = companyRep >= requiredRep;

                                return (
                                    <div key={vehicle.name} className={`bg-gray-900/80 p-3 rounded-lg flex justify-between items-center ${!canRent ? 'opacity-60' : ''}`}>
                                        <div>
                                            <p className="font-bold text-white">{vehicle.label}</p>
                                            <p className="text-sm text-gray-400">Capacidade: {vehicle.capacity} | Custo: ${vehicle.rentPrice.toLocaleString()}</p>
                                        </div>
                                        <button
                                            onClick={() => canRent && handleRent(vehicle.name)}
                                            disabled={!canRent}
                                            className={`py-2 px-4 rounded-lg font-semibold flex items-center gap-2 transition-all duration-200 ${
                                                canRent 
                                                ? 'bg-green-600 hover:bg-green-500 cursor-pointer' 
                                                : 'bg-gray-700 cursor-not-allowed'
                                            }`}
                                        >
                                            {canRent ? (
                                                <><IconTruck size={18} /> Alugar</>
                                            ) : (
                                                <><IconLock size={18} /> Reputação {vehicle.level}</>
                                            )}
                                        </button>
                                    </div>
                                );
                            })}
                            <div className="h-2"></div>
                        </div>
                    )}
                </div>
            </div>
        </div>
    );
};