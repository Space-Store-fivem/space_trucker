import React, { useState, useEffect } from 'react';
import { fetchNui } from '../../../utils/fetchNui';
import AppHeader from '../../components/AppHeader';
import { IconAlertTriangle } from '@tabler/icons-react';
import { FullCompanyInfo } from '../../../types'; // Importando o tipo

// Definindo a estrutura de uma missão
interface Mission {
  id: string;
  sourceLabel: string;
  destinationLabel: string;
  itemLabel: string;
  reputation: number;
  vehicleRequirement: string;
}

// Props atualizadas para receber os dados completos da empresa
interface TransportMissionsProps {
  companyData: FullCompanyInfo;
  onBack: () => void;
}

export const TransportMissions: React.FC<TransportMissionsProps> = ({ companyData, onBack }) => {
  const [missions, setMissions] = useState<Mission[]>([]);
  const [isLoading, setIsLoading] = useState(true);

  // Verificação de segurança para garantir que os dados existem
  if (!companyData || !companyData.company_data) {
    return <div className="p-8 text-white w-full h-full flex items-center justify-center">A carregar...</div>;
  }

  useEffect(() => {
    fetchNui<Mission[]>('getMissions')
      .then(setMissions)
      .catch(err => console.error('[Missions] Erro ao buscar missões:', err))
      .finally(() => setIsLoading(false));
  }, []);

  const handleAcceptMission = (missionId: string) => {
    fetchNui('acceptMission', { id: missionId });
  };

  return (
    // Layout principal padronizado, igual ao do Dashboard
    <div className="w-full h-full p-8 flex flex-col bg-gray-900">
      {/* Cabeçalho agora recebe o logoUrl corretamente */}
      <AppHeader title="Missões de Transporte" onBack={onBack} logoUrl={companyData.company_data.logo_url} />
      
      <div className="flex-grow overflow-y-auto mt-4 pr-2">
        {/* Aviso de Reboque */}
        <div className="bg-yellow-900/50 border border-yellow-700 text-yellow-300 px-4 py-3 rounded-lg relative mb-6 flex items-start gap-3">
          <IconAlertTriangle className="h-5 w-5 mt-0.5 flex-shrink-0" />
          <div>
            <h4 className="font-bold">Aviso Importante</h4>
            <span className="block sm:inline text-sm">Missões com trailers, grain trailers e tankers devem ser usados com veículos de reboque (cavalos mecânicos).</span>
          </div>
        </div>

        {isLoading ? (
          <div className="flex justify-center items-center h-full">
            <p className="text-lg text-gray-400 animate-pulse">A procurar por novas missões...</p>
          </div>
        ) : (
          <div className="space-y-4">
            {missions.length > 0 ? (
              missions.map(mission => (
                <div key={mission.id} className="bg-gray-800 p-4 rounded-lg border border-white/5 shadow-md">
                  <div className="flex justify-between items-center">
                    <div className="flex-grow">
                      <h3 className="text-lg font-bold text-blue-400">Transportar: {mission.itemLabel}</h3>
                      <p className="text-sm text-gray-300">De: <span className="font-semibold">{mission.sourceLabel}</span></p>
                      <p className="text-sm text-gray-300">Para: <span className="font-semibold">{mission.destinationLabel}</span></p>
                      <p className="text-xs text-yellow-400 mt-1 font-semibold">Requisito: {mission.vehicleRequirement}</p>
                    </div>
                    <div className="text-right flex flex-col items-end space-y-2 flex-shrink-0 ml-4">
                       <p className="text-md font-bold text-green-400">+{mission.reputation} RP</p>
                       <button 
                         onClick={() => handleAcceptMission(mission.id)} 
                         className="bg-green-600 hover:bg-green-700 text-white font-bold py-2 px-4 rounded-lg transition-colors text-sm"
                       >
                         Aceitar
                       </button>
                    </div>
                  </div>
                </div>
              ))
            ) : (
              <p className="text-center text-gray-400">Nenhuma missão disponível no momento. Volte mais tarde.</p>
            )}
          </div>
        )}
      </div>
    </div>
  );
};