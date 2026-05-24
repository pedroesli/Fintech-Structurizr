workspace "Startup Fintech - Modelo C4" "Arquitetura de uma startup fintech digital baseada em BaaS" {

    !identifiers hierarchical
    
    model {

        cliente = person "Cliente" "Usuário final da plataforma fintech."
        operador = person "Operador Administrativo" "Responsável por suporte operacional, auditoria e monitoramento."

        fintech = softwareSystem "Plataforma Fintech" "Plataforma digital para conta, Pix, boletos, ledger e compliance." {

            app = container "App Mobile/Web" "Aplicação usada pelos clientes da fintech." "React Native / Web" { 
                tags "Frontend"
            }

            backend = container "Backend Fintech" "Backend principal da fintech, organizado como monólito modular." "Kotlin + Spring Boot" {

                auth = component "Auth Component" "Autenticação, autorização, MFA, sessões e tokens."

                account = component "Conta Digital Component" "Gestão de contas, saldo, extrato e limites."

                pix = component "Pix Component" "Envio, recebimento, QR Code e webhooks de Pix."

                boletos = component "Boletos Component" "Emissão, consulta, liquidação e cancelamento de boletos."

                ledger = component "Ledger Component" "Registro financeiro, saldo, extratos, taxas e reconciliação."

                complianceIntegration = component "Compliance Integration Component" "KYC, PLD/FT, validação documental e antifraude."

                audit = component "Auditoria Component" "Logs, trilha de auditoria, rastreabilidade e eventos operacionais."

                notification = component "Notification Component" "Envio de email, SMS, push e alertas operacionais."

                coreBankingIntegration = component "Core Banking Integration Component" "Integração com parceiros financeiros externos."

                // Relações internas

                auth -> account "Autoriza acesso e permissões"

                account -> ledger "Consulta saldo e extrato"
                account -> audit "Registra ações sensíveis"

                pix -> complianceIntegration "Valida elegibilidade da operação"
                pix -> ledger "Registra movimentação financeira"
                pix -> coreBankingIntegration "Processa operação via parceiro"

                boletos -> complianceIntegration "Valida operação"
                boletos -> ledger "Registra movimentação financeira"
                boletos -> coreBankingIntegration "Emite e liquida boleto via parceiro"

                complianceIntegration -> audit "Registra validações e decisões"

                coreBankingIntegration -> audit "Registra chamadas externas"

                notification -> audit "Registra envio e status"

                // Fluxos assíncronos
            }

            ledgerDb = container "Ledger Database" "Banco transacional exclusivo do ledger." "PostgreSQL" { 
                tags "Database"
            }

            auditDb = container "Audit Database" "Banco exclusivo para logs e trilhas de auditoria." "PostgreSQL" {
                tags "Database"
            }

            broker = container "Message Broker" "Mensageria e eventos assíncronos." "RabbitMQ"

            // Relações externas

            app -> backend "Consome API" "REST/HTTPS"

            backend.ledger -> ledgerDb "Lê e grava dados financeiros" "SQL/TCP"

            backend.audit -> auditDb "Lê e grava logs e auditoria" "SQL/TCP"

            backend -> broker "Publica e consome eventos"
        }

        coreBanking = softwareSystem "Dock Core Banking (BaaS)" "Parceiro Banking as a Service para Pix, boletos e liquidação."

        compliance = softwareSystem "Unico Compliance" "Parceiro para KYC, validação documental e antifraude."

        notificationProvider = softwareSystem "Twilio Serviço de Notificações" "Provedor externo de email, SMS e push."

        // Usuários
        cliente -> fintech.app "Utiliza"

        operador -> fintech.backend "Monitora operações"

        // Integrações externas

        fintech.backend.coreBankingIntegration -> coreBanking "Integra APIs financeiras"

        fintech.backend.complianceIntegration -> compliance "Executa KYC e validação"

        fintech.backend.notification -> notificationProvider "Envia notificações"
    }

    views {

        systemContext fintech "SystemContext" {
            include *
            autoLayout lr
        }

        container fintech "Containers" {
            include *
            autoLayout lr
        }

        component fintech.backend "BackendComponents" {
            include *
            autoLayout tb
        }

        styles {
            element "Person" {
                shape person
                background "#08427b"
                color "#ffffff"
                stroke #aaaaaa
                strokeWidth 5
            }

            element "Container" {
                shape roundedBox
                background "#438dd5"
                color "#ffffff"
            }

            element "Component" {
                shape roundedBox
                background "#85bbf0"
                color "#000000"
            }

            element "Database" {
                shape cylinder
                background "#facc2e"
                color "#000000"
            }

            element "Frontend" {
                shape window
            }
        }   
    }
}
