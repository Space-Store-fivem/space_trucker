// web/src/layouts/pages/company/TransportMissions.tsx

import React, { useState, useEffect } from 'react';
import { fetchNui } from '../../../utils/fetchNui';
// CORREÇÃO: Remova as chaves {} da importação
import  AppHeader  from '../../components/AppHeader'; // Reutilizando o cabeçalho

// Definindo a estrutura de uma missão
interface Mission {
  id: string;
  sourceLabel: string;
  destinationLabel: string;
  itemLabel: string;
  reputation: number;
}

interface TransportMissionsProps {
  onBack: () => void;
}

export const TransportMissions: React.FC<TransportMissionsProps> = ({ onBack }) => {
  const [missions, setMissions] = useState<Mission[]>([]);
  const [isLoading, setIsLoading] = useState(true);

  // Busca as missões do servidor quando o componente é montado
  useEffect(() => {
    console.log('[Missions] Buscando missões do servidor...');
    fetchNui<Mission[]>('getMissions')
      .then(data => {
        console.log(`[Missions] ${data.length} missões recebidas.`);
        setMissions(data);
      })
      .catch(err => console.error('[Missions] Erro ao buscar missões:', err))
      .finally(() => setIsLoading(false));
  }, []);

  const handleAcceptMission = (missionId: string) => {
    console.log(`[Missions] Jogador aceitou a missão: ${missionId}`);
    fetchNui('acceptMission', { id: missionId });
  };

  return (
    <div className="flex flex-col w-full h-full bg-gray-900/80 backdrop-blur-md text-white">
      <AppHeader title="Missões de Transporte" onBack={onBack} />
      <div className="flex-grow p-6 overflow-y-auto">
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
                    <div>
                      <h3 className="text-lg font-bold text-blue-400">Transportar: {mission.itemLabel}</h3>
                      <p className="text-sm text-gray-300">De: <span className="font-semibold">{mission.sourceLabel}</span></p>
                      <p className="text-sm text-gray-300">Para: <span className="font-semibold">{mission.destinationLabel}</span></p>
                    </div>
                    <div className="text-right flex flex-col items-end space-y-2">
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