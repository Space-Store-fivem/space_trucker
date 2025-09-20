// web/src/layouts/components/ConfirmationModal.tsx

import React, { useState, useEffect } from 'react';

export interface ConfirmationModalProps {
    isOpen: boolean;
    onClose: () => void;
    onConfirm: () => void;
    title: string;
    description: string;
    requiredConfirmationText?: string; // Tornamos esta propriedade opcional
}

const ConfirmationModal: React.FC<ConfirmationModalProps> = ({ isOpen, onClose, onConfirm, title, description, requiredConfirmationText }) => {
    const [confirmationInput, setConfirmationInput] = useState('');

    useEffect(() => {
        if (isOpen) {
            setConfirmationInput(''); // Limpa o input sempre que o modal abre
        }
    }, [isOpen]);

    if (!isOpen) return null;

    // CORREÇÃO: O botão só fica desativado se for necessário escrever E o texto não corresponder.
    // Se não for necessário escrever, o botão está sempre ativo.
    const isConfirmDisabled = requiredConfirmationText ? confirmationInput !== requiredConfirmationText : false;

    return (
        <div className="absolute inset-0 bg-black/70 flex items-center justify-center z-50">
            <div className="bg-gray-800 w-full max-w-lg rounded-lg p-8 border border-gray-700 flex flex-col gap-4">
                <h2 className="text-2xl font-bold text-red-400">{title}</h2>
                <p className="text-gray-300">{description}</p>
                
                {/* CORREÇÃO: O campo para escrever só aparece se for pedido */}
                {requiredConfirmationText && (
                    <div className="mt-2">
                        <label className="text-sm text-gray-400">
                            Para confirmar, por favor escreva: <span className="font-bold text-white">{requiredConfirmationText}</span>
                        </label>
                        <input
                            type="text"
                            value={confirmationInput}
                            onChange={(e) => setConfirmationInput(e.target.value)}
                            className="w-full p-2 mt-1 bg-gray-700 rounded-md text-white border border-gray-600"
                        />
                    </div>
                )}
                
                <div className="flex justify-end gap-4 mt-4">
                    <button onClick={onClose} className="py-2 px-6 bg-gray-600 hover:bg-gray-500 rounded-md font-semibold">Cancelar</button>
                    <button onClick={onConfirm} disabled={isConfirmDisabled} className="py-2 px-6 bg-red-600 hover:bg-red-500 rounded-md font-semibold disabled:opacity-50">
                        Confirmar
                    </button>
                </div>
            </div>
        </div>
    );
};

export default ConfirmationModal;