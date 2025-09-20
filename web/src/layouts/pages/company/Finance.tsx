// src/layouts/pages/company/Finance.tsx

import React, { useMemo, useState, useCallback, useEffect } from 'react';
import { FullCompanyInfo, CompanyTransaction } from '../../../types';
import AppHeader from '../../components/AppHeader';
import { fetchNui } from '../../../utils/fetchNui';
import { ResponsiveContainer, PieChart, Pie, Cell, Tooltip, Legend } from 'recharts';

const Notification: React.FC<{ message: string; type: 'success' | 'error'; onClose: () => void; }> = ({ message, type, onClose }) => {
    useEffect(() => {
        const timer = setTimeout(onClose, 3000);
        return () => clearTimeout(timer);
    }, [onClose]);

    const bgColor = type === 'success' ? 'bg-green-600/90' : 'bg-red-600/90';
    return (
        <div className={`absolute bottom-5 right-5 p-4 rounded-lg text-white font-semibold shadow-lg ${bgColor}`}>
            {message}
        </div>
    );
};

const TransactionRow: React.FC<{ transaction: CompanyTransaction }> = ({ transaction }) => {
    const isDeposit = transaction.amount >= 0;
    const date = new Date(transaction.timestamp).toLocaleDateString('pt-BR');
    const time = new Date(transaction.timestamp).toLocaleTimeString('pt-BR', { hour: '2-digit', minute: '2-digit' });

    return (
        <div className="flex justify-between items-center bg-gray-800/60 p-3 rounded-md">
            <div>
                <p className="font-medium text-white">{transaction.description}</p>
                <p className="text-xs text-gray-400">{date} às {time}</p>
            </div>
            <p className={`font-bold text-lg ${isDeposit ? 'text-green-400' : 'text-red-400'}`}>
                {isDeposit ? '+' : '-'} ${Math.abs(transaction.amount).toLocaleString()}
            </p>
        </div>
    );
};

