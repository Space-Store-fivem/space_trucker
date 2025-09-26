// web/src/layouts/pages/company/CreateOrderModal.tsx (VERSÃO COM ECONOMIA DINÂMICA)

import React, { useState, useEffect, useMemo } from 'react';
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
  const [itemPrice, setItemPrice] = useState(0);
  const [isProcessing, setIsProcessing] = useState(false);

  // Busca o preço do item no servidor quando o modal é aberto
  useEffect(() => {
    fetchNui<number>('getOrderItemPrice', { itemName }).then(price => {
      setItemPrice(price || 0);
    });
  }, [itemName]);

  // Calcula os custos em tempo real sempre que a quantidade ou o preço do item mudam
  const { cargoValue, truckerReward, totalCost } = useMemo(() => {
    const cargoValue = itemPrice * quantity;
    const truckerReward = Math.floor(cargoValue * 0.30);
    const totalCost = cargoValue + truckerReward;
    return { cargoValue, truckerReward, totalCost };
  }, [quantity, itemPrice]);

  const handleCreateOrder = async () => {
    setIsProcessing(true);
    // Já não enviamos a recompensa, o servidor irá calculá-la
    const result = await fetchNui<{ success: boolean; message: string }>('createLogisticsOrder', {
      itemName,
      quantity,
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
        </div>

        {/* --- NOVO: Secção de Resumo Financeiro --- */}
        <div className="mt-6 p-4 bg-gray-900/50 rounded-lg border border-white/5 space-y-2">
            <div className="flex justify-between text-sm">
                <span className="text-gray-400">Custo dos Produtos ({quantity} x ${itemPrice})</span>
                <span className="font-semibold text-white">${cargoValue.toLocaleString()}</span>
            </div>
            <div className="flex justify-between text-sm">
                <span className="text-gray-400">Frete do Transportador (30%)</span>
                <span className="font-semibold text-white">${truckerReward.toLocaleString()}</span>
            </div>
            <div className="flex justify-between text-lg font-bold border-t border-white/10 pt-2 mt-2">
                <span className="text-white">Custo Total da Encomenda</span>
                <span className="text-green-400">${totalCost.toLocaleString()}</span>
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
            disabled={isProcessing || totalCost <= 0}
            className="bg-green-600 hover:bg-green-700 text-white font-bold py-2 px-4 rounded-lg transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
          >
            {isProcessing ? 'A Publicar...' : 'Confirmar e Pagar'}
          </button>
        </div>
      </div>
    </div>
  );
};