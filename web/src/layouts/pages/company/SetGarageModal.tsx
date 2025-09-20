// src/layouts/pages/company/SetGarageModal.tsx

import React, { useState } from 'react';
import { fetchNui } from '../../../utils/fetchNui';

interface SetGarageModalProps {
    isOpen: boolean;
    onClose: () => void;
    onSuccess: (message: string) => void;
}

export const SetGarageModal: React.FC<SetGarageModalProps> = ({ isOpen, onClose, onSuccess }) => {
    const [isSubmitting, setIsSubmitting] = useState(false);

    const handleSetLocation = async () => {
        setIsSubmitting(true);
        const result = await fetchNui<{ success: boolean; message: string }>('setGarageLocation', {});

        if (result.success) {
            onSuccess(result.message);
            onClose();
        } else {
            alert(`Erro: ${result.message}`);
        }
        setIsSubmitting(false);
    };

    if (!isOpen) return null;

    return (
        <div className="absolute inset-0 bg-black/70 flex items-center justify-center z-50">
            <div className="bg-gray-800 w-full max-w-lg rounded-lg p-8 border border-gray-700 flex flex-col gap-6 text-center">
                <h2 className="text-2xl font-bold text-white">Definir Local da Garagem</h2>
                <p className="text-gray-400">Posicione-se no local exato onde deseja que a garagem da sua empresa seja definida e clique no botão abaixo.</p>
                
                <div className="flex flex-col items-center justify-center gap-4 mt-4">
                    <button
                        onClick={handleSetLocation}
                        disabled={isSubmitting}
                        className="py-3 px-8 bg-yellow-600 hover:bg-yellow-500 rounded-md font-semibold disabled:opacity-50 text-lg"
                    >
                        {isSubmitting ? 'A Definir...' : 'Definir Localização Atual'}
                    </button>
                    <button onClick={onClose} className="text-gray-400 hover:text-white text-sm">Cancelar</button>
                </div>
            </div>
        </div>
    );
};