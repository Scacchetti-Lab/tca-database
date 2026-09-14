-- 1) ADDRESSES (sem dependências)
INSERT INTO "addresses"
  ("id", "postalcode", "number", "name", "complement", "state", "uf", "neighborhood")
VALUES
  ('a0000000-0000-0000-0000-000000000001', '01310100', '1000', 'Av. Paulista', 'Sala 10', 'São Paulo', 'SP', 'Bela Vista');

-- 2) PROFILES (sem dependências)
INSERT INTO "profiles"
  ("id", "name", "is_admin")
VALUES
  ('a0000000-0000-0000-0000-000000000002', 'Administrador', true);

-- 3) TRANSCRIPTS (sem dependências)
INSERT INTO "transcripts"
  ("id", "raw_transcript", "resume", "status")
VALUES
  ('a0000000-0000-0000-0000-000000000003', 'Texto bruto da transcrição da reunião...', 'Resumo da reunião com o cliente.', 'DONE');

-- 4) CONFIGURATIONS (sem dependências)
INSERT INTO "configurations"
  ("id", "key", "type", "content")
VALUES
  ('a0000000-0000-0000-0000-000000000004', 'MAX_TOKENS_PER_USER', 'INTEGER', '10000');

-- 5) TEMPLATE (sem dependências)
INSERT INTO "template"
  ("id", "subject", "body", "created_on", "updated_on")
VALUES
  ('a0000000-0000-0000-0000-000000000005', 'Boas-vindas', 'Olá {{nome}}, seja bem-vindo(a)!', now(), now());

-- 6) USERS (depende de ADDRESSES; created_by fica NULL neste insert inicial)
INSERT INTO "users"
  ("id", "full_name", "username", "cpf", "mobile_phone", "birth_date", "email", "password",
   "profile_photo_url", "address_id", "score", "ai_token_used", "status", "is_deleted",
   "use_mfa", "mfa_token", "modified_on", "created_by", "created_on")
VALUES
  ('a0000000-0000-0000-0000-000000000006', 'João da Silva', 'joao.silva', '12345678901', '11999990000',
   '1990-05-10', 'joao.silva@empresa.com', 'hash_da_senha', 'https://cdn.empresa.com/fotos/joao.png',
   'a0000000-0000-0000-0000-000000000001', 100, 0, 'ACTIVE', false, false, NULL, now(), NULL, now());

-- 7) MANAGERS (depende de USERS)
INSERT INTO "managers"
  ("id", "user_id", "total_meetings", "total_squads", "unit", "score_goal", "created_by", "created_on", "modified_on")
VALUES
  ('a0000000-0000-0000-0000-000000000007', 'a0000000-0000-0000-0000-000000000006', 5, 1, 'Matriz SP', 80,
   'a0000000-0000-0000-0000-000000000006', now(), now());

-- 8) SQUADS (depende de MANAGERS)
INSERT INTO "squads"
  ("id", "code", "name", "manager_id", "description", "performance_avg")
VALUES
  ('a0000000-0000-0000-0000-000000000008', '12345678901', 'Squad Alpha', 'a0000000-0000-0000-0000-000000000007',
   'Squad responsável pela carteira de clientes premium', 75);

-- 9) SALESPERSONS (depende de USERS e SQUADS)
INSERT INTO "salespersons"
  ("id", "user_id", "total_meetings", "need_training", "squad_id")
VALUES
  ('a0000000-0000-0000-0000-000000000009', 'a0000000-0000-0000-0000-000000000006', 3, false,
   'a0000000-0000-0000-0000-000000000008');

-- 10) CLIENTS (depende de ADDRESSES e SQUADS)
INSERT INTO "clients"
  ("id", "name", "fantasy_name", "segment", "cnpj", "email", "phone", "address_id", "squad_id",
   "revenue", "status", "is_deleted")
VALUES
  ('a0000000-0000-0000-0000-00000000000a', 'Empresa Exemplo LTDA', 'Empresa Exemplo', 'Varejo',
   '12345678000199', 'contato@empresaexemplo.com', '1133334444', 'a0000000-0000-0000-0000-000000000001',
   'a0000000-0000-0000-0000-000000000008', 50000.00, 'GOOD', false);

-- 11) USER_PROFILES (PK composta; depende de USERS e PROFILES)
INSERT INTO "user_profiles"
  ("user_id", "profile_id")
VALUES
  ('a0000000-0000-0000-0000-000000000006', 'a0000000-0000-0000-0000-000000000002');

-- 12) MEETINGS (depende de CLIENTS e TRANSCRIPTS)
INSERT INTO "meetings"
  ("id", "totvs_id", "transcript_id", "client_represent", "title", "summary", "scheduled",
   "duration_min", "status", "performance_avg", "priority", "client_id", "is_deleted", "rating")
VALUES
  ('a0000000-0000-0000-0000-00000000000b', 'TOTVS-0001', 'a0000000-0000-0000-0000-000000000003',
   'Maria Representante', 'Reunião de alinhamento comercial', 'Discussão sobre renovação de contrato',
   '2026-09-10 10:00:00-03', 45, 'COMPLETED', 80, 'HIGH', 'a0000000-0000-0000-0000-00000000000a',
   false, 5);

-- 13) MEETING_EMPLOYEES (PK composta; depende de MEETINGS e USERS)
INSERT INTO "meeting_employees"
  ("meeting_id", "user_id")
VALUES
  ('a0000000-0000-0000-0000-00000000000b', 'a0000000-0000-0000-0000-000000000006');