export const Finance: React.FC<{
    companyData: FullCompanyInfo;
    updateCompanyData: (data: Partial<FullCompanyInfo>) => void;
    onBack: () => void;
}> = ({ companyData, updateCompanyData, onBack }) => {
    const [amount, setAmount] = useState('');
    const [isProcessing, setIsProcessing] = useState(false);
    const [notification, setNotification] = useState<{ type: 'success' | 'error'; message: string } | null>(null);

    const transactions = useMemo(() => Array.isArray(companyData.transactions) ? companyData.transactions : [], [companyData.transactions]);

    const chartData = useMemo(() => {
        if (transactions.length === 0) return [];

        const totals = transactions.reduce(
            (acc, tx) => {
                if (tx.amount > 0) acc.income += tx.amount;
                else acc.expenses += Math.abs(tx.amount);
                return acc;
            },
            { income: 0, expenses: 0 }
        );

        return [
            { name: 'Receitas', value: totals.income },
            { name: 'Despesas', value: totals.expenses },
        ].filter(d => d.value > 0);
    }, [transactions]);

    const COLORS = ['#22c55e', '#ef4444'];

    const handleTransaction = useCallback(async (type: 'deposit' | 'withdraw') => {
        if (isProcessing) return;

        const value = parseInt(amount);
        if (isNaN(value) || value <= 0) {
            setNotification({ type: 'error', message: "Por favor, insira um valor válido." });
            return;
        }

        setIsProcessing(true);
        const eventName = type === 'deposit' ? 'depositMoney' : 'withdrawMoney';
        const result = await fetchNui<any>(eventName, { amount: value });

        if (result.success) {
            // LÓGICA FINAL: Usamos a função de update que vem das props.
            // O `safeUpdateCompanyData` que corrigimos no CompanyPanel vai tratar de tudo.
            updateCompanyData(result.updatedData);
            
            setNotification({ type: 'success', message: `Operação de ${type === 'deposit' ? 'depósito' : 'levantamento'} bem-sucedida!` });
            setAmount('');
        } else {
            setNotification({ type: 'error', message: `Erro: ${result.message}` });
        }

        setIsProcessing(false);
    }, [amount, isProcessing, updateCompanyData]);

    if (!companyData.company_data) {
        return <div className="p-8 text-white w-full h-full flex items-center justify-center">A carregar...</div>;
    }

    return (
        <div className="w-full h-full p-8 flex flex-col gap-8 bg-gray-900 relative">
            <AppHeader title="Finanças" onBack={onBack} logoUrl={companyData.company_data.logo_url} />

            <div className="flex-1 grid grid-cols-1 lg:grid-cols-3 gap-8 overflow-hidden">
                <div className="lg:col-span-1 flex flex-col gap-6 overflow-y-auto pr-2">
                    <div className="bg-gray-800 p-6 rounded-lg">
                        <h3 className="text-sm font-medium text-gray-400">SALDO ATUAL</h3>
                        <p className="mt-2 text-4xl font-bold text-green-400">${companyData.company_data.balance.toLocaleString()}</p>
                    </div>

                    <div className="bg-gray-800 p-6 rounded-lg h-72 flex flex-col">
                        <h2 className="text-xl font-semibold text-white mb-4">Resumo Financeiro</h2>
                        <div className="flex-1 w-full h-full">
                            <ResponsiveContainer width="100%" height="100%">
                                {chartData.length > 0 ? (
                                    <PieChart>
                                        <Pie data={chartData} dataKey="value" nameKey="name" cx="50%" cy="50%" outerRadius={'80%'} fill="#8884d8">
                                            {chartData.map((entry, index) => (
                                                <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                                            ))}
                                        </Pie>
                                        <Tooltip formatter={(value: number) => `$${value.toLocaleString()}`} />
                                        <Legend wrapperStyle={{ fontSize: '14px' }} />
                                    </PieChart>
                                ) : (
                                    <div className="flex items-center justify-center h-full text-gray-400">Sem dados para o gráfico.</div>
                                )}
                            </ResponsiveContainer>
                        </div>
                    </div>
                    
                    <div className="bg-gray-800 p-6 rounded-lg">
                        <h2 className="text-xl font-semibold text-white mb-4">Operações</h2>
                        <div className="space-y-4">
                            <div>
                                <label htmlFor="amount" className="block text-sm font-medium text-gray-300 mb-1">Valor</label>
                                <input
                                    type="number" id="amount" value={amount}
                                    onChange={(e) => setAmount(e.target.value)}
                                    placeholder="0"
                                    className="w-full p-2 bg-gray-700 rounded-md text-white border border-gray-600 focus:outline-none focus:ring-2 focus:ring-blue-500"
                                    disabled={isProcessing}
                                />
                            </div>
                            <div className="flex gap-4">
                                <button onClick={() => handleTransaction('deposit')} disabled={isProcessing} className="flex-1 py-2 bg-green-600 hover:bg-green-500 rounded-md font-semibold transition-colors disabled:opacity-50">
                                    {isProcessing ? 'A processar...' : 'Depositar'}
                                </button>
                                <button onClick={() => handleTransaction('withdraw')} disabled={isProcessing} className="flex-1 py-2 bg-red-600 hover:bg-red-500 rounded-md font-semibold transition-colors disabled:opacity-50">
                                    {isProcessing ? 'A processar...' : 'Levantar'}
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <div className="lg:col-span-2 bg-gray-800 p-6 rounded-lg flex flex-col overflow-hidden">
                    <h2 className="text-xl font-semibold text-white mb-4 shrink-0">Extrato de Transações</h2>
                    <div className="space-y-3 overflow-y-auto pr-2 flex-1">
                        {transactions.length > 0 ? (
                            [...transactions].reverse().map(tx => <TransactionRow key={tx.id} transaction={tx} />)
                        ) : (
                            <p className="text-gray-400 text-center pt-10">Nenhuma transação encontrada.</p>
                        )}
                    </div>
                </div>
            </div>

            {notification && <Notification message={notification.message} type={notification.type} onClose={() => setNotification(null)} />}
        </div>
    );
};