// src/layouts/pages/company/CreatePostModal.tsx

import React, { useState } from 'react';
import { fetchNui } from '../../../utils/fetchNui';
import { PostType } from '../../../types';

interface CreatePostModalProps {
    onClose: () => void;
    onSuccess: () => void; // Para atualizar a lista de posts
    isOwner: boolean;
}

export const CreatePostModal: React.FC<CreatePostModalProps> = ({ onClose, onSuccess, isOwner }) => {
    const [postType, setPostType] = useState<PostType>('LOOKING_FOR_JOB');
    const [title, setTitle] = useState('');
    const [content, setContent] = useState('');
    const [gigPayment, setGigPayment] = useState('');
    const [isSubmitting, setIsSubmitting] = useState(false);
    const [error, setError] = useState<string | null>(null);

    const handleSubmit = async () => {
        if (isSubmitting) return;
        
        if (!title.trim() || !content.trim()) {
            setError("O título e a descrição são obrigatórios.");
            return;
        }

        if (postType === 'GIG_OFFER' && (isNaN(parseInt(gigPayment)) || parseInt(gigPayment) <= 0)) {
            setError("O pagamento pelo serviço deve ser um número válido e positivo.");
            return;
        }
        
        setIsSubmitting(true);
        setError(null);

        const result = await fetchNui<any>('createRecruitmentPost', {
            postType,
            title,
            content,
            gigPayment: postType === 'GIG_OFFER' ? parseInt(gigPayment) : undefined,
        });

        if (result.success) {
            onSuccess();
        } else {
            setError(result.message || "Ocorreu um erro desconhecido.");
            setIsSubmitting(false);
        }
    };

    return (
        <div className="absolute inset-0 bg-black/70 flex items-center justify-center z-50">
            <div className="bg-gray-800 w-full max-w-2xl rounded-lg p-8 border border-gray-700 shadow-xl flex flex-col gap-6">
                <h2 className="text-2xl font-bold text-white">Criar Novo Anúncio</h2>

                {error && <div className="bg-red-500/20 border border-red-500 text-red-300 p-3 rounded-md text-sm">{error}</div>}

                {/* Seletor de Tipo de Anúncio */}
                <div className="grid grid-cols-3 gap-2 bg-gray-900 p-1 rounded-lg">
                    <button onClick={() => setPostType('LOOKING_FOR_JOB')} className={`px-4 py-2 text-sm font-semibold rounded-md ${postType === 'LOOKING_FOR_JOB' ? 'bg-blue-600 text-white' : 'text-gray-300 hover:bg-gray-700'}`}>Procuro Emprego</button>
                    <button onClick={() => setPostType('GIG_OFFER')} className={`px-4 py-2 text-sm font-semibold rounded-md ${postType === 'GIG_OFFER' ? 'bg-purple-600 text-white' : 'text-gray-300 hover:bg-gray-700'}`}>Serviço Rápido</button>
                    {isOwner && <button onClick={() => setPostType('HIRING')} className={`px-4 py-2 text-sm font-semibold rounded-md ${postType === 'HIRING' ? 'bg-green-600 text-white' : 'text-gray-300 hover:bg-gray-700'}`}>Anunciar Vaga</button>}
                </div>

                {/* Formulário */}
                <div className="space-y-4">
                    <input type="text" placeholder="Título do Anúncio (Ex: Motorista Experiente Procura Trabalho)" value={title} onChange={e => setTitle(e.target.value)} className="w-full p-3 bg-gray-700 rounded-md text-white placeholder-gray-400 border border-gray-600" />
                    <textarea placeholder="Descrição detalhada..." value={content} onChange={e => setContent(e.target.value)} className="w-full p-3 bg-gray-700 rounded-md text-white placeholder-gray-400 border border-gray-600 h-32 resize-none" />
                    {postType === 'GIG_OFFER' && (
                        <input type="number" placeholder="Pagamento pelo Serviço (Ex: 5000)" value={gigPayment} onChange={e => setGigPayment(e.target.value)} className="w-full p-3 bg-gray-700 rounded-md text-white placeholder-gray-400 border border-gray-600" />
                    )}
                </div>
                
                {/* Botões de Ação */}
                <div className="flex justify-end gap-4 mt-4">
                    <button onClick={onClose} className="py-2 px-6 bg-gray-600 hover:bg-gray-500 rounded-md font-semibold">Cancelar</button>
                    <button onClick={handleSubmit} disabled={isSubmitting} className="py-2 px-6 bg-blue-600 hover:bg-blue-500 rounded-md font-semibold disabled:opacity-50">
                        {isSubmitting ? 'A Publicar...' : 'Publicar Anúncio'}
                    </button>
                </div>
            </div>
        </div>
    );
};