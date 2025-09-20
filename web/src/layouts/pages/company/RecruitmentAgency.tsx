// src/layouts/pages/company/RecruitmentAgency.tsx

import React, { useState, useEffect, useMemo, useCallback, useRef } from 'react';
import AppHeader from '../../components/AppHeader';
import { fetchNui } from '../../../utils/fetchNui';
import { RecruitmentPost, PostType, Application, FullCompanyInfo, Chat, ChatMessage } from '../../../types';
import { CreatePostModal } from './CreatePostModal';
// Ícones atualizados
import { IconSend, IconTrash, IconArrowLeft, IconUserCircle } from '@tabler/icons-react';
import ConfirmationModal from '../../components/ConfirmationModal';

// =============================================================================
// NOVO COMPONENTE DE AVATAR
// =============================================================================
const Avatar: React.FC<{ src?: string | null; className?: string }> = ({ src, className = 'w-10 h-10' }) => {
    if (!src) {
        return <IconUserCircle className={`${className} text-gray-500`} />;
    }
    return <img src={src} alt="Avatar" className={`${className} rounded-full object-cover`} />;
};


const Notification: React.FC<{ message: string; type: 'success' | 'error' | 'info'; onClose: () => void; }> = ({ message, type, onClose }) => {
    useEffect(() => {
        const timer = setTimeout(onClose, 5000);
        return () => clearTimeout(timer);
    }, [onClose]);
    const typeClasses = { success: 'bg-green-600/90', error: 'bg-red-600/90', info: 'bg-blue-600/90' };
    return <div className={`absolute bottom-5 right-8 p-4 rounded-lg text-white font-semibold shadow-xl ${typeClasses[type]} z-50`}>{message}</div>;
};

