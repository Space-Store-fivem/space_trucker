// web/src/layouts/pages/company/CreateOrderModal.tsx

import React, { useState } from 'react';
import { fetchNui } from '../../../utils/fetchNui';

interface CreateOrderModalProps {
  itemName: string;
  itemLabel: string;
  industryName: string;
  onClose: () => void;
  onSuccess: () => void;
}

export const CreateOrderModal: React.FC<CreateOrderModalProps> = ({ itemName, itemLabel, industryName, onClose, onSuccess }) => {
  const [quantity, setQuantity] = useState(10);
  const [reward, setReward] = useState(500);
  const [isProcessing, setIsProcessing] = useState(false);

  const handleCreateOrder = async () => {
    setIsProcessing(true);
    const result = await fetchNui<{ success: boolean; message: string }>('createLogisticsOrder', {
      itemName,
      quantity,
      reward,
      requestingIndustry: industryName,
    });
    setIsProcessing(false);

    if (result && result.success) {
      onSuccess();
    }
    // A notificação de sucesso ou erro será tratada pelo lado do Lua.
    onClose();
  };

  return (
    <div className="fixed inset-0 bg-black bg-opacity-75 flex items-center justify-center z-50">
      <div className="bg-gray-800 p-6 rounded-lg shadow-xl w-full max-w-md border border-white/10">
        <h2 className="text-2xl font-bold text-white mb-4">Criar Encomenda</h2>
        <p className="text-gray-300 mb-6">Criar um pedido de transporte para <span className="font-bold text-amber-400">{itemLabel}</span>.</p>
        
        <div className="space-y-4">
          <div>
            <label htmlFor="quantity" className="block text-sm font-medium text-gray-300">Quantidade</label>
            <input
              type="number"
              id="quantity"
              value={quantity}
              onChange={(e) => setQuantity(Math.max(1, parseInt(e.target.value) || 1))}
              className="mt-1 block w-full bg-gray-700 border border-gray-600 rounded-md shadow-sm py-2 px-3 text-white focus:outline-none focus:ring-blue-500 focus:border-blue-500"
            />
          </div>
          <div>
            <label htmlFor="reward" className="block text-sm font-medium text-gray-300">Recompensa para o Transportador ($)</label>
            <input
              type="number"
              id="reward"
              value={reward}
              onChange={(e) => setReward(Math.max(0, parseInt(e.target.value) || 0))}
              className="mt-1 block w-full bg-gray-700 border border-gray-600 rounded-md shadow-sm py-2 px-3 text-white focus:outline-none focus:ring-blue-500 focus:border-blue-500"
            />
          </div>
        </div>

        <div className="mt-8 flex justify-end space-x-3">
          <button
            onClick={onClose}
            disabled={isProcessing}
            className="bg-gray-600 hover:bg-gray-700 text-white font-bold py-2 px-4 rounded-lg transition-colors disabled:opacity-50"
          >
            Cancelar
          </button>
          <button
            onClick={handleCreateOrder}
            disabled={isProcessing}
            className="bg-green-600 hover:bg-green-700 text-white font-bold py-2 px-4 rounded-lg transition-colors disabled:opacity-50"
          >
            {isProcessing ? 'A Publicar...' : 'Publicar Encomenda'}
          </button>
        </div>
      </div>
    </div>
  );
};