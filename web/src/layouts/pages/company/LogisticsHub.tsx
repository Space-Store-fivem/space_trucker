// web/src/layouts/pages/company/LogisticsHub.tsx (VERSÃO FINAL COM NOMENCLATURA CORRIGIDA)

import React, { useState, useEffect } from 'react';
import { fetchNui } from '../../../utils/fetchNui';
import { useNuiEvent } from '../../../hooks/useNuiEvent';
import { LogisticsOrder } from '../../../types';

const AppHeader: React.FC<{ title: string; onBack: () => void }> = ({ title, onBack }) => (
    <header className="flex items-center p-4 border-b border-white/10 sticky top-0 bg-gray-900/80 backdrop-blur-sm z-10">
        <button onClick={onBack} className="mr-4 text-white hover:text-blue-400 transition-colors">
            <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M15 19l-7-7 7-7" /></svg>
        </button>
        <h1 className="text-xl font-bold text-white">{title}</h1>
    </header>
);

export const LogisticsHub: React.FC<{ onBack: () => void }> = ({ onBack }) => {
    const [orders, setOrders] = useState<LogisticsOrder[]>([]);
    const [isLoading, setIsLoading] = useState(true);
    const [processingId, setProcessingId] = useState<number | null>(null);
    const [activeOrderId, setActiveOrderId] = useState<number | null>(null);

    useEffect(() => {
        fetchNui('requestLogisticsOrders');
    }, []);

    useNuiEvent<LogisticsOrder[]>('setLogisticsOrders', (data) => {
        setOrders(data || []);
        setIsLoading(false);
    });

    useNuiEvent<number | null>('setActiveLogisticsOrder', (orderId) => {
        setActiveOrderId(orderId);
    });

    const handleAcceptOrder = (orderId: number) => {
        setProcessingId(orderId);
        fetchNui('acceptLogisticsOrder', { orderId });
    };

    const handleCancelOrder = (orderId: number) => {
        setProcessingId(orderId);
        fetchNui('cancelLogisticsOrder', { orderId }).then(() => {
            setProcessingId(null);
        });
    };

    return (
        <div className="flex flex-col w-full h-full bg-gray-900/80 backdrop-blur-md text-white">
            <AppHeader title="Central de Logística" onBack={onBack} />
            <div className="flex-grow p-6 overflow-y-auto">
                {isLoading ? (
                    <div className="flex justify-center items-center h-full"><p className="text-lg text-gray-400 animate-pulse">A carregar encomendas...</p></div>
                ) : (
                    <div className="space-y-4">
                        {orders.length === 0 ? (
                            <div className="text-center py-10"><p className="text-gray-400">Não há nenhuma encomenda disponível de momento.</p></div>
                        ) : (
                            orders.map(order => {
                                const isMyActiveOrder = activeOrderId === order.id;
                                return (
                                    <div key={order.id} className={`bg-gray-800 p-4 rounded-lg border shadow-md flex justify-between items-center ${isMyActiveOrder ? 'border-blue-500' : 'border-white/5'}`}>
                                        <div className="space-y-2 flex-1">
                                            {/* CORREÇÃO APLICADA: Usar item_label */}
                                            <h3 className="text-lg font-bold text-amber-400">{order.item_label} <span className="text-white">x{order.quantity}</span></h3>
                                            <p className="text-sm text-gray-300"><span className="font-semibold">De:</span> {order.sourceLabel}</p>
                                            <p className="text-sm text-gray-300"><span className="font-semibold">Para:</span> {order.destinationLabel}</p>
                                        </div>
                                        <div className="text-right flex flex-col items-end gap-3 ml-4">
                                            <div className='text-right'>
                                                <p className="text-xl font-bold text-green-400">${(order.reward || 0).toLocaleString()}</p>
                                                <p className="text-xs text-gray-400">Pagamento do Frete</p>
                                            </div>
                                            <div className='text-right'>
                                                 {/* CORREÇÃO APLICADA: Usar cargo_value */}
                                                <p className="text-md font-semibold text-gray-300">${(order.cargo_value || 0).toLocaleString()}</p>
                                                <p className="text-xs text-gray-400">Valor da Carga</p>
                                            </div>
                                            
                                            {isMyActiveOrder ? (
                                                <button 
                                                    onClick={() => handleCancelOrder(order.id)}
                                                    disabled={processingId === order.id}
                                                    className="bg-red-600 hover:bg-red-700 text-white font-bold py-2 px-4 rounded-lg transition-colors text-sm disabled:bg-gray-500"
                                                >
                                                    {processingId === order.id ? 'A cancelar...' : 'Cancelar Missão'}
                                                </button>
                                            ) : (
                                                <button 
                                                    onClick={() => handleAcceptOrder(order.id)}
                                                    disabled={processingId === order.id || activeOrderId !== null}
                                                    className="bg-green-600 hover:bg-green-700 text-white font-bold py-2 px-4 rounded-lg transition-colors text-sm disabled:bg-gray-500 disabled:cursor-not-allowed"
                                                >
                                                    {processingId === order.id ? 'A processar...' : 'Aceitar'}
                                                </button>
                                            )}
                                        </div>
                                    </div>
                                )
                            })
                        )}
                    </div>
                )}
            </div>
        </div>
    );
};