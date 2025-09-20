import React, { useState } from 'react';
import { fetchNui } from '../../../utils/fetchNui';

interface CreateProfileProps {
  onSuccess: () => void; // Função para ser chamada quando o perfil for criado com sucesso
}

export const CreateProfile: React.FC<CreateProfileProps> = ({ onSuccess }) => {
  const [profileName, setProfileName] = useState('');
  const [profilePicture, setProfilePicture] = useState('');
  const [error, setError] = useState<string | null>(null);

  const handleCreateProfile = async () => {
    setError(null);
    if (!profileName.trim()) {
      setError("O seu nome de perfil é obrigatório.");
      return;
    }

    const result = await fetchNui<any>('createProfile', {
      name: profileName,
      picture: profilePicture,
    });

    if (result.success) {
      onSuccess(); // Informa o componente pai que o perfil foi criado
    } else {
      setError(result.message || "Ocorreu um erro desconhecido.");
    }
  };

  return (
    <div className="w-full h-full flex flex-col items-center justify-center text-center p-8 bg-gray-900">
        <img 
            src={profilePicture || 'https://placehold.co/96x96/4b5563/FFFFFF?text=?'} 
            alt="Foto de Perfil" 
            className="w-24 h-24 rounded-full object-cover bg-gray-700 mb-4"
        />
        <h2 className="text-3xl font-bold text-white">Crie o seu Perfil de Trabalhador</h2>
        <p className="text-gray-400 mt-2 max-w-md">Este perfil será visível para as empresas quando procurar por emprego.</p>
        
        {error && <p className="text-red-400 bg-red-900/50 p-3 rounded-md my-4 text-center">{error}</p>}

        <div className="space-y-4 mt-6 w-full max-w-sm">
            <input
                type="text"
                placeholder="O seu nome de perfil"
                value={profileName}
                onChange={(e) => setProfileName(e.target.value)}
                className="w-full p-3 bg-gray-800 rounded-md text-white placeholder-gray-500 border border-gray-700 focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
            <input
                type="text"
                placeholder="URL da sua foto (opcional)"
                value={profilePicture}
                onChange={(e) => setProfilePicture(e.target.value)}
                className="w-full p-3 bg-gray-800 rounded-md text-white placeholder-gray-500 border border-gray-700 focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
        </div>

        <button 
            onClick={handleCreateProfile}
            className="mt-6 py-2 px-8 bg-blue-600 hover:bg-blue-500 rounded-md font-semibold transition-colors"
        >
            Confirmar e Entrar
        </button>
    </div>
  );
};
