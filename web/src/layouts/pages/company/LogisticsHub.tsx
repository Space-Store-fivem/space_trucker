import React, { useState, useEffect } from 'react';
import { fetchNui } from '../../../utils/fetchNui';
import { useNuiEvent } from '../../../hooks/useNuiEvent';
import { LogisticsOrder } from '../../../types';

const AppHeader: React.FC<{ title: string; onBack: () => void }> = ({ title, onBack }) => (
    <header className="flex items-center p-4 border-b border-white/10 sticky top-0 bg-gray-900/80 backdrop-blur-sm z-10">
        <button onClick={onBack} className="mr-4 text-white hover:text-blue-400 transition-colors">
            <svg xmlns="http://www.w.org/2000/svg" className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M15 19l-7-7 7-7" /></svg>
        </button>
        <h1 className="text-xl font-bold text-white">{title}</h1>
    </header>
);

export const LogisticsHub: React.FC<{ onBack: () => void }> = ({ onBack }) => {
    const [orders, setOrders] = useState<LogisticsOrder[]>([]);
    const [isLoading, setIsLoading] = useState(true);
    const [processingId, setProcessingId] = useState<number | null>(null); // Estado para controlar o botão

    useEffect(() => {
        fetchNui('requestLogisticsOrders');
    }, []);

    useNuiEvent<LogisticsOrder[]>('setLogisticsOrders', (data) => {
        setOrders(data || []);
        setIsLoading(false);
    });

    // Função ATUALIZADA para aceitar a encomenda
    const handleAcceptOrder = (orderId: number) => {
        setProcessingId(orderId); // Desativa o botão para evitar cliques múltiplos
        fetchNui('acceptLogisticsOrder', { orderId }).then(result => {
            if (result && result.success) {
                // O painel será fechado pelo lado do Lua, não precisamos fazer nada aqui.
            } else {
                // Se falhar (ex: outro jogador aceitou), reativa o botão.
                setProcessingId(null);
            }
        });
    };

    return (
        <div className="flex flex-col w-full h-full bg-gray-900/80 backdrop-blur-md text-white">
            <AppHeader title="Central de Logística" onBack={onBack} />
            <div className="flex-grow p-6 overflow-y-auto">
                {isLoading ? (
                    <div className="flex justify-center items-center h-full">
                        <p className="text-lg text-gray-400 animate-pulse">A carregar encomendas...</p>
                    </div>
                ) : (
                    <div className="space-y-4">
                        {orders.length === 0 ? (
                            <div className="text-center py-10">
                                <p className="text-gray-400">Não há nenhuma encomenda disponível de momento.</p>
                            </div>
                        ) : (
                            orders.map(order => (
                                <div key={order.id} className="bg-gray-800 p-4 rounded-lg border border-white/5 shadow-md flex justify-between items-center">
                                    <div className="space-y-2">
                                        <h3 className="text-lg font-bold text-amber-400">{order.item_label} <span className="text-white">x{order.quantity}</span></h3>
                                        <p className="text-sm text-gray-300">
                                            <span className="font-semibold">De:</span> {order.pickup_industry_name}
                                        </p>
                                        <p className="text-sm text-gray-300">
                                            <span className="font-semibold">Para:</span> {order.dropoff_details}
                                        </p>
                                    </div>
                                    <div className="text-right flex flex-col items-end gap-3">
                                        <p className="text-xl font-bold text-green-400">${order.reward.toLocaleString()}</p>
                                        <button 
                                            onClick={() => handleAcceptOrder(order.id)}
                                            // Botão é desativado se o ID corresponder ao que está a ser processado
                                            disabled={processingId === order.id}
                                            className="bg-green-600 hover:bg-green-700 text-white font-bold py-2 px-4 rounded-lg transition-colors text-sm disabled:bg-gray-500 disabled:cursor-not-allowed"
                                        >
                                            {processingId === order.id ? 'A processar...' : 'Aceitar'}
                                        </button>
                                    </div>
                                </div>
                            ))
                        )}
                    </div>
                )}
            </div>
        </div>
    );
};
