// src/layouts/pages/company/TransferOwnershipModal.tsx

import React, { useState, useMemo } from 'react';
import { Employee } from '../../../types';

interface TransferOwnershipModalProps {
    isOpen: boolean;
    onClose: () => void;
    onConfirm: (targetEmployeeId: number) => void;
    employees: Employee[]; // A lista de funcionários vem das props
    companyName: string;
}

export const TransferOwnershipModal: React.FC<TransferOwnershipModalProps> = ({ isOpen, onClose, onConfirm, employees, companyName }) => {
    const [selectedEmployeeId, setSelectedEmployeeId] = useState<number | null>(null);
    const [confirmationText, setConfirmationText] = useState('');

    // =================================================================
    // >> LINHA CORRIGIDA <<
    // O erro de TypeScript desaparecerá assim que o tipo 'Employee' for corrigido no passo 1.
    // Esta lógica filtra o dono atual e os NPCs da lista de seleção.
    // =================================================================
    const selectableEmployees = useMemo(() => {
        // Garante que 'employees' é um array antes de tentar filtrar
        if (!Array.isArray(employees)) {
            return [];
        }
        return employees.filter(emp => emp.role !== 'owner' && !emp.is_npc);
    }, [employees]);

    const canConfirm = selectedEmployeeId !== null && confirmationText === companyName;

    const handleConfirm = () => {
        if (canConfirm && selectedEmployeeId) {
            onConfirm(selectedEmployeeId);
        }
    };
    
    const handleClose = () => {
        setSelectedEmployeeId(null);
        setConfirmationText('');
        onClose();
    };

    if (!isOpen) return null;

    return (
        <div className="absolute inset-0 bg-black/70 flex items-center justify-center z-50">
            <div className="bg-gray-800 w-full max-w-lg rounded-lg p-8 border border-gray-700 flex flex-col gap-6">
                <h2 className="text-2xl font-bold text-white">Transferir Propriedade da Empresa</h2>
                <p className="text-gray-400">Esta ação é irreversível. Você perderá o controlo total da empresa e passará a ser um funcionário com o cargo de 'Trabalhador'.</p>

                <div className="space-y-4">
                    <div>
                        <label className="block text-sm font-medium text-gray-300 mb-1">Selecione o Novo Dono</label>
                        <select
                            value={selectedEmployeeId ?? ''}
                            onChange={(e) => setSelectedEmployeeId(parseInt(e.target.value))}
                            className="w-full p-3 bg-gray-700 rounded-md text-white border border-gray-600"
                        >
                            <option value="" disabled>Selecione um funcionário...</option>
                            {selectableEmployees.map(emp => (
                                <option key={emp.id} value={emp.id}>{emp.name} ({emp.role})</option>
                            ))}
                        </select>
                    </div>
                    <div>
                        <label className="block text-sm font-medium text-gray-300 mb-1">
                            Para confirmar, escreva o nome da sua empresa: <span className="font-bold text-red-400">{companyName}</span>
                        </label>
                        <input
                            type="text"
                            value={confirmationText}
                            onChange={(e) => setConfirmationText(e.target.value)}
                            className="w-full p-3 bg-gray-700 rounded-md text-white border border-gray-600"
                        />
                    </div>
                </div>

                <div className="flex justify-end gap-4 mt-4">
                    <button onClick={handleClose} className="py-2 px-6 bg-gray-600 hover:bg-gray-500 rounded-md font-semibold">Cancelar</button>
                    <button
                        onClick={handleConfirm}
                        disabled={!canConfirm}
                        className="py-2 px-6 bg-red-600 hover:bg-red-500 rounded-md font-semibold disabled:opacity-50 disabled:cursor-not-allowed"
                    >
                        Transferir Propriedade
                    </button>
                </div>
            </div>
        </div>
    );
};