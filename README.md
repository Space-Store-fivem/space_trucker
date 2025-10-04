Space Trucker - Gestão Avançada de Logística e Empresas
Space Trucker é um script completo e robusto para FiveM, focado em criar uma economia de logística profunda e interativa. Construído para ser compatível com os frameworks QBCore e QBox, ele permite que os jogadores abandonem a vida de caminhoneiro solitário para se tornarem magnatas da logística, criando e gerindo as suas próprias empresas, contratando outros jogadores, controlando indústrias e dominando o mercado de transportes.

A interação é centralizada num Tablet moderno e intuitivo, que serve como o centro de comando para todas as operações da empresa.

✨ Funcionalidades Principais
Este script transforma a simples entrega de cargas numa experiência de gestão complexa e recompensadora.

🏢 Sistema de Empresas
Criação de Empresas: Qualquer jogador pode fundar a sua própria empresa de logística a partir do Tablet, definindo um nome e um logótipo.

Gestão via Tablet: Todas as funcionalidades de gestão são acedidas através de um item (tablet), proporcionando uma interface de utilizador limpa e centralizada.

Transferência de Propriedade: Donos de empresas podem transferir a propriedade para outros jogadores.

🚚 Central de Logística (Logistics Hub)
Mercado de Fretes: Um painel onde empresas podem publicar encomendas de transporte personalizadas, definindo o produto, quantidade, origem, destino e recompensa.

Contratos de Jogadores e Sistema: Caminhoneiros independentes podem visualizar e aceitar contratos publicados tanto por empresas de jogadores como por encomendas geradas pelo sistema.

Cálculo Dinâmico: O custo da encomenda e a recompensa para o caminhoneiro são calculados com base no valor de mercado da carga.

👥 Gestão de Funcionários
Contratação e Despedimento: Donos de empresas podem contratar outros jogadores como seus funcionários.

Cargos e Salários: Defina cargos (ex: Motorista, Gerente) e salários individuais para cada funcionário.

Pagamento Automático de Salários: Um sistema de cron job paga automaticamente os salários dos funcionários a cada hora (configurável), debitando do saldo da empresa e notificando tanto o dono como os funcionários.

💰 Sistema Financeiro
Balanço da Empresa: Cada empresa possui uma conta bancária própria, separada do dinheiro pessoal do dono.

Registo de Transações: Todas as entradas e saídas (custos de encomendas, pagamento de fretes, salários, compra de indústrias) são registadas num painel de finanças detalhado.

Depósitos e Levantamentos: O dono pode depositar e levantar dinheiro da conta da empresa.

🏭 Propriedade de Indústrias
Compra e Venda de Indústrias: As empresas podem comprar indústrias disponíveis no mapa (primárias, secundárias, terciárias).

Gestão de Estoque: O dono da indústria controla o estoque de matérias-primas (WANTED) e produtos acabados (FOR SALE).

Cadeia de Suprimentos: Ser dono de uma indústria permite criar encomendas para abastecer o seu próprio estoque ou vender a produção para outros jogadores, criando uma cadeia de suprimentos realista.

🚛 Gestão de Frota
Garagem de Empresa: As empresas podem definir uma localização de garagem para spawnar os veículos da sua frota.

Compra e Aluguer de Veículos: Adicione veículos à frota da empresa através de compra ou aluguer por tempo limitado (o sistema remove automaticamente os veículos expirados).

Monitorização da Frota: Visualize o estado de todos os veículos (na garagem, em uso), a sua matrícula, modelo e quem foi o último a usá-lo.

🗺️ Outras Funcionalidades
Painel de Cargas: Uma enciclopédia dentro do tablet que detalha todos os tipos de carga existentes, o seu tipo de transporte e os veículos compatíveis.

Sistema de Missões: Interface para os caminhoneiros acompanharem a sua entrega ativa, com informações de rota e carga.

Interface Moderna: A interface de utilizador (UI) é construída com React, garantindo uma experiência fluida e responsiva.

🔧 Dependências
Para que o space_trucker funcione corretamente, as seguintes dependências são obrigatórias:

Framework: QBCore ou QBox

Base: ox_lib

Target: ox_target

Base de Dados: mysql-async

🛠️ Instalação
Siga estes passos cuidadosamente para instalar o script no seu servidor.

Download: Descarregue ou clone este repositório para a sua pasta resources.

Base de Dados: Execute o ficheiro sql.sql na sua base de dados para criar todas as tabelas necessárias.

Compilar a Interface (UI):

Navegue até à pasta web/.

Execute pnpm install (ou npm install / yarn install) para instalar as dependências.

Execute pnpm build (ou npm run build / yarn build) para compilar a interface.

Configuração: Abra o ficheiro shared/gst_config.lua e ajuste as configurações principais, especialmente o nome do item que servirá como tablet.

Garantir o Recurso: Adicione ensure space_trucker ao seu ficheiro server.cfg. Importante: certifique-se de que ele é iniciado depois de todas as suas dependências (qb-core, ox_lib, etc.).

⚙️ Configuração (shared/gst_config.lua)
Este ficheiro é o centro de toda a personalização do script. Aqui estão as opções mais importantes:

Configuração
spaceconfig.Framework	Define o framework a ser usado. Mantenha como "qb-core". O script é compatível com QBox por usar as mesmas funções base.
spaceconfig.TabletItem	(MUITO IMPORTANTE) O nome do item que abrirá o painel de gestão. Ex: "tablet". Certifique-se de que este item existe nos shared/items.lua do seu framework.
spaceconfig.Company.CreationCost	O custo em dinheiro (banco) para criar uma nova empresa.
spaceconfig.Company.Locations	Coordenadas para os NPCs de criação de empresa e gestão de indústrias.
spaceconfig.Industry.UpdateTime	Intervalo de tempo (em segundos) para o cron job de pagamento de salários.
spaceconfig.VehicleTransport	Tabela para configurar todos os veículos de transporte, a sua capacidade, tipo de carga e props visuais.
spaceconfig.IndustryItems	Tabela para configurar todos os tipos de carga, o seu "label", capacidade e tipo de transporte.

Esporta in Fogli
🎮 Como Usar (Guia para Jogadores)
Obter o Tablet: Adquira o item definido em spaceconfig.TabletItem (por exemplo, numa loja).

Usar o Item: Use o item a partir do seu inventário para abrir a interface do Space Trucker.

Criar um Perfil: A primeira vez, será solicitado que crie um "Perfil de Caminhoneiro" (nome e avatar).

Criar uma Empresa: Após criar o perfil, na tela inicial, terá a opção de criar a sua própria empresa, pagando a taxa definida.

Gerir a Empresa: Se for dono de uma empresa, o tablet abrirá diretamente no painel de gestão, onde poderá aceder a todas as funcionalidades:

Dashboard: Visão geral da empresa.

Finanças: Verifique o balanço e as transações.

Funcionários: Contrate e gira a sua equipa.

Frota: Compre e gira os seus veículos.

Indústrias: Compre e administre as suas propriedades industriais.

Central de Logística: Crie encomendas para outros jogadores ou aceite encomendas existentes para ganhar dinheiro como caminhoneiro.