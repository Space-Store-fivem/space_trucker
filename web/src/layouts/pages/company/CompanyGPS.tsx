import { useNuiEvent } from '../../../hooks/useNuiEvent';
import React, { useState, useRef, WheelEvent, MouseEvent } from 'react';
import { ArrowLeft, ZoomIn, ZoomOut, Move } from 'lucide-react';

// Tipagens
interface MemberData {
  name: string;
  coords: { x: number; y: number; z: number };
  vehicle: string;
  mission?: {
    item: string;
    amount: number;
  };
}

interface GpsDataPayload {
  members: Record<string, MemberData>;
  myServerId: number;
}

const convertGameCoordsToMapCoords = (coords: { x: number; y: number }) => {
  const mapWidth = 900; 
  const mapHeight = 900;
  const gameXMin = -3400;
  const gameXMax = 4900;
  const gameYMin = -4650;
  const gameYMax = 8200;

  const x = ((coords.x - gameXMin) / (gameXMax - gameXMin)) * mapWidth;
  const y = ((gameYMax - coords.y) / (gameYMax - gameYMin)) * mapHeight;

  return { x, y };
};

const CompanyGPS: React.FC<{ onBack: () => void }> = ({ onBack }) => {
  const [members, setMembers] = useState<Record<string, MemberData>>({});
  const [myServerId, setMyServerId] = useState<number | null>(null);
  const [selectedMember, setSelectedMember] = useState<MemberData | null>(null);

  // Estados para o zoom e pan
  const [scale, setScale] = useState(1);
  const [position, setPosition] = useState({ x: 0, y: 0 });
  const [isDragging, setIsDragging] = useState(false);
  const dragStart = useRef({ x: 0, y: 0 });
  const MIN_SCALE = 1;
  const MAX_SCALE = 4;

  useNuiEvent('updateCompanyGPS', (data: GpsDataPayload) => {
    setMembers(data.members || {});
    setMyServerId(data.myServerId);
  });

  const handleWheel = (e: WheelEvent) => {
    e.preventDefault();
    const scaleAmount = -e.deltaY * 0.001;
    setScale(prevScale => Math.min(Math.max(prevScale + scaleAmount, MIN_SCALE), MAX_SCALE));
  };

  const handleMouseDown = (e: MouseEvent) => {
    setIsDragging(true);
    dragStart.current = { x: e.clientX - position.x, y: e.clientY - position.y };
    (e.target as HTMLElement).style.cursor = 'grabbing';
  };

  const handleMouseMove = (e: MouseEvent) => {
    if (!isDragging) return;
    const x = e.clientX - dragStart.current.x;
    const y = e.clientY - dragStart.current.y;
    setPosition({ x, y });
  };

  const handleMouseUp = (e: MouseEvent) => {
    setIsDragging(false);
    (e.target as HTMLElement).style.cursor = 'grab';
  };
  
  const handleReset = () => {
    setScale(1);
    setPosition({ x: 0, y: 0 });
  };

  const handleZoomIn = () => {
    setScale(prev => Math.min(prev + 0.2, MAX_SCALE));
  };

  const handleZoomOut = () => {
    setScale(prev => Math.max(prev - 0.2, MIN_SCALE));
  };

  return (
    <div className="w-full h-full flex flex-col text-white font-poppins">
      <header className="flex items-center p-4 border-b border-white/10">
        <button onClick={onBack} className="p-2 rounded-md hover:bg-white/10 transition-colors">
          <ArrowLeft size={20} />
        </button>
        <h1 className="text-xl font-bold ml-4">GPS da Frota</h1>
      </header>
      
      <div className="flex-1 p-4 flex gap-4 overflow-hidden">
        <div className="w-3/4 h-full bg-black/50 rounded-lg overflow-hidden relative shadow-2xl" onWheel={handleWheel}>
          <div
            className="relative w-full h-full"
            style={{
              transform: `translate(${position.x}px, ${position.y}px) scale(${scale})`,
              cursor: isDragging ? 'grabbing' : 'grab',
            }}
            onMouseDown={handleMouseDown}
            onMouseMove={handleMouseMove}
            onMouseUp={handleMouseUp}
            onMouseLeave={handleMouseUp}
          >
            {/* O caminho está correto, relativo à pasta 'public' ou 'build' */}
            <img src="images/map.png" alt="Mapa da Cidade" className="w-full h-full object-cover" />
            {Object.entries(members).map(([serverId, member]) => {
              const { x, y } = convertGameCoordsToMapCoords(member.coords);
              const isMe = Number(serverId) === myServerId;
              const isSelected = selectedMember?.name === member.name;
              
              const markerBaseClasses = "absolute w-4 h-4 rounded-full border-2 transition-all duration-200 cursor-pointer";
              
              let markerStyle = '';
              if (isMe) {
                markerStyle = isSelected ? 'bg-green-400 border-white scale-150' : 'bg-yellow-400 border-yellow-200 hover:scale-125';
              } else {
                markerStyle = isSelected ? 'bg-yellow-400 border-white scale-150' : 'bg-blue-500 border-blue-200 hover:scale-125';
              }

              return (
                <div
                  key={serverId}
                  className={`${markerBaseClasses} ${markerStyle}`}
                  style={{ left: `${x}px`, top: `${y}px`, transform: `translate(-50%, -50%) scale(${1 / scale})` }}
                  onClick={(e) => { e.stopPropagation(); setSelectedMember(member); }}
                >
                  <div className={`absolute -bottom-7 left-1/2 transform -translate-x-1/2 text-xs bg-black/80 px-2 py-1 rounded whitespace-nowrap shadow-lg transition-opacity duration-200 ${isSelected ? 'opacity-100' : 'opacity-0'}`}
                       style={{ transform: `translate(-50%, 0) scale(${1 / scale})` }}
                  >
                    {isMe ? `${member.name} (Você)` : member.name}
                  </div>
                </div>
              );
            })}
          </div>

          <div className="absolute bottom-4 right-4 flex flex-col gap-2">
              <button onClick={handleZoomIn} className="w-8 h-8 flex items-center justify-center bg-gray-800/80 rounded-md hover:bg-gray-700/80 transition-colors"><ZoomIn size={18} /></button>
              <button onClick={handleZoomOut} className="w-8 h-8 flex items-center justify-center bg-gray-800/80 rounded-md hover:bg-gray-700/80 transition-colors"><ZoomOut size={18} /></button>
              <button onClick={handleReset} className="w-8 h-8 flex items-center justify-center bg-gray-800/80 rounded-md hover:bg-gray-700/80 transition-colors"><Move size={18} /></button>
          </div>
        </div>
      
        <div className="w-1/4 h-full bg-black/50 rounded-lg p-3 flex flex-col">
          <h2 className="text-xl font-bold text-center mb-3 text-blue-300">Frota Ativa</h2>
          <div className="space-y-2 overflow-y-auto flex-1 pr-1">
            {Object.keys(members).length > 0 ? (
              Object.entries(members).map(([serverId, member]) => {
                const isMe = Number(serverId) === myServerId;
                return (
                  <div 
                    key={serverId} 
                    className={`p-2.5 rounded-lg transition-all duration-200 cursor-pointer border
                                ${selectedMember?.name === member.name ? 'bg-blue-500/30 border-blue-400' : 'bg-white/10 border-transparent hover:bg-white/20'}`}
                    onClick={() => setSelectedMember(member)}
                  >
                    <p className={`font-bold ${isMe ? 'text-yellow-400' : 'text-blue-300'}`}>
                      {member.name} {isMe && '(Você)'}
                    </p>
                    <p className="text-sm text-gray-300">Veículo: {member.vehicle}</p>
                    {member.mission && (
                      <div className="text-xs mt-1.5 border-t border-white/20 pt-1.5">
                        <p className="font-semibold text-yellow-400">Em Missão:</p>
                        <p className='text-gray-200'>Carga: {member.mission.item}</p>
                        <p className='text-gray-200'>Qtd: {member.mission.amount}</p>
                      </div>
                    )}
                  </div>
                )
              })
            ) : (
              <p className="text-center text-gray-400 mt-10">Nenhum funcionário ativo.</p>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default CompanyGPS;