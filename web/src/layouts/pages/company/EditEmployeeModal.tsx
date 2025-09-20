// web/src/layouts/pages/company/EditEmployeeModal.tsx

import React, { useState } from 'react';
import { Employee } from '../../../types';
import { fetchNui } from '../../../utils/fetchNui';

interface EditEmployeeModalProps {
    employee: Employee;
    onClose: () => void;
    onSuccess: (data: any) => void;
}

export const EditEmployeeModal: React.FC<EditEmployeeModalProps> = ({ employee, onClose, onSuccess }) => {
    const [role, setRole] = useState(employee.role);
    const [salary, setSalary] = useState(employee.salary.toString());
    const [isSaving, setIsSaving] = useState(false);

    const handleSave = async () => {
        setIsSaving(true);
        const result = await fetchNui<any>('updateEmployee', {
            employeeId: employee.id,
            role: role,
            salary: parseInt(salary)
        });

        if (result.success) {
            onSuccess(result.updatedData);
        } else {
            // Idealmente, mostrar uma notificação de erro
            alert(result.message);
        }
        setIsSaving(false);
    };

    return (
        <div className="absolute inset-0 bg-black/70 flex items-center justify-center z-50">
            <div className="bg-gray-800 w-full max-w-lg rounded-lg p-8 border border-gray-700 flex flex-col gap-6">
                <h2 className="text-2xl font-bold text-white">Editar Funcionário: {employee.name}</h2>
                <div className="space-y-4">
                    <div>
                        <label className="block text-sm font-medium text-gray-300 mb-1">Cargo</label>
                        <select value={role} onChange={e => setRole(e.target.value)} className="w-full p-3 bg-gray-700 rounded-md text-white border border-gray-600">
                            <option value="worker">Funcionário</option>
                            <option value="manager">Gerente</option>
                        </select>
                    </div>
                    <div>
                        <label className="block text-sm font-medium text-gray-300 mb-1">Salário</label>
                        <input type="number" value={salary} onChange={e => setSalary(e.target.value)} className="w-full p-3 bg-gray-700 rounded-md text-white border border-gray-600" />
                    </div>
                </div>
                <div className="flex justify-end gap-4 mt-4">
                    <button onClick={onClose} className="py-2 px-6 bg-gray-600 hover:bg-gray-500 rounded-md font-semibold">Cancelar</button>
                    <button onClick={handleSave} disabled={isSaving} className="py-2 px-6 bg-blue-600 hover:bg-blue-500 rounded-md font-semibold disabled:opacity-50">
                        {isSaving ? 'A Guardar...' : 'Guardar Alterações'}
                    </button>
                </div>
            </div>
        </div>
    );
};