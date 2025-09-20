// src/layouts/pages/company/AddVehicleModal.tsx

import React, { useState, useEffect } from 'react';
import { fetchNui } from '../../../utils/fetchNui';

interface PlayerVehicle {
    plate: string;
    vehicle: string;
}

interface AddVehicleModalProps {
    isOpen: boolean;
    onClose: () => void;
    onSuccess: (message: string) => void;
}

export const AddVehicleModal: React.FC<AddVehicleModalProps> = ({ isOpen, onClose, onSuccess }) => {
    const [playerVehicles, setPlayerVehicles] = useState<PlayerVehicle[]>([]);
    const [selectedPlate, setSelectedPlate] = useState<string>('');
    const [error, setError] = useState<string | null>(null);
    const [isSubmitting, setIsSubmitting] = useState(false);
    const [isLoading, setIsLoading] = useState(true);

    useEffect(() => {
        if (isOpen) {
            setIsLoading(true);
            fetchNui<PlayerVehicle[]>('getPlayerVehicles', {})
                .then(vehicles => {
                    setPlayerVehicles(vehicles);
                    setIsLoading(false);
                });
        }
    }, [isOpen]);

    const handleAddVehicle = async () => {
        if (!selectedPlate) {
            setError("Por favor, selecione um veículo.");
            return;
        }
        setIsSubmitting(true);
        setError(null);

        const result = await fetchNui<{ success: boolean; message: string }>('addVehicleToFleet', { plate: selectedPlate });

        if (result.success) {
            onSuccess(result.message);
            onClose();
        } else {
            setError(result.message || "Ocorreu um erro desconhecido.");
        }
        setIsSubmitting(false);
    };
    
    const handleClose = () => {
        setSelectedPlate('');
        setError(null);
        onClose();
    };

    if (!isOpen) return null;

    return (
        <div className="absolute inset-0 bg-black/70 flex items-center justify-center z-50">
            <div className="bg-gray-800 w-full max-w-lg rounded-lg p-8 border border-gray-700 flex flex-col gap-6">
                <h2 className="text-2xl font-bold text-white">Adicionar Veículo à Frota</h2>
                <p className="text-gray-400">Selecione um dos seus veículos. Ao adicionar, a posse será transferida para a empresa.</p>
                
                {error && <p className="text-red-400 text-center">{error}</p>}

                <div>
                    <label htmlFor="vehicle-select" className="block text-sm font-medium text-gray-300 mb-1">Os seus Veículos</label>
                    {isLoading ? (
                        <p className="text-gray-400">A carregar veículos...</p>
                    ) : (
                        <select
                            id="vehicle-select"
                            value={selectedPlate}
                            onChange={(e) => setSelectedPlate(e.target.value)}
                            className="w-full p-3 bg-gray-700 rounded-md text-white border border-gray-600"
                        >
                            <option value="" disabled>Selecione um veículo...</option>
                            {playerVehicles.length > 0 ? (
                                playerVehicles.map(veh => (
                                    <option key={veh.plate} value={veh.plate}>
                                        {veh.vehicle.charAt(0).toUpperCase() + veh.vehicle.slice(1)} ({veh.plate})
                                    </option>
                                ))
                            ) : (
                                <option disabled>Você não tem veículos disponíveis para adicionar</option>
                            )}
                        </select>
                    )}
                </div>

                <div className="flex justify-end gap-4 mt-4">
                    <button onClick={handleClose} className="py-2 px-6 bg-gray-600 hover:bg-gray-500 rounded-md font-semibold">Cancelar</button>
                    <button
                        onClick={handleAddVehicle}
                        disabled={isSubmitting || isLoading || !selectedPlate}
                        className="py-2 px-6 bg-blue-600 hover:bg-blue-500 rounded-md font-semibold disabled:opacity-50"
                    >
                        {isSubmitting ? 'A Adicionar...' : 'Confirmar Adição'}
                    </button>
                </div>
            </div>
        </div>
    );
};