-- 14) SESSIONS (depende de USERS)
INSERT INTO "sessions"
  ("id", "title", "last_activity", "created_on", "user_id", "model_used", "last_interaction_id",
   "is_deleted", "deleted_on")
VALUES
  ('a0000000-0000-0000-0000-00000000000c', 'Sessão de análise de reunião', now(), now(),
   'a0000000-0000-0000-0000-000000000006', 'PRO', 'int-0001', false, NULL);

-- 15) MESSAGES (depende de SESSIONS)
INSERT INTO "messages"
  ("id", "session_id", "role", "content", "created_on", "interaction_id")
VALUES
  ('a0000000-0000-0000-0000-00000000000d', 'a0000000-0000-0000-0000-00000000000c', 'SALESPERSON',
   'Qual foi a nota da última reunião?', now(), 'int-0001');

-- 16) TRANSCRIPT_CHUNKS (depende de TRANSCRIPTS)
INSERT INTO "transcript_chunks"
  ("id", "transcript_id", "chunk_text", "embedding", "created_at")
VALUES
  ('a0000000-0000-0000-0000-00000000000e', 'a0000000-0000-0000-0000-000000000003',
   'Trecho da transcrição referente à abertura da reunião.',
   ('[' || array_to_string(array_fill(0.01, ARRAY[384]), ',') || ']')::vector, now());

-- 17) AUDITS (depende de USERS, nullable)
INSERT INTO "audits"
  ("id", "entity_name", "user_id", "created_at", "previous", "new")
VALUES
  ('a0000000-0000-0000-0000-00000000000f', 'clients', 'a0000000-0000-0000-0000-000000000006', now(),
   '{"status": "OK"}'::jsonb, '{"status": "GOOD"}'::jsonb);

-- 18) MEETING_STRATEGIC_ANALYSES (depende de MEETINGS e CLIENTS)
INSERT INTO "meeting_strategic_analyses"
  ("id", "meeting_id", "client_id", "feedback", "tips", "company_status", "company_performance",
   "closing_probability", "flexibility", "risk", "financial_impact", "financial_impact_value",
   "financial_impact_status", "created_at")
VALUES
  ('a0000000-0000-0000-0000-000000000010', 'a0000000-0000-0000-0000-00000000000b',
   'a0000000-0000-0000-0000-00000000000a', 'Cliente demonstrou interesse na renovação.',
   'Reforçar benefícios do plano PRO.', 'GOOD', 8.50, 7.20, 6.00, 3.00, 7.00, 15000.00, 'MEDIUM', now());

-- 19) MEETING_PERFORMANCE_ANALYSES (depende de MEETINGS)
INSERT INTO "meeting_performance_analyses"
  ("id", "meeting_id", "feedback", "engagement", "communication_quality", "opportunities_seized",
   "objection_handling", "missed_opportunities", "leads_converted", "tips", "created_at")
VALUES
  ('a0000000-0000-0000-0000-000000000011', 'a0000000-0000-0000-0000-00000000000b',
   'Vendedor conduziu bem a reunião.', 8.00, 7.50, 6.50, 7.00, 1.00, 1, 'Melhorar o fechamento.', now());

-- 20) MEETING_STRATEGIC_SCORES (depende de MEETINGS e CLIENTS)
INSERT INTO "meeting_strategic_scores"
  ("id", "meeting_id", "client_id", "base_score", "multiplier", "wallet_percentage",
   "financial_impact_level", "financial_factor", "final_score", "calculated_at")
VALUES
  ('a0000000-0000-0000-0000-000000000012', 'a0000000-0000-0000-0000-00000000000b',
   'a0000000-0000-0000-0000-00000000000a', 75.00, 1.10, 12.500, 'MEDIO', 1.00, 82.50, now());

-- 21) MEETING_PERFORMANCE_SCORES (depende de MEETINGS e SALESPERSONS)
INSERT INTO "meeting_performance_scores"
  ("id", "meeting_id", "salesperson_id", "base_score", "multiplier", "streak_type", "streak_count",
   "final_score", "calculated_at")
VALUES
  ('a0000000-0000-0000-0000-000000000013', 'a0000000-0000-0000-0000-00000000000b',
   'a0000000-0000-0000-0000-000000000009', 70.00, 1.05, 'ALTA', 3, 73.50, now());

-- 22) EMAIL (depende de TEMPLATE)
INSERT INTO "email"
  ("id", "from", "to", "subject", "body", "template_id", "status", "created_on", "updated_on", "scheduled_at")
VALUES
  ('a0000000-0000-0000-0000-000000000014', 'no-reply@empresa.com', 'joao.silva@empresa.com',
   'Boas-vindas', 'Olá João, seja bem-vindo(a)!', 'a0000000-0000-0000-0000-000000000005',
   'PENDING', now(), now(), NULL);

-- 23) MEETING_STAKEHOLDERS (depende de MEETINGS)
INSERT INTO "meeting_stakeholders"
  ("id", "meeting_id", "name", "role", "side", "created_at")
VALUES
  ('a0000000-0000-0000-0000-000000000015', 'a0000000-0000-0000-0000-00000000000b', 'Maria Representante',
   'Diretora Financeira', 'CLIENT', now());

-- 24) MEETING_PREDICTS (depende de MEETINGS)
INSERT INTO "meeting_predicts"
  ("id", "meeting_id", "predict", "status", "reprocess", "created_at")
VALUES
  ('a0000000-0000-0000-0000-000000000016', 'a0000000-0000-0000-0000-00000000000b',
   'Previsão de fechamento em 30 dias.', 'CREATED', false, now());
