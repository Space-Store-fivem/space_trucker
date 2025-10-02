// space_trucker/web/src/layouts/GarageMenu.tsx

import React from 'react';
import { fetchNui } from '../utils/fetchNui';

// Define a estrutura de um objeto de veículo
interface Vehicle {
    id: number;
    model: string;
    plate: string;
    status: string;
}

// Define as props para o componente GarageMenu
interface GarageMenuProps {
    vehicles: Vehicle[];
    onClose: () => void;
}

const GarageMenu: React.FC<GarageMenuProps> = ({ vehicles, onClose }) => {

    const handleSelectVehicle = (vehicleId: number) => {
        // Envia o ID do veículo selecionado de volta para o Lua
        fetchNui('space_trucker:garage_selectVehicle', { vehicleId: vehicleId });
        onClose(); // Fecha o menu imediatamente após a seleção
    };

    return (
        <div className="fixed inset-0 bg-black bg-opacity-60 flex justify-center items-center z-50 font-sans">
            <div className="bg-gray-800 text-white w-full max-w-lg rounded-lg shadow-lg p-6 border border-gray-700 animate-fade-in-down">
                {/* Cabeçalho */}
                <div className="flex justify-between items-center mb-4 border-b border-gray-700 pb-3">
                    <h2 className="text-2xl font-bold">Garagem da Empresa</h2>
                    <button
                        onClick={onClose}
                        className="text-gray-400 hover:text-white transition-colors"
                    >
                        <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                        </svg>
                    </button>
                </div>

                {/* Lista de Veículos */}
                <div className="max-h-[60vh] overflow-y-auto pr-2">
                    {vehicles.length > 0 ? (
                        vehicles.map((vehicle) => {
                            const isAvailable = vehicle.status === 'Na Garagem';
                            return (
                                <div key={vehicle.id} className="bg-gray-900/50 rounded-md p-4 mb-3 flex justify-between items-center border border-transparent hover:border-blue-500 transition-all">
                                    <div>
                                        <p className="font-semibold text-lg">{vehicle.model.charAt(0).toUpperCase() + vehicle.model.slice(1)}</p>
                                        <p className="text-sm text-gray-400 font-mono">{vehicle.plate}</p>
                                        <p className={`text-sm font-bold ${isAvailable ? 'text-green-400' : 'text-yellow-400'}`}>
                                            {vehicle.status}
                                        </p>
                                    </div>
                                    <button
                                        onClick={() => handleSelectVehicle(vehicle.id)}
                                        disabled={!isAvailable}
                                        className={`px-4 py-2 rounded-md font-semibold text-white transition-all duration-200 ${
                                            isAvailable
                                                ? 'bg-blue-600 hover:bg-blue-700 transform hover:scale-105'
                                                : 'bg-gray-600 cursor-not-allowed opacity-50'
                                        }`}
                                    >
                                        Retirar
                                    </button>
                                </div>
                            );
                        })
                    ) : (
                        <div className="bg-gray-900/50 rounded-md p-6 text-center">
                            <p className="font-semibold text-lg">A garagem está vazia.</p>
                            <p className="text-sm text-gray-400 mt-1">Adicione veículos através do painel da empresa.</p>
                        </div>
                    )}
                </div>
            </div>
        </div>
    );
};

export default GarageMenu;