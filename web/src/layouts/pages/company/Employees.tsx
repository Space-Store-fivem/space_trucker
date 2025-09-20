// web/src/layouts/pages/company/Employees.tsx

import React, { useState, useMemo } from 'react';
import { FullCompanyInfo, Employee } from '../../../types';
import AppHeader from '../../components/AppHeader';
import ConfirmationModal from '../../components/ConfirmationModal';
import { fetchNui } from '../../../utils/fetchNui';
import { EditEmployeeModal } from './EditEmployeeModal';

// O componente EmployeeRow permanece o mesmo, mas agora só será usado para funcionários normais.
const EmployeeRow: React.FC<{ employee: Employee; onFire: (e: Employee) => void; onEdit: (e: Employee) => void; }> = ({ employee, onFire, onEdit }) => {
    return (
        <div className="flex justify-between items-center bg-gray-800/80 p-3 rounded-lg">
            <div>
                <p className="font-bold text-white">{employee.name}</p>
                <p className="text-sm text-gray-400 capitalize">Cargo: {employee.role === 'manager' ? 'Gerente' : 'Funcionário'}</p>
            </div>
            <div className="flex items-center gap-4">
                <p className="text-lg font-semibold text-green-400">${(employee.salary || 0).toLocaleString()}</p>
                <button onClick={() => onEdit(employee)} className="py-2 px-4 bg-blue-600 hover:bg-blue-500 text-sm font-semibold rounded-md transition-colors">Editar</button>
                <button onClick={() => onFire(employee)} className="py-2 px-4 bg-red-600 hover:bg-red-500 text-sm font-semibold rounded-md transition-colors">Demitir</button>
            </div>
        </div>
    );
};

// NOVO: Componente especial apenas para a linha do dono
const OwnerRow: React.FC<{ owner: Employee }> = ({ owner }) => {
    return (
        <div className="flex justify-between items-center bg-blue-900/50 border border-blue-700 p-3 rounded-lg">
            <div>
                <p className="font-bold text-white">{owner.name} (Você)</p>
                <p className="text-sm text-blue-300 capitalize">Cargo: Dono</p>
            </div>
            <div className="flex items-center gap-4">
                <p className="text-lg font-semibold text-green-400">${(owner.salary || 0).toLocaleString()}</p>
                {/* Não há botões de editar ou demitir para o dono */}
            </div>
        </div>
    );
};


export const Employees: React.FC<{
    companyData: FullCompanyInfo;
    updateCompanyData: (data: Partial<FullCompanyInfo>) => void;
    onBack: () => void;
}> = ({ companyData, updateCompanyData, onBack }) => {

    const [employeeToFire, setEmployeeToFire] = useState<Employee | null>(null);
    const [employeeToEdit, setEmployeeToEdit] = useState<Employee | null>(null);

    // =================================================================
    // >> CORREÇÃO PRINCIPAL APLICADA AQUI <<
    // Usamos useMemo para separar o dono dos outros funcionários de forma eficiente.
    // =================================================================
    const { owner, otherEmployees } = useMemo(() => {
        if (!companyData.employees) {
            return { owner: null, otherEmployees: [] };
        }
        const ownerEmployee = companyData.employees.find(emp => emp.role === 'owner');
        const otherEmployeesList = companyData.employees.filter(emp => emp.role !== 'owner');
        return { owner: ownerEmployee, otherEmployees: otherEmployeesList };
    }, [companyData.employees]);


    if (!companyData.company_data || !companyData.employees) {
        return <div className="p-8 text-white w-full h-full flex items-center justify-center">A carregar...</div>;
    }

    const handleConfirmFire = async () => {
        if (!employeeToFire) return;
        const result = await fetchNui<any>('fireEmployee', { employeeId: employeeToFire.id });
        if (result.success) {
            updateCompanyData(result.updatedData);
        } else {
            alert(result.message || "Ocorreu um erro ao demitir.");
        }
        setEmployeeToFire(null);
    };

    const handleSuccessEdit = (updatedData: any) => {
        updateCompanyData(updatedData);
        setEmployeeToEdit(null);
    };

    return (
        <div className="w-full h-full p-8 flex flex-col bg-gray-900">
            <AppHeader title="Gerenciar Funcionários" onBack={onBack} logoUrl={companyData.company_data.logo_url} />
            
            <main className="flex-1 bg-black/20 rounded-lg p-4 overflow-y-auto">
                <div className="space-y-3">
                    {/* Renderiza a linha do dono primeiro, se ele existir */}
                    {owner && <OwnerRow owner={owner} />}

                    {/* Renderiza o resto dos funcionários */}
                    {otherEmployees.length > 0 ? (
                        otherEmployees.map(employee => (
                            <EmployeeRow key={employee.id} employee={employee} onFire={setEmployeeToFire} onEdit={setEmployeeToEdit} />
                        ))
                    ) : (
                        // Mostra esta mensagem apenas se não houver NENHUM outro funcionário
                        !owner ? <div className="flex items-center justify-center h-full text-gray-400">A sua empresa não tem funcionários.</div> : null
                    )}
                </div>
            </main>

            {employeeToFire && (
                <ConfirmationModal 
                    isOpen={!!employeeToFire} 
                    onClose={() => setEmployeeToFire(null)} 
                    onConfirm={handleConfirmFire} 
                    title={`Demitir ${employeeToFire.name}`} 
                    description="Tem a certeza que deseja demitir este funcionário? Esta ação não pode ser desfeita." 
                />
            )}
            
            {employeeToEdit && (
                <EditEmployeeModal employee={employeeToEdit} onClose={() => setEmployeeToEdit(null)} onSuccess={handleSuccessEdit} />
            )}
        </div>
    );
};