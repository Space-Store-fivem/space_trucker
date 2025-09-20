import React, { useState } from 'react';
import { fetchNui } from '../../../utils/fetchNui';

interface CreateCompanyProps {
  onSuccess: () => void;
  onClose: () => void;
}

export const CreateCompany: React.FC<CreateCompanyProps> = ({ onSuccess, onClose }) => {
    const [name, setName] = useState('');
    const [logo, setLogo] = useState('');
    const [error, setError] = useState<string | null>(null);
    const [isCreating, setIsCreating] = useState(false); // Adicionado estado de carregamento

    const handleCreate = async () => {
        setError(null);
        if (!name.trim()) {
            return setError("O nome da empresa é obrigatório.");
        }
        
        setIsCreating(true); // Desabilita o botão para evitar cliques duplos
        
        try {
            // CORREÇÃO: O nome do evento foi alterado para 'gs_trucker:createCompany' para ser consistente.
            const result = await fetchNui<{ success: boolean; message?: string }>('gs_trucker:createCompany', { name, logo });
            
            if (result.success) {
                onSuccess();
            } else {
                setError(result.message || "Ocorreu um erro desconhecido ao criar a empresa.");
            }
        } catch (e) {
            console.error("Falha ao executar NUI callback 'gs_trucker:createCompany':", e);
            setError("Ocorreu um erro de comunicação com o servidor.");
        } finally {
            setIsCreating(false); // Reabilita o botão
        }
    };
    
    return (
        <div className="absolute inset-0 bg-black/60 flex items-center justify-center z-40">
            <div className="p-8 bg-gray-800 border border-gray-700 rounded-lg shadow-2xl w-full max-w-md">
                <h1 className="text-3xl font-bold mb-2 text-center text-white">Crie sua Transportadora</h1>
                <p className="text-center text-gray-400 mb-6">Comece sua jornada no mundo da logística.</p>
                
                {error && <p className="text-red-400 bg-red-900/50 p-3 rounded-md mb-4 text-center">{error}</p>}
                
                <div className="space-y-4">
                        <input
                            type="text"
                            placeholder="Nome da Empresa"
                            value={name}
                            onChange={(e) => setName(e.target.value)}
                            className="w-full p-3 bg-gray-700 rounded-md text-white placeholder-gray-400 border border-transparent focus:outline-none focus:ring-2 focus:ring-blue-500"
                        />
                        <input
                            type="text"
                            placeholder="URL da Logo (opcional)"
                            value={logo}
                            onChange={(e) => setLogo(e.target.value)}
                            className="w-full p-3 bg-gray-700 rounded-md text-white placeholder-gray-400 border border-transparent focus:outline-none focus:ring-2 focus:ring-blue-500"
                        />
                </div>
                
                <div className="mt-6 flex justify-end gap-3">
                        <button 
                            onClick={onClose}
                            className="py-2 px-5 bg-gray-600 hover:bg-gray-500 rounded-md font-semibold transition-colors"
                        >
                            Cancelar
                        </button>
                        <button 
                            onClick={handleCreate} 
                            className="py-2 px-5 bg-blue-600 hover:bg-blue-500 rounded-md font-semibold transition-colors disabled:bg-gray-500 disabled:cursor-not-allowed"
                            disabled={!name.trim() || isCreating}
                        >
                            {isCreating ? 'Criando...' : 'Criar Empresa ($50,000)'}
                        </button>
                </div>
            </div>
        </div>
    );
};