const PostCard: React.FC<{ post: RecruitmentPost; isOwner: boolean; playerIdentifier?: string; onAction: (action: string, data: any) => void; }> = ({ post, isOwner, playerIdentifier, onAction }) => {
    const postTypeDetails = { LOOKING_FOR_JOB: { label: 'À Procura de Emprego', color: 'bg-blue-500' }, HIRING: { label: 'Vaga de Emprego', color: 'bg-green-500' }, GIG_OFFER: { label: 'Serviço Rápido', color: 'bg-purple-500' }};
    const timeAgo = new Intl.DateTimeFormat('pt-PT', { year: 'numeric', month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit' }).format(new Date(post.timestamp));
    const isAuthor = playerIdentifier === post.author_identifier;

    return (
        <div className="bg-gray-800/80 p-4 rounded-lg border border-gray-700/50 flex flex-col gap-3">
            <div className="flex justify-between items-start">
                <div className="flex items-center gap-3">
                    {/* Imagem pode ser logo da empresa ou avatar do autor */}
                    <Avatar src={post.company_logo || post.author_avatar} />
                    <div>
                        <h3 className="font-bold text-lg text-white">{post.title}</h3>
                        <p className="text-sm text-gray-400">Publicado por <span className="font-semibold text-blue-400">{post.author_name}</span>{post.company_name && ` da ${post.company_name}`}</p>
                    </div>
                </div>
                <span className={`text-xs font-semibold px-2 py-1 rounded-full text-white ${postTypeDetails[post.post_type].color}`}>{postTypeDetails[post.post_type].label}</span>
            </div>
            <p className="text-gray-300 text-sm leading-relaxed">{post.content}</p>
            <div className="flex justify-between items-center mt-2 border-t border-gray-700 pt-3">
                <p className="text-xs text-gray-500">{timeAgo}</p>
                <div className="flex gap-2">
                    {!isAuthor && isOwner && post.post_type === 'LOOKING_FOR_JOB' && <button onClick={() => onAction('hire', { postId: post.id, targetIdentifier: post.author_identifier, targetName: post.author_name })} className="py-1 px-3 bg-green-600 hover:bg-green-500 text-xs font-semibold rounded-md">Contratar</button>}
                    {!isAuthor && !isOwner && post.post_type === 'HIRING' && <button onClick={() => onAction('apply', { postId: post.id })} className="py-1 px-3 bg-blue-600 hover:bg-blue-500 text-xs font-semibold rounded-md">Candidatar-se</button>}
                    {!isAuthor && !isOwner && post.post_type === 'GIG_OFFER' && <button onClick={() => onAction('acceptGig', { postId: post.id })} className="py-1 px-3 bg-purple-600 hover:bg-purple-500 text-xs font-semibold rounded-md">Aceitar (${post.gig_payment})</button>}
                    {isAuthor && <button onClick={() => onAction('deletePost', { postId: post.id })} className="py-1 px-3 bg-red-800 hover:bg-red-700 text-xs font-semibold rounded-md">Apagar</button>}
                </div>
            </div>
        </div>
    );
};

const ApplicationsView: React.FC<{ applications: Application[]; onAction: (action: string, data: any) => void; }> = ({ applications, onAction }) => {
    if (applications.length === 0) {
        return <div className="flex items-center justify-center h-full text-gray-400">Nenhuma candidatura pendente.</div>;
    }
    return (
        <div className="space-y-3">
            {applications.map(app => (
                <div key={app.id} className="bg-gray-800/80 p-3 rounded-lg flex justify-between items-center">
                    <div className="flex items-center gap-3">
                        <Avatar src={app.applicant_avatar} />
                        <div>
                            <p className="font-bold text-white">{app.applicant_name}</p>
                            <p className="text-sm text-gray-300">Candidatou-se para: <span className="font-semibold">{app.job_title}</span></p>
                            <p className="text-xs text-gray-500">Em: {new Date(app.timestamp).toLocaleDateString('pt-PT')}</p>
                        </div>
                    </div>
                    <button onClick={() => onAction('hireFromApp', { applicationId: app.id, applicantIdentifier: app.applicant_identifier, applicantName: app.applicant_name })} className="py-2 px-4 bg-green-600 hover:bg-green-500 font-semibold rounded-md">Contratar</button>
                </div>
            ))}
        </div>
    );
};

const ChatMessageBubble: React.FC<{ message: ChatMessage; isSelf: boolean; avatarUrl?: string | null; }> = ({ message, isSelf, avatarUrl }) => {
    const alignment = isSelf ? 'justify-end' : 'justify-start';
    const bgColor = isSelf ? 'bg-blue-600' : 'bg-gray-700';
    const messageOrder = isSelf ? 'order-2' : 'order-2';
    const avatarOrder = isSelf ? 'order-3' : 'order-1';

    return (
        <div className={`flex items-end gap-2 ${alignment}`}>
             {!isSelf && <div className={avatarOrder}><Avatar src={avatarUrl} className="w-8 h-8" /></div>}
            <div className={`max-w-xs md:max-w-md lg:max-w-lg px-4 py-2 rounded-xl ${bgColor} ${messageOrder}`}>
                <p className="text-sm text-white">{message.message}</p>
                <p className={`text-xs mt-1 ${isSelf ? 'text-blue-200' : 'text-gray-400'} text-right`}>{new Date(message.timestamp).toLocaleTimeString('pt-PT', { hour: '2-digit', minute: '2-digit'})}</p>
            </div>
        </div>
    );
};

const ChatView: React.FC<{ companyData: FullCompanyInfo; onChatDeleted: () => void; showNotification: (type: 'success' | 'error' | 'info', message: string) => void; }> = ({ companyData, onChatDeleted, showNotification }) => {
    const [view, setView] = useState<'list' | 'chat'>('list');
    const [chats, setChats] = useState<Chat[]>([]);
    const [selectedChat, setSelectedChat] = useState<Chat | null>(null);
    const [messages, setMessages] = useState<ChatMessage[]>([]);
    const [newMessage, setNewMessage] = useState('');
    const [isLoading, setIsLoading] = useState(true);
    const [chatToDelete, setChatToDelete] = useState<Chat | null>(null);
    const messagesContainerRef = useRef<HTMLDivElement>(null);

    // =========================================================================
    // LÓGICA DE SOM DE NOTIFICAÇÃO
    // =========================================================================
    // Carrega o som. Coloque o seu arquivo de áudio em /public/sounds/
    const notificationSound = useMemo(() => new Audio('/sounds/notification.ogg'), []);

    const fetchChatList = useCallback(() => {
        setIsLoading(true);
        fetchNui<Chat[]>('getChatList').then(setChats).finally(() => setIsLoading(false));
    }, []);

    useEffect(() => {
        fetchChatList();
    }, [fetchChatList]);

    useEffect(() => {
        if (!selectedChat) return;

        const fetchMessages = () => {
             fetchNui<ChatMessage[]>('getChatMessages', { chatId: selectedChat.id }).then(newMessages => {
                setMessages(prevMessages => {
                    // Verifica se há novas mensagens e se a última não é do próprio usuário
                    if (newMessages.length > prevMessages.length) {
                        const latestMessage = newMessages[newMessages.length - 1];
                        if (latestMessage.author_identifier !== companyData.profile_data?.identifier) {
                             notificationSound.play().catch(e => console.error("Erro ao tocar o som:", e));
                        }
                    }
                    return newMessages;
                });
            });
        }
        
        fetchMessages();
        const interval = setInterval(fetchMessages, 5000);
        return () => clearInterval(interval);
    }, [selectedChat, companyData.profile_data?.identifier, notificationSound]);

    // Scroll para a última mensagem
    useEffect(() => {
        if (messagesContainerRef.current) {
            messagesContainerRef.current.scrollTop = messagesContainerRef.current.scrollHeight;
        }
    }, [messages]);

    const handleSendMessage = async () => {
        if (!newMessage.trim() || !selectedChat || !companyData.profile_data) return;
        const tempMessage = newMessage;
        setNewMessage('');

        const myNewMessage: ChatMessage = { 
            id: Date.now(), 
            author_identifier: companyData.profile_data.identifier, 
            author_name: companyData.profile_data.profile_name, 
            message: tempMessage, 
            timestamp: new Date().toISOString() 
        };
        setMessages(prev => [...prev, myNewMessage]);
        setTimeout(() => { messagesContainerRef.current?.scrollTo({ top: messagesContainerRef.current.scrollHeight, behavior: "smooth" }); }, 100);

        const result = await fetchNui<any>('sendChatMessage', { chatId: selectedChat.id, message: tempMessage });
        if (!result.success) {
            showNotification('error', 'Falha ao enviar mensagem.');
            setMessages(prev => prev.filter(m => m.id !== myNewMessage.id)); // Remove a mensagem otimista
        }
    };

    const handleDeleteChat = async () => {
        if (!chatToDelete) return;
        const result = await fetchNui<any>('deleteChat', { chatId: chatToDelete.id });
        showNotification(result.success ? 'success' : 'error', result.message);
        setChatToDelete(null);
        if (result.success) {
            setSelectedChat(null);
            setView('list');
            fetchChatList();
        }
    };

    const openChat = (chat: Chat) => {
        setSelectedChat(chat);
        setView('chat');
    };

    if (view === 'list') {
        return (
            <div className="flex-1 flex flex-col bg-black/20 rounded-lg overflow-hidden">
                <div className="p-4 border-b border-gray-700/50"><h2 className="text-xl font-bold text-white">Conversas</h2></div>
                <div className="flex-1 overflow-y-auto">
                    {isLoading ? <p className="text-center text-gray-400 p-4">A carregar conversas...</p> 
                     : chats.length === 0 ? <p className="text-center text-gray-400 p-4">Nenhuma conversa encontrada.</p>
                     : chats.map(chat => (
                        <button key={chat.id} onClick={() => openChat(chat)} className="w-full text-left p-4 flex items-center gap-3 hover:bg-gray-700/50 border-b border-gray-700/50">
                            <Avatar src={chat.partner_avatar} />
                            <div className="flex-1 overflow-hidden">
                               <p className="font-semibold text-white truncate">{chat.partner_name}</p>
                               <p className="text-sm text-gray-400 truncate">{chat.post_title}</p>
                            </div>
                        </button>
                    ))}
                </div>
            </div>
        );
    }
    
    if (view === 'chat' && selectedChat) {
        return (
            <div className="flex-1 flex flex-col bg-black/20 rounded-lg overflow-hidden">
                <div className="p-4 border-b border-gray-700/50 flex justify-between items-center">
                    <button onClick={() => setView('list')} className="p-2 text-gray-400 hover:text-white hover:bg-white/10 rounded-full"><IconArrowLeft size={20} /></button>
                    <div className="text-center flex items-center gap-3">
                         <Avatar src={selectedChat.partner_avatar} />
                        <div>
                           <h2 className="text-xl font-bold text-white">{selectedChat.partner_name}</h2>
                           <p className="text-sm text-gray-400">Sobre: {selectedChat.post_title}</p>
                        </div>
                    </div>
                    <button onClick={() => setChatToDelete(selectedChat)} className="p-2 text-gray-400 hover:text-white hover:bg-red-500/20 rounded-md" title="Apagar Conversa"><IconTrash size={20} /></button>
                </div>
                <div ref={messagesContainerRef} className="flex-1 p-4 overflow-y-auto space-y-4">
                    {messages.map(msg => <ChatMessageBubble key={msg.id} message={msg} isSelf={msg.author_identifier === companyData.profile_data?.identifier} avatarUrl={selectedChat.partner_avatar} />)}
                </div>
                <div className="p-4 bg-gray-900/50 flex items-center gap-4">
                    <input type="text" value={newMessage} onChange={e => setNewMessage(e.target.value)} onKeyPress={e => e.key === 'Enter' && handleSendMessage()} placeholder="Escreva uma mensagem..." className="flex-1 p-3 bg-gray-700 rounded-lg text-white border-gray-600" />
                    <button onClick={handleSendMessage} className="p-3 bg-blue-600 hover:bg-blue-500 rounded-lg"><IconSend /></button>
                </div>
                {chatToDelete && <ConfirmationModal isOpen={!!chatToDelete} onClose={() => setChatToDelete(null)} onConfirm={handleDeleteChat} title="Apagar Conversa" description="Tem a certeza que deseja apagar esta conversa permanentemente?" />}
            </div>
        );
    }

    return null;
};


export const RecruitmentAgency: React.FC<{ companyData: FullCompanyInfo; onBack: () => void; }> = ({ companyData, onBack }) => {
    // ... (nenhuma mudança nesta parte, apenas no conteúdo do main)
    const { is_owner: isOwner } = companyData;
    const [activeTab, setActiveTab] = useState<'FEED' | 'APPLICATIONS' | 'CHATS'>('FEED');
    const [posts, setPosts] = useState<RecruitmentPost[]>([]);
    const [applications, setApplications] = useState<Application[]>([]);
    const [isLoading, setIsLoading] = useState(true);
    const [isCreateModalOpen, setCreateModalOpen] = useState(false);
    const [notification, setNotification] = useState<{ type: 'success' | 'error' | 'info'; message: string } | null>(null);

    const showNotification = (type: 'success' | 'error' | 'info', message: string) => { setNotification({ type, message }); };
    const fetchFeed = useCallback(() => { setIsLoading(true); fetchNui<RecruitmentPost[]>('getRecruitmentPosts').then(setPosts).catch(console.error).finally(() => setIsLoading(false)); }, []);
    const fetchApplications = useCallback(() => { if (!isOwner) return; setIsLoading(true); fetchNui<Application[]>('getCompanyApplications').then(setApplications).catch(console.error).finally(() => setIsLoading(false)); }, [isOwner]);

    useEffect(() => {
        if (activeTab === 'FEED') {
            fetchFeed();
        } else if (activeTab === 'APPLICATIONS') {
            fetchApplications();
        }
    }, [activeTab, fetchFeed, fetchApplications]);

    const handlePostCreated = () => { setCreateModalOpen(false); showNotification('success', 'Anúncio publicado com sucesso!'); if (activeTab === 'FEED') fetchFeed(); };

    const handleAction = async (action: string, data: any) => {
        let result;
        switch (action) {
            case 'acceptGig':
                result = await fetchNui<any>('acceptGig', data);
                showNotification(result.success ? 'success' : 'error', result.message);
                if (result.success) {
                    fetchFeed();
                    setActiveTab('CHATS');
                }
                break;
            case 'deletePost': result = await fetchNui<any>('deleteRecruitmentPost', data); showNotification(result.success ? 'success' : 'error', result.message); if (result.success) fetchFeed(); break;
            case 'apply': result = await fetchNui<any>('applyForJob', data); showNotification(result.success ? 'success' : 'error', result.message); break;
            case 'hireFromApp': result = await fetchNui<any>('hireFromApplication', data); if (result.success) { showNotification('success', result.message); fetchApplications(); } else { showNotification('error', result.message); } break;
            case 'hire': result = await fetchNui<any>('hireFromPost', data); showNotification(result.success ? 'success' : 'error', result.message); if (result.success) fetchFeed(); break;
        }
    };

    return (
        <div className="w-full h-full p-8 flex flex-col bg-gray-900 relative">
            <AppHeader title="Agência de Recrutamento" onBack={onBack} />
            <div className="flex items-center justify-between mb-4">
                <div className="flex gap-2 bg-gray-800 p-1 rounded-lg">
                    <button onClick={() => setActiveTab('FEED')} className={`px-4 py-1.5 text-sm font-semibold rounded-md ${activeTab === 'FEED' ? 'bg-blue-600 text-white' : 'text-gray-300 hover:bg-gray-700'}`}>Feed</button>
                    {isOwner && <button onClick={() => setActiveTab('APPLICATIONS')} className={`px-4 py-1.5 text-sm font-semibold rounded-md ${activeTab === 'APPLICATIONS' ? 'bg-yellow-600 text-white' : 'text-gray-300 hover:bg-gray-700'}`}>Candidaturas</button>}
                    <button onClick={() => setActiveTab('CHATS')} className={`px-4 py-1.5 text-sm font-semibold rounded-md ${activeTab === 'CHATS' ? 'bg-purple-600 text-white' : 'text-gray-300 hover:bg-gray-700'}`}>Chats</button>
                </div>
                <button onClick={() => setCreateModalOpen(true)} className="py-2 px-5 bg-blue-600 hover:bg-blue-500 rounded-lg font-semibold">+ Criar Anúncio</button>
            </div>
            <main className="flex-1 overflow-hidden flex">
                {activeTab === 'CHATS' ? <ChatView companyData={companyData} showNotification={showNotification} onChatDeleted={fetchFeed} />
                    : isLoading ? <div className="flex-1 bg-black/20 rounded-lg p-4 h-full flex items-center justify-center text-gray-400">A carregar...</div>
                    : activeTab === 'FEED' ? (
                        <div className="flex-1 bg-black/20 rounded-lg p-4 space-y-4 overflow-y-auto h-full">
                            {posts.length > 0 ? posts.map(post => <PostCard key={post.id} post={post} isOwner={isOwner || false} playerIdentifier={companyData.profile_data?.identifier} onAction={handleAction} />)
                            : <div className="flex items-center justify-center h-full text-gray-400">Nenhum anúncio encontrado.</div>}
                        </div>
                    ) : (
                        <div className="flex-1 bg-black/20 rounded-lg p-4 overflow-y-auto h-full">
                            <ApplicationsView applications={applications} onAction={handleAction} />
                        </div>
                    )}
            </main>
            {isCreateModalOpen && <CreatePostModal onClose={() => setCreateModalOpen(false)} onSuccess={handlePostCreated} isOwner={isOwner || false} />}
            {notification && <Notification message={notification.message} type={notification.type} onClose={() => setNotification(null)} />}
        </div>
    );
};