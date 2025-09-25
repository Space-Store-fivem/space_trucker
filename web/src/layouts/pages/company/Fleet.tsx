// src/layouts/pages/company/Fleet.tsx

import React, { useState, useEffect } from 'react';
import { FullCompanyInfo, FleetVehicle } from '../../../types';
import AppHeader from '../../components/AppHeader';
import { fetchNui } from '../../../utils/fetchNui';
import { IconPlus, IconMapPin, IconListDetails, IconRotateClockwise, IconTruck, IconClock, IconPhotoOff } from '@tabler/icons-react';
import { AddVehicleModal } from './AddVehicleModal';
import { SetGarageModal } from './SetGarageModal';
import { RentVehicle } from './RentVehicle';
import ConfirmationModal from '../../components/ConfirmationModal';

// Componente para buscar a imagem do veículo
const VehicleImage: React.FC<{ modelName: string; vehicleLabel: string }> = ({ modelName, vehicleLabel }) => {
    const [error, setError] = useState(false);
    const imgSrc = `https://docs.fivem.net/vehicles/${modelName.toLowerCase()}.webp`;

    if (error) {
        return (
            <div className="w-24 h-16 bg-gray-900/50 flex items-center justify-center rounded-md">
                <IconPhotoOff size={32} className="text-gray-600" />
            </div>
        );
    }
    
    return <img src={imgSrc} alt={vehicleLabel} className="w-24 h-16 object-cover rounded-md" onError={() => setError(true)} />;
};


// Componente para gerir a exibição do tempo de aluguer
const RentalInfo: React.FC<{ expiresAt: string }> = ({ expiresAt }) => {
    const calculateTimeLeft = () => {
        const difference = +new Date(expiresAt) - +new Date();
        let timeLeft: { [key: string]: number } = {};
        if (difference > 0) {
            timeLeft = {
                h: Math.floor(difference / (1000 * 60 * 60)),
                m: Math.floor((difference / 1000 / 60) % 60),
            };
        }
        return timeLeft;
    };
    const [timeLeft, setTimeLeft] = useState(calculateTimeLeft());
    useEffect(() => {
        const timer = setTimeout(() => setTimeLeft(calculateTimeLeft()), 60000);
        return () => clearTimeout(timer);
    });
    const timerComponents = Object.entries(timeLeft)
        .filter(([, value]) => value > 0)
        .map(([unit, value]) => `${value}${unit}`);
    return (
        <span className="text-xs text-cyan-300 flex items-center gap-1 font-mono">
            <IconClock size={14} />
            {timerComponents.length ? `Expira em: ${timerComponents.join(' ')}` : 'Expirado'}
        </span>
    );
};

