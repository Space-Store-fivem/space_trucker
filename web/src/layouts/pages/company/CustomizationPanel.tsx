import React, { useState, useEffect } from 'react';
import SwitchToggle from '../../components/SwitchToggle';

type CustomizationSettings = {
  backgroundColor: string;
  backgroundImage: string;
  blurEnabled: boolean;
};

interface CustomizationPanelProps {
  onClose: () => void;
  onSave: (settings: CustomizationSettings) => void;
  currentSettings: CustomizationSettings;
}

const CustomizationPanel: React.FC<CustomizationPanelProps> = ({ onClose, onSave, currentSettings }) => {
  const [settings, setSettings] = useState<CustomizationSettings>(currentSettings);

  useEffect(() => {
    setSettings(currentSettings);
  }, [currentSettings]);

  const handleSave = () => {
    onSave(settings);
  };

  return (
    <div className="w-full h-full p-6 sm:p-8 flex flex-col items-center justify-center text-white bg-black/20 animate-fade-in">
      <div className="w-full max-w-2xl bg-gray-800/80 backdrop-blur-md rounded-2xl p-8 shadow-2xl border border-white/10">
        <h1 className="text-3xl sm:text-4xl font-bold text-center mb-8">Personalizar Interface</h1>
        
        <div className="space-y-6">
          <div>
            <label className="block text-sm font-medium text-gray-300 mb-2">
              Cor de Fundo
            </label>
            <div className="flex items-center gap-3">
              <input
                type="color"
                value={settings.backgroundColor}
                onChange={(e) => setSettings({ ...settings, backgroundColor: e.target.value })}
                className="w-14 h-11 p-1 bg-gray-900/50 rounded-lg border-2 border-gray-700 cursor-pointer"
              />
              <input
                type="text"
                value={settings.backgroundColor}
                onChange={(e) => setSettings({ ...settings, backgroundColor: e.target.value })}
                className="w-full bg-gray-900/50 border-2 border-gray-700 rounded-lg shadow-sm py-2.5 px-4 text-white placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition"
                placeholder="#111827"
              />
            </div>
          </div>

          <div>
            <label htmlFor="backgroundImage" className="block text-sm font-medium text-gray-300 mb-2">
              URL da Imagem de Fundo (ou GIF)
            </label>
            <input
              type="text"
              id="backgroundImage"
              value={settings.backgroundImage}
              onChange={(e) => setSettings({ ...settings, backgroundImage: e.target.value })}
              className="w-full bg-gray-900/50 border-2 border-gray-700 rounded-lg shadow-sm py-2.5 px-4 text-white placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition"
              placeholder="https://i.imgur.com/seu-link.png"
            />
          </div>

          <div className="flex items-center justify-between pt-3 border-t border-white/10">
            <label className="text-sm font-medium text-gray-300">
              Ativar Efeito de Desfoque no Fundo
            </label>
            <SwitchToggle 
              enabled={settings.blurEnabled}
              setEnabled={(value) => setSettings({ ...settings, blurEnabled: value })}
            />
          </div>
        </div>

        <div className="mt-8 flex flex-col sm:flex-row gap-4 justify-end">
          <button
            onClick={onClose}
            className="px-6 py-2.5 bg-gray-600/50 text-white font-semibold rounded-lg hover:bg-gray-700/70 transition-colors duration-300"
          >
            Cancelar
          </button>
          <button
            onClick={handleSave}
            className="px-6 py-2.5 bg-blue-600 text-white font-semibold rounded-lg hover:bg-blue-700 transition-colors duration-300"
          >
            Salvar Alterações
          </button>
        </div>
      </div>
    </div>
  );
};

export default CustomizationPanel;