const Fleet: React.FC<{
    companyData: FullCompanyInfo;
    onBack: () => void;
    onSuccess: () => void;
}> = ({ companyData, onBack, onSuccess }) => {
    const [view, setView] = useState<'list' | 'rent'>('list');
    const [isAddVehicleModalOpen, setAddVehicleModalOpen] = useState(false);
    const [isSetGarageModalOpen, setSetGarageModalOpen] = useState(false);
    const [notification, setNotification] = useState<string | null>(null);
    const [confirmModal, setConfirmModal] = useState<{ show: boolean; vehicle: FleetVehicle | null }>({ show: false, vehicle: null });

    if (!companyData.company_data || !companyData.fleet) {
        return <div className="p-8 text-white w-full h-full flex items-center justify-center">A carregar...</div>;
    }

    const handleSuccess = (message: string) => {
        setNotification(message);
        onSuccess();
        setTimeout(() => setNotification(null), 5000);
    };

    const handleReturnVehicle = (vehicle: FleetVehicle) => {
        setConfirmModal({ show: true, vehicle: vehicle });
    };

    const onConfirmReturn = async () => {
        if (confirmModal.vehicle) {
            const result = await fetchNui<any>('returnVehicleToOwner', { fleetId: confirmModal.vehicle.id });
            if (result && result.success) {
                handleSuccess(result.message || "Veículo devolvido com sucesso!");
            }
        }
        setConfirmModal({ show: false, vehicle: null });
    };

    const onCancelReturn = () => {
        setConfirmModal({ show: false, vehicle: null });
    };

    let garageCoords = null;
    try {
        if (companyData.company_data.garage_location) {
            garageCoords = JSON.parse(companyData.company_data.garage_location);
        }
    } catch (e) {}

    if (view === 'rent') {
        return (
            <RentVehicle
                companyData={companyData}
                onSuccess={handleSuccess}
                onBack={() => setView('list')}
            />
        );
    }

    return (
        <div className="w-full h-full p-8 flex flex-col bg-gray-900 relative">
            <AppHeader title="Gestão de Frota" onBack={onBack} logoUrl={companyData.company_data.logo_url} />

            {notification && (
                <div className="absolute top-24 left-1/2 -translate-x-1/2 bg-green-600/90 text-white font-semibold py-2 px-4 rounded-lg shadow-lg">
                    {notification}
                </div>
            )}

            <div className="flex justify-between items-center mb-4">
                <div className="text-sm text-gray-400">
                    <p>
                        Garagem: {garageCoords ? `Definida em (X: ${garageCoords.x.toFixed(0)}, Y: ${garageCoords.y.toFixed(0)})` : 'Não definida'}
                    </p>
                </div>
                <div className="flex gap-2">
                    <button onClick={() => setSetGarageModalOpen(true)} className="py-2 px-4 bg-yellow-600 hover:bg-yellow-500 rounded-lg font-semibold flex items-center gap-2">
                        <IconMapPin size={18} /> Definir Garagem
                    </button>
                    <button onClick={() => setView('rent')} className="py-2 px-4 bg-green-600 hover:bg-green-500 rounded-lg font-semibold flex items-center gap-2">
                        <IconTruck size={18} /> Alugar Veículos
                    </button>
                    <button onClick={() => setAddVehicleModalOpen(true)} className="py-2 px-4 bg-blue-600 hover:bg-blue-500 rounded-lg font-semibold flex items-center gap-2">
                        <IconPlus size={18} /> Adicionar Veículo
                    </button>
                </div>
            </div>

            <main className="flex-1 bg-black/20 rounded-lg p-4 overflow-y-auto">
                <div className="space-y-3">
                    {companyData.fleet.length > 0 ? (
                        companyData.fleet.map(vehicle => (
                            <div key={vehicle.id} className="flex justify-between items-center bg-gray-800/80 p-3 rounded-lg">
                                <div className="flex items-center gap-4">
                                    <VehicleImage modelName={vehicle.model} vehicleLabel={vehicle.model} />
                                    <div>
                                        <p className="font-bold text-white">{vehicle.model}</p>
                                        <div className="flex items-center gap-2 mt-1">
                                            <p className="text-sm text-gray-400 font-mono bg-gray-900 px-2 py-1 rounded-md inline-block">{vehicle.plate}</p>
                                            {vehicle.rent_expires_at && <RentalInfo expiresAt={vehicle.rent_expires_at} />}
                                        </div>
                                    </div>
                                </div>
                                <div className="flex items-center gap-2">
                                    <span className={`px-3 py-1 text-xs font-semibold rounded-full ${vehicle.status === 'Na Garagem' ? 'bg-green-500/20 text-green-300' : 'bg-yellow-500/20 text-yellow-300'}`}>
                                        {vehicle.status}
                                    </span>
                                    <button className="p-2 text-gray-400 hover:text-white hover:bg-gray-700 rounded-md" title="Ver Histórico">
                                        <IconListDetails size={20} />
                                    </button>
                                    {companyData.is_owner && !vehicle.rent_expires_at && (
                                        <button
                                            onClick={() => handleReturnVehicle(vehicle)}
                                            className="p-2 text-red-400 hover:text-white hover:bg-red-600/50 rounded-md"
                                            title="Devolver Veículo ao Dono"
                                        >
                                            <IconRotateClockwise size={20} />
                                        </button>
                                    )}
                                </div>
                            </div>
                        ))
                    ) : (
                        <div className="flex items-center justify-center h-full text-gray-400">A sua empresa não tem veículos na frota.</div>
                    )}
                </div>
            </main>

            <AddVehicleModal
                isOpen={isAddVehicleModalOpen}
                onClose={() => setAddVehicleModalOpen(false)}
                onSuccess={handleSuccess}
            />
            <SetGarageModal
                isOpen={isSetGarageModalOpen}
                onClose={() => setSetGarageModalOpen(false)}
                onSuccess={handleSuccess}
            />

            {confirmModal.show && (
                <ConfirmationModal
                    isOpen={confirmModal.show}
                    title="Confirmar Devolução"
                    description={`Tem a certeza que deseja devolver o veículo ${confirmModal.vehicle?.model} (${confirmModal.vehicle?.plate}) para a sua garagem pessoal? Esta ação não pode ser desfeita.`}
                    onConfirm={onConfirmReturn}
                    onClose={onCancelReturn}
                />
            )}
        </div>
    );
};

export default Fleet;